package manasTrainingService.service.impl.course;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseApplicationEmployeeDTO;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.CourseApplicationEmployee;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.TargetType;
import manasTrainingService.exceptions.nsee.user.UserNotFoundException;
import manasTrainingService.repositories.course.CourseApplicationEmployeeRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.course.CourseApplicationEmployeeService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseApplicationEmployeeServiceImpl implements CourseApplicationEmployeeService {

    private final CourseApplicationEmployeeRepository employeeRepository;
    private final ActivityLogService activityLogService;
    private final UserService userService;

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
        boolean isNew = employee.getId() == null;
        CourseApplicationEmployee saved = employeeRepository.save(employee);
        activityLogService.log(
                userService.getAuthorizedUser(),
                isNew ? ActionType.CREATE : ActionType.UPDATE,
                TargetType.COURSE_APPLICATION_EMPLOYEE,
                saved.getId()
        );
    }
}
