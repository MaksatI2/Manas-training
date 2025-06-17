package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.entity.CourseApplicationEmployee;
import manasTrainingService.entity.Status;
import manasTrainingService.repositories.CourseApplicationEmployeeRepository;

import manasTrainingService.service.CourseApplicationEmployeeService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CourseApplicationEmployeeServiceImpl implements CourseApplicationEmployeeService {

    private final CourseApplicationEmployeeRepository employeeRepository;

    @Override
    public List<CourseApplicationEmployee> getPendingEmployeesForCourse(Integer courseId) {
        return employeeRepository.findByApplicationCourseIdAndApplicationStatus(courseId, Status.PENDING);
    }

    @Override
    public void approveEmployee(Integer applicationId, Integer employeeId) {
        CourseApplicationEmployee employee = employeeRepository
                .findByApplicationIdAndEmployeeId(applicationId, employeeId)
                .orElseThrow(() -> new IllegalArgumentException("Сотрудник не найден"));
        employee.setApplicationStatus(Status.APPROVED);
        employeeRepository.save(employee);
    }

    @Override
    public void rejectEmployee(Integer applicationId, Integer employeeId) {
        CourseApplicationEmployee employee = employeeRepository
                .findByApplicationIdAndEmployeeId(applicationId, employeeId)
                .orElseThrow(() -> new IllegalArgumentException("Сотрудник не найден"));
        employee.setApplicationStatus(Status.REJECTED);
        employeeRepository.save(employee);
    }
}
