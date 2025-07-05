package manasTrainingService.service.impl;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.application.*;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.BadRequestException;
import manasTrainingService.exceptions.nsee.NotFoundException;
import manasTrainingService.repositories.course.*;
import manasTrainingService.repositories.user.OrganizationRepository;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.CourseApplicationService;
import manasTrainingService.util.StatusUtil;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
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

    @Override
    @Transactional
    public void createApplicationForOrganization(CourseApplicationCreateDto dto, String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Пользователь не найден"));

        Organization org = organizationRepository.findByUserId(user.getId())
                .orElseThrow(() -> new BadRequestException("Организация не найдена для пользователя"));

        if (dto.getCourseId() == null || dto.getEmployeeIds() == null || dto.getEmployeeIds().isEmpty()) {
            throw new BadRequestException("Заполните все обязательные поля");
        }

        LocalDate now = LocalDate.now();
        if (dto.getPreferredStartDate() != null && dto.getPreferredStartDate().isBefore(now)) {
            throw new BadRequestException("Желаемая дата начала не может быть в прошлом");
        }
        if (dto.getPreferredEndDate() != null && dto.getPreferredEndDate().isBefore(now)) {
            throw new BadRequestException("Желаемая дата окончания не может быть в прошлом");
        }
        if (dto.getPreferredStartDate() != null && dto.getPreferredEndDate() != null && dto.getPreferredEndDate()
                .isBefore(dto.getPreferredStartDate())) {
            throw new BadRequestException("Дата окончания не может быть раньше даты начала");
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

        courseApplicationRepository.save(app);

        for (Integer empId : dto.getEmployeeIds()) {
            User emp = userRepository.findById(empId)
                    .orElseThrow(() -> new UsernameNotFoundException("Сотрудник не найден"));
            CourseApplicationEmployee cae = new CourseApplicationEmployee();
            cae.setApplication(app);
            cae.setEmployee(emp);
            courseApplicationEmployeeRepository.save(cae);
        }
    }

    @Override
    public List<CourseApplicationViewDto> getApplicationsForOrganization(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Пользователь не найден"));
        Integer orgId = organizationRepository.findByUserId(user.getId()).map(Organization::getId)
                .orElseThrow(() -> new NotFoundException("Организация не найдена"));

        return courseApplicationRepository.findByOrganizationId(orgId).stream().map(this::mapToViewDto).toList();
    }

    @Override
    public CourseApplicationViewDto getApplicationDetails(Integer id, String email) {
        CourseApplication app = courseApplicationRepository.findDetailedById(id)
                .orElseThrow(() -> new NotFoundException("Заявка не найдена"));

        if (!app.getSubmittedBy().getEmail().equals(email)) {
            throw new BadRequestException("Нет доступа к заявке");
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
                .orElseThrow(() -> new NotFoundException("Заявка не найдена"));
        return mapToViewDto(app);
    }

    @Override
    @Transactional
    public void updateApplicationStatus(Integer id, ApplicationStatusUpdateDto dto, String adminEmail) {
        CourseApplication app = courseApplicationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Заявка не найдена"));

        Status newStatus = dto.getNewStatus();
        if (app.getStatus() == Status.REJECTED && newStatus != Status.REJECTED) {
            throw new BadRequestException("Нельзя изменить статус отклонённой заявки");
        }
        if (newStatus == Status.REJECTED && (dto.getComment() == null || dto.getComment().isBlank())) {
            throw new BadRequestException("Комментарий обязателен при отклонении");
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
                throw new BadRequestException("Нельзя одобрить заявку, пока все сотрудники не зачислены на поток курса. "
                        + "Пожалуйста, перейдите в раздел 'Потоки курсов' и назначьте студентов вручную.");
            }

            app.setStatus(Status.APPROVED);
            courseApplicationRepository.save(app);

        } else {
            app.setStatus(newStatus);
            courseApplicationRepository.save(app);
        }
    }


    @Override
    public void addCommentToApplication(Integer appId, String comment, String authorEmail) {
        User author = userRepository.findByEmail(authorEmail).orElseThrow(()
                -> new NotFoundException("Автор комментария не найден"));

        CourseApplication app = courseApplicationRepository.findById(appId)
                .orElseThrow(() -> new NotFoundException("Заявка не найдена"));

        ApplicationComment c = new ApplicationComment();
        c.setApplication(app);
        c.setComment(comment);
        c.setAdmin(author);
        c.setCreatedAt(LocalDateTime.now());
        applicationCommentRepository.save(c);
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


    private CourseApplicationViewDto mapToViewDto(CourseApplication app) {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm");
        DateTimeFormatter df = DateTimeFormatter.ofPattern("dd.MM.yyyy");

        CourseApplicationViewDto dto = new CourseApplicationViewDto();
        dto.setId(app.getId());
        dto.setCourseTitle(app.getCourse().getTitle());
        dto.setOrganizationName(app.getOrganization().getUser().getName());
        dto.setOrganizationCode(app.getOrganization().getCode());
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

}
