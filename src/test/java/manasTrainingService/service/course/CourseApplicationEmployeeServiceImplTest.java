package manasTrainingService.service.course;

import manasTrainingService.dto.instance.CourseApplicationEmployeeDTO;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.user.UserNotFoundException;
import manasTrainingService.repositories.course.CourseApplicationEmployeeRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.impl.course.CourseApplicationEmployeeServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CourseApplicationEmployeeService Tests")
class CourseApplicationEmployeeServiceImplTest {

    @Mock
    private CourseApplicationEmployeeRepository employeeRepository;

    @Mock
    private ActivityLogService activityLogService;

    @Mock
    private UserService userService;

    @Mock
    private MessageSource messageSource;

    @InjectMocks
    private CourseApplicationEmployeeServiceImpl courseApplicationEmployeeService;

    private User employee;
    private CourseApplication application;
    private CourseApplicationEmployee courseApplicationEmployee;

    @BeforeEach
    void setUp() {
        employee = User.builder()
                .id(1)
                .name("Jane")
                .lastName("Smith")
                .build();

        application = CourseApplication.builder()
                .id(1)
                .build();

        courseApplicationEmployee = CourseApplicationEmployee.builder()
                .id(1)
                .employee(employee)
                .application(application)
                .applicationStatus(Status.PENDING)
                .build();
    }

    @Test
    @DisplayName("Should get pending employees for course instance")
    void shouldGetPendingEmployeesForCourseInstance() {
        Integer courseInstanceId = 1;
        List<CourseApplicationEmployee> pendingEmployees = Arrays.asList(courseApplicationEmployee);

        when(employeeRepository.findByApplication_Course_IdAndApplicationStatus(courseInstanceId, Status.PENDING))
                .thenReturn(pendingEmployees);

        List<CourseApplicationEmployeeDTO> result = courseApplicationEmployeeService
                .getPendingEmployeesForCourseInstance(courseInstanceId);

        assertThat(result).hasSize(1);
        CourseApplicationEmployeeDTO dto = result.get(0);
        assertThat(dto.getId()).isEqualTo(1);
        assertThat(dto.getEmployeeId()).isEqualTo(1);
        assertThat(dto.getEmployeeName()).isEqualTo("Jane");
        assertThat(dto.getApplicationId()).isEqualTo(1);
        assertThat(dto.getApplicationStatus()).isEqualTo(Status.PENDING);

        verify(employeeRepository).findByApplication_Course_IdAndApplicationStatus(courseInstanceId, Status.PENDING);
    }

    @Test
    @DisplayName("Should return empty list when no pending employees found")
    void shouldReturnEmptyListWhenNoPendingEmployeesFound() {
        Integer courseInstanceId = 1;
        when(employeeRepository.findByApplication_Course_IdAndApplicationStatus(courseInstanceId, Status.PENDING))
                .thenReturn(Arrays.asList());

        List<CourseApplicationEmployeeDTO> result = courseApplicationEmployeeService
                .getPendingEmployeesForCourseInstance(courseInstanceId);

        assertThat(result).isEmpty();
        verify(employeeRepository).findByApplication_Course_IdAndApplicationStatus(courseInstanceId, Status.PENDING);
    }

    @Test
    @DisplayName("Should get employee by ID successfully")
    void shouldGetEmployeeByIdSuccessfully() {
        Integer employeeId = 1;
        when(employeeRepository.findById(employeeId)).thenReturn(Optional.of(courseApplicationEmployee));

        CourseApplicationEmployee result = courseApplicationEmployeeService.getEmployeeById(employeeId);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1);
        assertThat(result.getEmployee().getName()).isEqualTo("Jane");
        assertThat(result.getApplicationStatus()).isEqualTo(Status.PENDING);

        verify(employeeRepository).findById(employeeId);
    }

    @Test
    @DisplayName("Should throw UserNotFoundException when employee not found")
    void shouldThrowUserNotFoundExceptionWhenEmployeeNotFound() {
        Integer employeeId = 999;
        String errorMessage = "User not found";
        Locale currentLocale = Locale.ENGLISH;

        when(employeeRepository.findById(employeeId)).thenReturn(Optional.empty());
        when(messageSource.getMessage("user.not.found", null, currentLocale))
                .thenReturn(errorMessage);

        try (var mockedStatic = mockStatic(LocaleContextHolder.class)) {
            mockedStatic.when(LocaleContextHolder::getLocale).thenReturn(currentLocale);

            assertThatThrownBy(() -> courseApplicationEmployeeService.getEmployeeById(employeeId))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(errorMessage);
        }

        verify(employeeRepository).findById(employeeId);
        verify(messageSource).getMessage("user.not.found", null, currentLocale);
    }

    @Test
    @DisplayName("Should save new employee and log CREATE activity")
    void shouldSaveNewEmployeeAndLogCreateActivity() {
        CourseApplicationEmployee newEmployee = CourseApplicationEmployee.builder()
                .employee(employee)
                .application(application)
                .applicationStatus(Status.PENDING)
                .build();

        CourseApplicationEmployee savedEmployee = CourseApplicationEmployee.builder()
                .id(10)
                .employee(employee)
                .application(application)
                .applicationStatus(Status.PENDING)
                .build();

        User authorizedUser = User.builder().id(5).build();

        when(employeeRepository.save(newEmployee)).thenReturn(savedEmployee);
        when(userService.getAuthorizedUser()).thenReturn(authorizedUser);

        courseApplicationEmployeeService.save(newEmployee);

        verify(employeeRepository).save(newEmployee);
        verify(activityLogService).log(
                eq(authorizedUser),
                eq(ActionType.CREATE),
                eq(TargetType.COURSE_APPLICATION_EMPLOYEE),
                eq(10)
        );
    }

    @Test
    @DisplayName("Should save existing employee and log UPDATE activity")
    void shouldSaveExistingEmployeeAndLogUpdateActivity() {
        CourseApplicationEmployee existingEmployee = CourseApplicationEmployee.builder()
                .id(5)
                .employee(employee)
                .application(application)
                .applicationStatus(Status.APPROVED)
                .build();

        User authorizedUser = User.builder().id(5).build();

        when(employeeRepository.save(existingEmployee)).thenReturn(existingEmployee);
        when(userService.getAuthorizedUser()).thenReturn(authorizedUser);

        courseApplicationEmployeeService.save(existingEmployee);

        verify(employeeRepository).save(existingEmployee);
        verify(activityLogService).log(
                eq(authorizedUser),
                eq(ActionType.UPDATE),
                eq(TargetType.COURSE_APPLICATION_EMPLOYEE),
                eq(5)
        );
    }

    @Test
    @DisplayName("Should handle multiple pending employees correctly")
    void shouldHandleMultiplePendingEmployeesCorrectly() {
        Integer courseInstanceId = 1;

        User employee2 = User.builder()
                .id(2)
                .name("John")
                .lastName("Doe")
                .build();

        CourseApplication application2 = CourseApplication.builder()
                .id(2)
                .build();

        CourseApplicationEmployee employee2App = CourseApplicationEmployee.builder()
                .id(2)
                .employee(employee2)
                .application(application2)
                .applicationStatus(Status.PENDING)
                .build();

        List<CourseApplicationEmployee> pendingEmployees = Arrays.asList(courseApplicationEmployee, employee2App);

        when(employeeRepository.findByApplication_Course_IdAndApplicationStatus(courseInstanceId, Status.PENDING))
                .thenReturn(pendingEmployees);

        List<CourseApplicationEmployeeDTO> result = courseApplicationEmployeeService
                .getPendingEmployeesForCourseInstance(courseInstanceId);

        assertThat(result).hasSize(2);

        CourseApplicationEmployeeDTO dto1 = result.get(0);
        assertThat(dto1.getId()).isEqualTo(1);
        assertThat(dto1.getEmployeeName()).isEqualTo("Jane");

        CourseApplicationEmployeeDTO dto2 = result.get(1);
        assertThat(dto2.getId()).isEqualTo(2);
        assertThat(dto2.getEmployeeName()).isEqualTo("John");

        verify(employeeRepository).findByApplication_Course_IdAndApplicationStatus(courseInstanceId, Status.PENDING);
    }

    @Test
    @DisplayName("Should convert entity to DTO correctly")
    void shouldConvertEntityToDtoCorrectly() {
        Integer courseInstanceId = 1;
        List<CourseApplicationEmployee> employees = Arrays.asList(courseApplicationEmployee);

        when(employeeRepository.findByApplication_Course_IdAndApplicationStatus(courseInstanceId, Status.PENDING))
                .thenReturn(employees);

        List<CourseApplicationEmployeeDTO> result = courseApplicationEmployeeService
                .getPendingEmployeesForCourseInstance(courseInstanceId);

        assertThat(result).hasSize(1);
        CourseApplicationEmployeeDTO dto = result.get(0);

        assertThat(dto.getId()).isEqualTo(courseApplicationEmployee.getId());
        assertThat(dto.getEmployeeId()).isEqualTo(courseApplicationEmployee.getEmployee().getId());
        assertThat(dto.getEmployeeName()).isEqualTo(courseApplicationEmployee.getEmployee().getName());
        assertThat(dto.getApplicationId()).isEqualTo(courseApplicationEmployee.getApplication().getId());
        assertThat(dto.getApplicationStatus()).isEqualTo(courseApplicationEmployee.getApplicationStatus());
    }
}