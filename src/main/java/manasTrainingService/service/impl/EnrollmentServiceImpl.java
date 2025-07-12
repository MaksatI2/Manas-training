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
import manasTrainingService.service.course.CourseApplicationEmployeeService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.user.UserService;
import manasTrainingService.util.DateUtil;
import manasTrainingService.util.StatusUtil;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EnrollmentServiceImpl implements EnrollmentService {
    private final CourseEnrollmentRepository enrollmentRepository;
    private final CourseInstanceService courseInstanceService;
    private final CourseApplicationEmployeeService courseApplicationEmployeeService;
    private final UserService userService;
    private final ActivityLogService activityLogService;

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
    public List<CourseEnrollmentCardDTO> getStudentCourses() {
        User user = userService.getAuthorizedUser();
        List<CourseEnrollment> enrollments = getStudentEnrollments(user.getId());

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
        if (!enrollmentRepository.existsByCourseInstanceIdAndStudentIdAndStatus(courseInstanceId, user.getId(), Status.ENROLLED)) {
            throw new NoAccessException("У вас нет доступа к курсу");
        };
    }

    @Override
    public List<CourseEnrollment> findAllEnrollmentsForCourseInstance(Integer courseInstanceId) {
        return enrollmentRepository.findAllByCourseInstanceId(courseInstanceId);
    }

    @Override
    public void changeEnrollmentStatus(Integer enrollmentId, Status newStatus) {
        CourseEnrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new EntityNotFoundException("Запись на курс не была найдена"));

        enrollment.setStatus(newStatus);
        CourseEnrollment saved = enrollmentRepository.save(enrollment);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.COURSE_ENROLLMENT,
                saved.getId()
        );
    }

}
