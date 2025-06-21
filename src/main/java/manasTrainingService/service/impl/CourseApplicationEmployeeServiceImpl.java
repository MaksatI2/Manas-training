package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseApplicationEmployeeDTO;
import manasTrainingService.entity.CourseApplicationEmployee;
import manasTrainingService.entity.Status;
import manasTrainingService.exceptions.nsee.UserNotFoundException;
import manasTrainingService.repositories.CourseApplicationEmployeeRepository;
import manasTrainingService.service.CourseApplicationEmployeeService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

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

    @Override
    public List<CourseApplicationEmployeeDTO> getPendingEmployeesForCourseInstance(Integer courseInstanceId) {
        return employeeRepository
                .findByApplication_Course_IdAndApplicationStatus(courseInstanceId, Status.PENDING)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    private CourseApplicationEmployeeDTO toDto(CourseApplicationEmployee employee) {
        CourseApplicationEmployeeDTO dto = new CourseApplicationEmployeeDTO();
        dto.setId(employee.getId());
        dto.setEmployeeId(employee.getEmployee().getId());
        dto.setEmployeeName(employee.getEmployee().getName());
        dto.setApplicationId(employee.getApplication().getId());
        dto.setApplicationStatus(employee.getApplicationStatus());
        return dto;
    }

    @Override
    public CourseApplicationEmployee getEmployeeById(Integer employeeId) {
        return employeeRepository.findById(employeeId).orElseThrow(() -> new UserNotFoundException("Пользователь не был найден"));
    }

    @Override
    public void save(CourseApplicationEmployee employee) {
        employeeRepository.save(employee);
    }
}
