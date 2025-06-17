package manasTrainingService.service;

import manasTrainingService.entity.CourseApplicationEmployee;

import java.util.List;

public interface CourseApplicationEmployeeService {
    List<CourseApplicationEmployee> getPendingEmployeesForCourse(Integer courseId);

    void approveEmployee(Integer applicationId, Integer employeeId);

    void rejectEmployee(Integer applicationId, Integer employeeId);
}