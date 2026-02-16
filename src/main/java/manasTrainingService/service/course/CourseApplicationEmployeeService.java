package manasTrainingService.service.course;

import manasTrainingService.dto.instance.CourseApplicationEmployeeDTO;
import manasTrainingService.entity.CourseApplicationEmployee;

import java.util.List;

public interface CourseApplicationEmployeeService {
    List<CourseApplicationEmployeeDTO> getPendingEmployeesForCourseInstance(Integer courseInstanceId);

    CourseApplicationEmployee getEmployeeById(Integer employeeId);

    void save(CourseApplicationEmployee employee);
}