package manasTrainingService.service;

import manasTrainingService.dto.instance.CourseEnrollmentCardDTO;
import manasTrainingService.dto.instance.CourseEnrollmentDTO;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.TestResult;

import java.util.List;
import java.util.Optional;

public interface EnrollmentService {
    void enrollEmployees(Integer courseInstanceId, List<Integer> employeeIds);

    List<CourseEnrollmentDTO> getEnrollmentsByCourseInstanceId(Integer courseInstanceId);

    Optional<CourseEnrollment> findByStudentAndInstance(Integer studentId, Integer courseInstanceId);

    List<CourseEnrollment> getStudentEnrollments(Integer studentId);

    List<CourseEnrollmentCardDTO> getStudentCourses();

    List<CourseEnrollmentCardDTO> getStudentFinishedCourses();

    void hasAccess(Integer courseInstanceId);

    List<CourseEnrollment> findAllEnrollmentsForCourseInstance(Integer courseInstanceId);

    void changeEnrollmentStatus(Integer enrollmentId, Status newStatus);

    List<CourseInstance> getCompletedCourseInstances(Integer studentId);

    List<CourseEnrollment> findAllActiveEnrollmentsByStudentId(Integer studentId);

    void courseComplete(TestResult testResult);
}
