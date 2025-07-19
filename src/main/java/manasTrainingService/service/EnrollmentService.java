package manasTrainingService.service;

import manasTrainingService.dto.instance.CourseEnrollmentCardDTO;
import manasTrainingService.dto.instance.CourseEnrollmentDTO;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.Status;

import java.util.List;

public interface EnrollmentService {
    void enrollEmployees(Integer courseInstanceId, List<Integer> employeeIds);

    List<CourseEnrollmentDTO> getEnrollmentsByCourseInstanceId(Integer courseInstanceId);

    List<CourseEnrollment> getStudentEnrollments(Integer studentId);

    List<CourseEnrollmentCardDTO> getStudentCourses();

    void hasAccess(Integer courseInstanceId);

    List<CourseEnrollment> findAllEnrollmentsForCourseInstance(Integer courseInstanceId);

    void changeEnrollmentStatus(Integer enrollmentId, Status newStatus);

    List<CourseEnrollment> findAllActiveEnrollmentsByStudentId(Integer studentId);
}
