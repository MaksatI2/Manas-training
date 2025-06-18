package manasTrainingService.service;

import manasTrainingService.dto.instance.CourseEnrollmentCardDTO;
import manasTrainingService.dto.instance.CourseEnrollmentDTO;
import manasTrainingService.entity.CourseEnrollment;

import java.util.List;

public interface EnrollmentService {
    void enrollEmployees(Integer courseInstanceId, List<Integer> employeeIds);

    List<CourseEnrollmentDTO> getEnrollmentsByCourseInstanceId(Integer courseInstanceId);

    List<CourseEnrollment> getStudentEnrollments(Integer studentId);

    List<CourseEnrollmentCardDTO> getStudentCourses();

    void hasAccess(Integer courseInstanceId);
}
