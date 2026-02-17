package manasTrainingService.service.impl;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseEnrollmentCardDTO;
import manasTrainingService.dto.instance.CourseEnrollmentDTO;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.repositories.course.CourseEnrollmentRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.NotificationService;
import manasTrainingService.service.course.CourseApplicationEmployeeService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.user.UserService;
import manasTrainingService.util.DateUtil;
import manasTrainingService.util.StatusUtil;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EnrollmentServiceImpl implements EnrollmentService {
    private final CourseEnrollmentRepository enrollmentRepository;
    private final CourseInstanceService courseInstanceService;
    private final CourseApplicationEmployeeService courseApplicationEmployeeService;
    private final UserService userService;
    private final ActivityLogService activityLogService;
    private final CourseEnrollmentRepository courseEnrollmentRepository;
    private final NotificationService notificationService;
    private final MessageSource messageSource;

    @Override
    public void enrollEmployees(Integer courseInstanceId, List<Integer> employeeIds) {
        CourseInstance courseInstance = courseInstanceService.getCourseInstanceModelById(courseInstanceId);

        for (Integer employeeId : employeeIds) {
            CourseApplicationEmployee employee = courseApplicationEmployeeService.getEmployeeById(employeeId);
            if (employee.getApplicationStatus() != Status.PENDING)
                continue;

            User student = employee.getEmployee();

            if (!enrollmentRepository.existsByCourseInstanceIdAndStudentId(courseInstanceId, student.getId())) {
                CourseEnrollment enrollment = CourseEnrollment.builder()
                        .courseInstance(courseInstance)
                        .student(student)
                        .status(Status.ENROLLED)
                        .build();
                CourseEnrollment saved = enrollmentRepository.save(enrollment);
                activityLogService.log(
                        userService.getAuthorizedUser(),
                        ActionType.CREATE,
                        TargetType.COURSE_ENROLLMENT,
                        saved.getId()
                );
                notificationService.notifyStudentEnrolledToCourse(student, courseInstance);


                employee.setApplicationStatus(Status.APPROVED);
                courseApplicationEmployeeService.save(employee);
            }
        }
    }

    @Override
    public List<CourseEnrollmentDTO> getEnrollmentsByCourseInstanceId(Integer courseInstanceId) {
        return enrollmentRepository.findByCourseInstanceId(courseInstanceId).stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<CourseEnrollment> findByStudentAndInstance(Integer studentId, Integer courseInstanceId) {
        return enrollmentRepository
                .findByStudentIdAndCourseInstanceId(studentId, courseInstanceId)
                .stream()
                .findFirst();
    }

    private CourseEnrollmentDTO toDto(CourseEnrollment enrollment) {
        CourseEnrollmentDTO dto = new CourseEnrollmentDTO();
        dto.setId(enrollment.getId());
        dto.setStudentId(enrollment.getStudent().getId());
        dto.setStudentName(enrollment.getStudent().getName());
        dto.setEnrollmentDate(enrollment.getEnrollmentDate());
        dto.setStatus(enrollment.getStatus());
        dto.setFormattedEnrollmentDate(
                DateUtil.formatDateOnly(
                        enrollment.getEnrollmentDate()
                )
        );
        dto.setProgressPercentage(enrollment.getProgressPercentage());
        dto.setFinalGrade(enrollment.getFinalGrade());
        return dto;
    }

    @Override
    public List<CourseEnrollment> getStudentEnrollments(Integer studentId) {
        return enrollmentRepository.findAllByStudentIdAndStatus(studentId, Status.ENROLLED);
    }

    @Override
    public List<CourseEnrollment> getAllEnrollmentsByStudentId(Integer studentId) {
        return enrollmentRepository.findAllByStudentId(studentId);
    }

    @Override
    public List<CourseEnrollmentCardDTO> getStudentCourses() {
        User user = userService.getAuthorizedUser();
        List<CourseEnrollment> enrollments = getStudentEnrollments(user.getId());

        return getCourseEnrollmentCardDTOS(enrollments);
    }

    @Override
    public List<CourseEnrollmentCardDTO> getStudentFinishedCourses() {
        User user = userService.getAuthorizedUser();
        List<CourseEnrollment> enrollments = enrollmentRepository.findAllByStudentIdAndStatus(user.getId(), Status.COMPLETED);


        return getCourseEnrollmentCardDTOS(enrollments);
    }

    private List<CourseEnrollmentCardDTO> getCourseEnrollmentCardDTOS(List<CourseEnrollment> enrollments) {
        return enrollments.stream()
                .map(enrollment -> CourseEnrollmentCardDTO.builder()
                        .courseInstanceId(enrollment.getCourseInstance().getId())
                        .courseTitle(enrollment.getCourseInstance().getCourse().getTitle())
                        .instanceTitle(enrollment.getCourseInstance().getTitle())
                        .startDate(DateUtil.formatDateOnly(enrollment.getCourseInstance().getStartDate()))
                        .endDate(DateUtil.formatDateOnly(enrollment.getCourseInstance().getEndDate()))
                        .status(enrollment.getStatus())
                        .localizedStatus(StatusUtil.localize(enrollment.getStatus()))
                        .build())
                .toList();
    }

    @Override
    public void hasAccess(Integer courseInstanceId) {
        User user = userService.getAuthorizedUser();
        if (!enrollmentRepository.existsByCourseInstanceIdAndStudentIdAndStatus(courseInstanceId, user.getId(), Status.ENROLLED)
                && !enrollmentRepository.existsByCourseInstanceIdAndStudentIdAndStatus(courseInstanceId, user.getId(), Status.COMPLETED)) {
            throw new NoAccessException(messageSource.getMessage("course.no.access", null, LocaleContextHolder.getLocale()));
        }

    }

    @Override
    public List<CourseEnrollment> findAllEnrollmentsForCourseInstance(Integer courseInstanceId) {
        return enrollmentRepository.findAllByCourseInstanceId(courseInstanceId);
    }

    @Override
    public void changeEnrollmentStatus(Integer enrollmentId, Status newStatus) {
        CourseEnrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new EntityNotFoundException(
                        messageSource.getMessage("course.registration.not.found", null, LocaleContextHolder.getLocale())
                ));
        enrollment.setStatus(newStatus);
        CourseEnrollment saved = enrollmentRepository.save(enrollment);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.COURSE_ENROLLMENT,
                saved.getId()
        );
        notificationService.notifyStudentAboutEnrollmentStatusChange(saved.getStudent(), saved.getCourseInstance(), newStatus);

    }

    @Override
    public List<CourseInstance> getCompletedCourseInstances(Integer studentId) {
        return enrollmentRepository.findCompletedCourseInstancesByStudentId(studentId);
    }

    @Override
    public List<CourseEnrollment> findAllActiveEnrollmentsByStudentId(Integer studentId) {
        return enrollmentRepository.findAllActiveEnrollmentsByStudentId(studentId);
    }

    @Override
    public void courseComplete(TestResult testResult){
        User user = userService.getAuthorizedUser();
        CourseEnrollment courseEnrollment = courseEnrollmentRepository.findByCourseInstanceIdAndStudentId(testResult.getTestInstance().getInstance().getId(), user.getId())
                .orElseThrow(() -> new EntityNotFoundException(
                        messageSource.getMessage("course.registration.not.found", null, LocaleContextHolder.getLocale())
                ));
        courseEnrollment.setStatus(Status.COMPLETED);
        courseEnrollment.setCompletionDate(LocalDateTime.now());
        courseEnrollment.setFinalGrade(testResult.getScore());
        courseEnrollmentRepository.saveAndFlush(courseEnrollment);
        notificationService.notifyAdminsAboutCourseCompletion(courseEnrollment);

    }

}
