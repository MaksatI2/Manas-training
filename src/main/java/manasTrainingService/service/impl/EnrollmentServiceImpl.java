package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseEnrollmentDTO;
import manasTrainingService.entity.CourseApplicationEmployee;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.User;
import manasTrainingService.repositories.CourseEnrollmentRepository;
import manasTrainingService.service.CourseApplicationEmployeeService;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.UserService;
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


    @Override
    public void enrollEmployees(Integer courseInstanceId, List<Integer> employeeIds) {
        CourseInstance courseInstance = courseInstanceService.getCourseInstanceModelById(courseInstanceId);

        for (Integer employeeId : employeeIds) {
            CourseApplicationEmployee employee = courseApplicationEmployeeService.getEmployeeById(employeeId);
            if (employee.getApplicationStatus() != Status.PENDING) {
                continue;
            }

            User student = userService.getUserById(employeeId);

            if (!enrollmentRepository.existsByCourseInstanceIdAndStudentId(courseInstanceId, student.getId())) {
                CourseEnrollment enrollment = CourseEnrollment.builder()
                        .courseInstance(courseInstance)
                        .student(student)
                        .status(Status.ENROLLED)
                        .build();
                enrollmentRepository.save(enrollment);

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
        dto.setProgressPercentage(enrollment.getProgressPercentage());
        dto.setFinalGrade(enrollment.getFinalGrade());
        return dto;
    }
}
