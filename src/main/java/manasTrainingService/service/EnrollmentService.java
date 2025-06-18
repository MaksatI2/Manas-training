package manasTrainingService.service;

import manasTrainingService.dto.instance.CourseEnrollmentDTO;

import java.util.List;

public interface EnrollmentService {
    void enrollEmployees(Integer courseInstanceId, List<Integer> employeeIds);

    List<CourseEnrollmentDTO> getEnrollmentsByCourseInstanceId(Integer courseInstanceId);
}
