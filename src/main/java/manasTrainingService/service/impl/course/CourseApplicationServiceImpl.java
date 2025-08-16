package manasTrainingService.service.impl.course;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.ShortDto;
import manasTrainingService.dto.application.*;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.BadRequestException;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.exceptions.nsee.NotFoundException;
import manasTrainingService.exceptions.nsee.user.UserNotFoundException;
import manasTrainingService.repositories.course.*;
import manasTrainingService.repositories.user.OrganizationRepository;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.CourseApplicationService;
import manasTrainingService.service.NotificationService;
import manasTrainingService.service.user.EmailService;
import manasTrainingService.service.user.UserService;
import manasTrainingService.util.StatusUtil;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseApplicationServiceImpl implements CourseApplicationService {

    private final CourseRepository courseRepository;
    private final CourseApplicationRepository courseApplicationRepository;
    private final CourseApplicationEmployeeRepository courseApplicationEmployeeRepository;
    private final ApplicationCommentRepository applicationCommentRepository;
    private final UserRepository userRepository;
    private final OrganizationRepository organizationRepository;
    private final CourseEnrollmentRepository courseEnrollmentRepository;
    private final CourseInstanceRepository courseInstanceRepository;
    private final ActivityLogService activityLogService;
    private final UserService userService;
    private final EmailService emailService;
    private final NotificationService notificationService;
    private final MessageSource messageSource;

    @Override
    @Transactional
    public void createApplicationForOrganization(CourseApplicationCreateDto dto, String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.not.found",
                                null,
                                "Пользователь не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        Organization org = organizationRepository.findByUserId(user.getId())
                .orElseThrow(() -> new BadRequestException(
                        messageSource.getMessage(
                                "organization.not.found.for.user",
                                null,
                                "Организация не найдена для пользователя",
                                LocaleContextHolder.getLocale()
                        )
                ));

        if (dto.getCourseId() == null || dto.getEmployeeIds() == null || dto.getEmployeeIds().isEmpty()) {
            throw new BadRequestException(messageSource.getMessage(
                    "required.fields.missing",
                    null,
                    "Заполните все обязательные поля",
                    LocaleContextHolder.getLocale()
            ));
        }

        LocalDate now = LocalDate.now();
        if (dto.getPreferredStartDate() != null && dto.getPreferredStartDate().isBefore(now)) {
            throw new BadRequestException(messageSource.getMessage(
                    "preferred.start.date.past",
                    null,
                    "Желаемая дата начала не может быть в прошлом",
                    LocaleContextHolder.getLocale()
            ));
        }

        if (dto.getPreferredEndDate() != null && dto.getPreferredEndDate().isBefore(now)) {
            throw new BadRequestException(messageSource.getMessage(
                    "preferred.end.date.past",
                    null,
                    "Желаемая дата окончания не может быть в прошлом",
                    LocaleContextHolder.getLocale()
            ));
        }

        if (dto.getPreferredStartDate() != null && dto.getPreferredEndDate() != null &&
                dto.getPreferredEndDate().isBefore(dto.getPreferredStartDate())) {
            throw new BadRequestException(messageSource.getMessage(
                    "end.date.before.start",
                    null,
                    "Дата окончания не может быть раньше даты начала",
                    LocaleContextHolder.getLocale()
            ));
        }


        CourseApplication app = new CourseApplication();
        app.setCourse(courseRepository.getReferenceById(dto.getCourseId()));
        app.setOrganization(org);
        app.setSubmittedBy(user);
        app.setSubmittedAt(LocalDateTime.now());
        app.setStatus(Status.PENDING);
        app.setOrganizationApplicationNumber(dto.getOutgoingCode());

        if (dto.getPreferredTeacherId() != null) {
            userRepository.findById(dto.getPreferredTeacherId()).ifPresent(app::setPreferredTeacher);
        }
        app.setPreferredStartDate(dto.getPreferredStartDate());
        app.setPreferredEndDate(dto.getPreferredEndDate());

        CourseApplication savedApp = courseApplicationRepository.save(app);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.CREATE,
                TargetType.COURSE_APPLICATION,
                savedApp.getId()
        );

        for (Integer empId : dto.getEmployeeIds()) {
            User emp = userRepository.findById(empId)
                    .orElseThrow(() -> new UserNotFoundException(
                            messageSource.getMessage(
                                    "employee.not.found",
                                    null,
                                    "Сотрудник не найден",
                                    LocaleContextHolder.getLocale()
                            )
                    ));
            CourseApplicationEmployee cae = new CourseApplicationEmployee();
            cae.setApplication(savedApp);
            cae.setEmployee(emp);
            CourseApplicationEmployee savedCae = courseApplicationEmployeeRepository.save(cae);
            activityLogService.log(
                    userService.getAuthorizedUser(),
                    ActionType.CREATE,
                    TargetType.COURSE_APPLICATION_EMPLOYEE,
                    savedCae.getId()
            );
        }
        notificationService.notifyAdminsAboutNewApplication(savedApp);

    }

    @Override
    public List<CourseApplicationViewDto> getApplicationsForOrganization(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.not.found",
                                null,
                                "Пользователь не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        return courseApplicationRepository.findBySubmittedById(user.getId()).stream().map(this::mapToViewDto).toList();
    }

    @Override
    public CourseApplicationViewDto getApplicationDetails(Integer id, String email) {
        CourseApplication app = courseApplicationRepository.findDetailedById(id)
                .orElseThrow(() -> new NotFoundException(
                        messageSource.getMessage(
                                "application.not.found",
                                null,
                                "Заявка не найдена",
                                LocaleContextHolder.getLocale()
                        )
                ));

        if (!app.getSubmittedBy().getEmail().equals(email)) {
            throw new NoAccessException("Нет доступа к заявке");
        }

        return mapToViewDto(app);
    }

    @Override
    public List<CourseApplicationViewDto> getAllApplicationsForAdmin() {
        return courseApplicationRepository.findAll().stream().map(this::mapToViewDto).toList();
    }

    @Override
    public CourseApplicationViewDto getApplicationDetailsForAdmin(Integer id) {
        CourseApplication app = courseApplicationRepository.findDetailedById(id)
                .orElseThrow(() -> new NotFoundException(
                        messageSource.getMessage(
                                "application.not.found",
                                null,
                                "Заявка не найдена",
                                LocaleContextHolder.getLocale()
                        )
                ));
        return mapToViewDto(app);
    }

    @Override
    @Transactional
    public void updateApplicationStatus(Integer id, ApplicationStatusUpdateDto dto, String adminEmail) {
        CourseApplication app = courseApplicationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException(
                        messageSource.getMessage(
                                "application.not.found",
                                null,
                                "Заявка не найдена",
                                LocaleContextHolder.getLocale()
                        )
                ));

        Status newStatus = dto.getNewStatus();
        if (app.getStatus() == Status.APPROVED) {
            throw new BadRequestException(messageSource.getMessage(
                    "application.status.approved.cannot.change",
                    null,
                    "Нельзя изменить статус принятой заявки",
                    LocaleContextHolder.getLocale()
            ));
        }

        if (app.getStatus() == Status.REJECTED && newStatus != Status.REJECTED) {
            throw new BadRequestException(messageSource.getMessage(
                    "application.status.rejected.cannot.change",
                    null,
                    "Нельзя изменить статус отклонённой заявки",
                    LocaleContextHolder.getLocale()
            ));
        }

        if (newStatus == Status.REJECTED && (dto.getComment() == null || dto.getComment().isBlank())) {
            throw new BadRequestException(messageSource.getMessage(
                    "application.comment.required.for.rejection",
                    null,
                    "Комментарий обязателен при отклонении",
                    LocaleContextHolder.getLocale()
            ));
        }


        if (dto.getComment() != null && !dto.getComment().isBlank()) {
            addCommentToApplication(id, dto.getComment(), adminEmail);
        }

        if (newStatus == Status.REJECTED) {
            app.setStatus(Status.REJECTED);
            courseApplicationRepository.save(app);

            List<CourseApplicationEmployee> applicationEmployees = courseApplicationEmployeeRepository
                    .findByApplicationId(app.getId());

            for (CourseApplicationEmployee cae : applicationEmployees) {
                cae.setApplicationStatus(Status.REJECTED);
            }
            courseApplicationEmployeeRepository.saveAll(applicationEmployees);


        } else if (newStatus == Status.APPROVED) {
            List<CourseApplicationEmployee> applicationEmployees = courseApplicationEmployeeRepository
                    .findByApplicationId(app.getId());

            boolean allApproved = applicationEmployees.stream().allMatch(cae
                    -> cae.getApplicationStatus() == Status.APPROVED);

            if (!allApproved) {
                throw new BadRequestException(messageSource.getMessage(
                        "application.cannot.approve.unenrolled.students",
                        null,
                        "Нельзя одобрить заявку, пока все сотрудники не зачислены на поток курса. Пожалуйста, перейдите в раздел Потоки курсов и назначьте студентов вручную.",
                        LocaleContextHolder.getLocale()
                ));
            }

            app.setStatus(Status.APPROVED);
            courseApplicationRepository.save(app);


        } else {
            app.setStatus(newStatus);
            courseApplicationRepository.save(app);

        }

        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.COURSE_APPLICATION,
                app.getId()
        );
        User applicant = app.getSubmittedBy();
        if (applicant != null) {
            String roleName = applicant.getRole().getName();
            if ("ORGANIZATION".equalsIgnoreCase(roleName)) {
                notificationService.notifyOrganizationAboutStatusChange(app);
            } else if ("STUDENT".equalsIgnoreCase(roleName)) {
                notificationService.notifyStudentAboutStatusChange(app);
            }
        }
    }


    @Override
    public void addCommentToApplication(Integer appId, String comment, String authorEmail) {
        User author = userRepository.findByEmail(authorEmail)
                .orElseThrow(() -> new NotFoundException(
                        messageSource.getMessage(
                                "comment.author.not.found",
                                null,
                                "Автор комментария не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));


        CourseApplication app = courseApplicationRepository.findById(appId)
                .orElseThrow(() -> new NotFoundException(
                        messageSource.getMessage(
                                "application.not.found",
                                null,
                                "Заявка не найдена",
                                LocaleContextHolder.getLocale()
                        )
                ));

        ApplicationComment c = new ApplicationComment();
        c.setApplication(app);
        c.setComment(comment);
        c.setAdmin(author);
        c.setCreatedAt(LocalDateTime.now());
        ApplicationComment saved = applicationCommentRepository.save(c);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.CREATE,
                TargetType.APPLICATION_COMMENT,
                saved.getId()
        );
        User applicant = app.getSubmittedBy();
        String roleName = applicant.getRole().getName();
        if ("ORGANIZATION".equalsIgnoreCase(roleName)) {
            notificationService.notifyOrganizationAboutComment(app, comment);
        } else if ("STUDENT".equalsIgnoreCase(roleName)) {
            notificationService.notifyStudentAboutComment(app, comment);
        }

    }

    @Override
    public List<ApplicationCommentDto> getCommentsForApplication(Integer appId) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm");

        return applicationCommentRepository.findAllByApplicationIdOrderByCreatedAtAsc(appId)
                .stream().map(c -> {
                    ApplicationCommentDto dto = new ApplicationCommentDto();
                    dto.setId(c.getId());
                    dto.setApplicationId(appId);
                    dto.setComment(c.getComment());
                    dto.setAuthorName(c.getAdmin().getName() + " " + c.getAdmin().getLastName());
                    dto.setCreatedAt(c.getCreatedAt());
                    dto.setFormattedCreatedAt(c.getCreatedAt() != null ? c.getCreatedAt().format(formatter) : null);
                    return dto;
                }).toList();
    }

    @Transactional
    @Override
    public void updateApplicationForOrganization(Integer id, CourseApplicationCreateDto dto, String email) {
        CourseApplication application = courseApplicationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException(
                        messageSource.getMessage(
                                "application.not.found",
                                null,
                                "Заявка не найдена",
                                LocaleContextHolder.getLocale()
                        )
                ));

        if (!application.getSubmittedBy().getEmail().equals(email)) {
            throw new BadRequestException(
                    messageSource.getMessage(
                            "application.access.denied",
                            null,
                            "Нет доступа к заявке",
                            LocaleContextHolder.getLocale()
                    )
            );
        }

        if (application.getStatus() != Status.PENDING) {
            throw new BadRequestException(
                    messageSource.getMessage(
                            "application.edit.only.pending",
                            null,
                            "Редактировать можно только заявку в статусе 'На рассмотрении'",
                            LocaleContextHolder.getLocale()
                    )
            );
        }


        if (dto.getCourseId() != null && !dto.getCourseId().equals(application.getCourse().getId())) {
            Course course = courseRepository.findById(dto.getCourseId())
                    .orElseThrow(() -> new NotFoundException(messageSource.getMessage("course.not.found.simple", null, LocaleContextHolder.getLocale())));
            application.setCourse(course);
        }

        application.setPreferredStartDate(dto.getPreferredStartDate());
        application.setPreferredEndDate(dto.getPreferredEndDate());

        if (dto.getPreferredTeacherId() != null) {
            userRepository.findById(dto.getPreferredTeacherId()).ifPresent(application::setPreferredTeacher);
        } else {
            application.setPreferredTeacher(null);
        }
        application.setOrganizationApplicationNumber(dto.getOutgoingCode());

        courseApplicationEmployeeRepository.deleteAllByApplicationId(application.getId());
        for (Integer empId : dto.getEmployeeIds()) {
            User emp = userRepository.findById(empId)
                    .orElseThrow(() -> new UserNotFoundException(
                            messageSource.getMessage(
                                    "employee.not.found",
                                    null,
                                    "Сотрудник не найден",
                                    LocaleContextHolder.getLocale()
                            )
                    ));
            CourseApplicationEmployee cae = new CourseApplicationEmployee();
            cae.setApplication(application);
            cae.setEmployee(emp);
            cae.setApplicationStatus(Status.PENDING);
            courseApplicationEmployeeRepository.save(cae);
        }

        courseApplicationRepository.save(application);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.APPLICATION,
                application.getId()
        );
    }


    @Override
    public List<CourseApplicationViewDto> getAllApplicationsByStudent(String email) {
        User student = userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.not.found",
                                null,
                                "Пользователь не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        return courseApplicationRepository.findBySubmittedById(student.getId())
                .stream().map(this::mapToViewDto)
                .collect(Collectors.toList());
    }

    @Transactional
    @Override
    public void createApplicationFromStudent(StudentCourseApplicationCreateDto dto, String email) {
        User student = userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.not.found",
                                null,
                                "Пользователь не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        if (dto.getCourseId() == null) {
            throw new BadRequestException(messageSource.getMessage(
                    "required.fields.missing",
                    null,
                    "Заполните все обязательные поля",
                    LocaleContextHolder.getLocale()
            ));
        }

        LocalDate now = LocalDate.now();
        if (dto.getPreferredStartDate() != null && dto.getPreferredStartDate().isBefore(now)) {
            throw new BadRequestException(messageSource.getMessage(
                    "preferred.start.date.past",
                    null,
                    "Желаемая дата начала не может быть в прошлом",
                    LocaleContextHolder.getLocale()
            ));
        }

        if (dto.getPreferredEndDate() != null && dto.getPreferredEndDate().isBefore(now)) {
            throw new BadRequestException(messageSource.getMessage(
                    "preferred.end.date.past",
                    null,
                    "Желаемая дата окончания не может быть в прошлом",
                    LocaleContextHolder.getLocale()
            ));
        }

        if (dto.getPreferredStartDate() != null && dto.getPreferredEndDate() != null &&
                dto.getPreferredEndDate().isBefore(dto.getPreferredStartDate())) {
            throw new BadRequestException(messageSource.getMessage(
                    "end.date.before.start",
                    null,
                    "Дата окончания не может быть раньше даты начала",
                    LocaleContextHolder.getLocale()
            ));
        }

        Course course = courseRepository.findById(dto.getCourseId())
                .orElseThrow(() -> new NotFoundException("Курс не найден"));

        CourseApplication application = new CourseApplication();
        application.setCourse(course);
        application.setSubmittedBy(student);
        application.setSubmittedAt(LocalDateTime.now());
        application.setStatus(Status.PENDING);
        application.setPreferredStartDate(dto.getPreferredStartDate());
        application.setPreferredEndDate(dto.getPreferredEndDate());


        if (dto.getPreferredTeacherId() != null) {
            userRepository.findById(dto.getPreferredTeacherId()).ifPresent(application::setPreferredTeacher);
        }

        CourseApplication ca = courseApplicationRepository.save(application);

        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.CREATE,
                TargetType.COURSE_APPLICATION,
                ca.getId()
        );
        CourseApplicationEmployee cae = new CourseApplicationEmployee();
        cae.setApplication(application);
        cae.setEmployee(student);
        cae.setApplicationStatus(Status.PENDING);

        courseApplicationEmployeeRepository.save(cae);
        notificationService.notifyAdminsAboutNewApplication(ca);

    }

    @Transactional
    @Override
    public void updateApplicationFromStudent(Integer id, StudentCourseApplicationCreateDto dto, String email) {
        CourseApplication application = courseApplicationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException(
                        messageSource.getMessage(
                                "application.not.found",
                                null,
                                "Заявка не найдена",
                                LocaleContextHolder.getLocale()
                        )
                ));

        if (!application.getSubmittedBy().getEmail().equals(email)) {
            throw new BadRequestException(
                    messageSource.getMessage(
                            "application.access.denied",
                            null,
                            "Нет доступа к заявке",
                            LocaleContextHolder.getLocale()
                    )
            );
        }

        if (application.getStatus() != Status.PENDING) {
            throw new BadRequestException(
                    messageSource.getMessage(
                            "application.edit.only.pending",
                            null,
                            "Редактировать можно только заявку в статусе 'На рассмотрении'",
                            LocaleContextHolder.getLocale()
                    )
            );
        }

        if (dto.getCourseId() != null && !dto.getCourseId().equals(application.getCourse().getId())) {
            Course course = courseRepository.findById(dto.getCourseId())
                    .orElseThrow(() -> new NotFoundException(messageSource.getMessage("course.not.found.simple", null, LocaleContextHolder.getLocale())));
            application.setCourse(course);
        }

        application.setPreferredStartDate(dto.getPreferredStartDate());
        application.setPreferredEndDate(dto.getPreferredEndDate());

        if (dto.getPreferredTeacherId() != null) {
            userRepository.findById(dto.getPreferredTeacherId()).ifPresent(application::setPreferredTeacher);
        } else {
            application.setPreferredTeacher(null);
        }

        courseApplicationRepository.save(application);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.COURSE_APPLICATION,
                application.getId()
        );
    }

    @Override
    @Transactional
    public void deleteApplicationById(Integer id, String email) {
        CourseApplication application = courseApplicationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException(
                        messageSource.getMessage(
                                "application.not.found",
                                null,
                                "Заявка не найдена",
                                LocaleContextHolder.getLocale()
                        )
                ));

        boolean isStudent = application.getSubmittedBy().getEmail().equals(email);
        boolean isOrganization = application.getOrganization() != null &&
                application.getOrganization().getUser().getEmail().equals(email);

        if (!isStudent && !isOrganization) {
            throw new BadRequestException(messageSource.getMessage("delete.application.no.access", null, LocaleContextHolder.getLocale()));
        }

        if (application.getStatus() != Status.PENDING) {
            throw new BadRequestException(messageSource.getMessage("delete.application.only.pending", null, LocaleContextHolder.getLocale()));
        }


        courseApplicationEmployeeRepository.deleteAllByApplicationId(application.getId());
        applicationCommentRepository.deleteAllByApplicationId(application.getId());
        courseApplicationRepository.delete(application);
    }


    private CourseApplicationViewDto mapToViewDto(CourseApplication app) {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm");
        DateTimeFormatter df = DateTimeFormatter.ofPattern("dd.MM.yyyy");

        CourseApplicationViewDto dto = new CourseApplicationViewDto();
        dto.setId(app.getId());
        dto.setCourseId(app.getCourse().getId());
        dto.setCourseTitle(app.getCourse().getTitle());
        if (app.getOrganization() != null) {
            dto.setOrganizationName(app.getOrganization().getUser().getName());
            dto.setOrganizationCode(app.getOrganization().getCode());
        } else {
            dto.setOrganizationName("Самостоятельный студент");
            dto.setOrganizationCode("—");
        }

        dto.setSubmittedAt(app.getSubmittedAt());
        dto.setFormattedSubmittedAt(app.getSubmittedAt() != null ? app.getSubmittedAt().format(dtf) : null);
        dto.setStatus(app.getStatus());
        dto.setLocalizedStatus(StatusUtil.localize(app.getStatus()));
        dto.setOutgoingCode(app.getOrganizationApplicationNumber());

        LocalDate start = app.getPreferredStartDate();
        LocalDate end = app.getPreferredEndDate();

        dto.setPreferredStartDate(start);
        dto.setPreferredEndDate(end);
        dto.setFormattedPreferredStartDate(start != null ? start.format(df) : null);
        dto.setFormattedPreferredEndDate(end != null ? end.format(df) : null);

        List<CourseApplicationEmployee> caeList = courseApplicationEmployeeRepository.findByApplicationId(app.getId());

        dto.setEmployees(caeList.stream().map(cae -> {
            User e = cae.getEmployee();
            EmployeeShortDto edto = new EmployeeShortDto();
            edto.setId(e.getId());
            edto.setFullName(e.getName() + " " + e.getLastName());
            edto.setEmail(e.getEmail());
            edto.setApplicationStatus(cae.getApplicationStatus());
            return edto;
        }).collect(Collectors.toList()));

        if (app.getPreferredTeacher() != null) {
            dto.setPreferredTeacher(app.getPreferredTeacher());
        }

        return dto;
    }

    @Override
    public List<ShortDto> getByCourseId(Integer courseId) {
        return courseApplicationRepository.findByCourseId(courseId)
                .stream()
                .map(a -> new ShortDto(a.getId(), a.getSubmittedBy().getName()))
                .toList();
    }

}
