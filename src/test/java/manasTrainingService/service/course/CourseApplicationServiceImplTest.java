package manasTrainingService.service.course;

import manasTrainingService.dto.application.ApplicationCommentDto;
import manasTrainingService.dto.application.ApplicationStatusUpdateDto;
import manasTrainingService.dto.application.CourseApplicationCreateDto;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.BadRequestException;
import manasTrainingService.repositories.course.*;
import manasTrainingService.repositories.user.OrganizationRepository;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.NotificationService;
import manasTrainingService.service.impl.course.CourseApplicationServiceImpl;
import manasTrainingService.service.user.EmailService;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.MessageSource;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CourseApplicationServiceImplTest {

    @Mock
    private CourseRepository courseRepository;
    @Mock
    private CourseApplicationRepository applicationRepository;
    @Mock
    private CourseApplicationEmployeeRepository employeeRepository;
    @Mock
    private ApplicationCommentRepository commentRepository;
    @Mock
    private UserRepository userRepository;
    @Mock
    private OrganizationRepository organizationRepository;
    @Mock
    private CourseEnrollmentRepository enrollmentRepository;
    @Mock
    private CourseInstanceRepository instanceRepository;
    @Mock
    private EmailService emailService;
    @Mock
    private NotificationService notificationService;
    @Mock
    private UserService userService;
    @Mock
    private ActivityLogService activityLogService;
    @Mock
    private MessageSource messageSource;

    @InjectMocks
    private CourseApplicationServiceImpl service;

    private User orgUser;
    private Organization organization;
    private Course course;

    @BeforeEach
    void setup() {

        orgUser = new User();
        orgUser.setId(1);
        orgUser.setEmail("org@example.com");

        organization = new Organization();
        organization.setId(100);
        organization.setUser(orgUser);

        course = new Course();
        course.setId(10);
        course.setTitle("Java Course");
    }

    @Test
    void createApplication_success() {
        CourseApplicationCreateDto dto = CourseApplicationCreateDto.builder()
                .courseId(10)
                .employeeIds(List.of(2, 3))
                .outgoingCode("CODE123")
                .build();

        when(userRepository.findByEmail("org@example.com")).thenReturn(Optional.of(orgUser));
        when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(organization));
        when(courseRepository.getReferenceById(10)).thenReturn(course);
        when(userRepository.findById(anyInt())).thenReturn(Optional.of(new User()));

        when(applicationRepository.save(any())).thenAnswer(invocation -> {
            CourseApplication app = invocation.getArgument(0);
            app.setId(1);
            return app;
        });

        when(employeeRepository.save(any())).thenAnswer(invocation -> {
            CourseApplicationEmployee cae = invocation.getArgument(0);
            cae.setId(1);
            return cae;
        });
        service.createApplicationForOrganization(dto, "org@example.com");

        verify(applicationRepository).save(any());
        verify(employeeRepository, times(2)).save(any());
    }

    @Test
    void createApplication_missingCourseId_throwsException() {
        CourseApplicationCreateDto dto = CourseApplicationCreateDto.builder()
                .employeeIds(List.of(2))
                .outgoingCode("OUT")
                .build();

        when(userRepository.findByEmail(any())).thenReturn(Optional.of(orgUser));
        when(organizationRepository.findByUserId(anyInt())).thenReturn(Optional.of(organization));

        when(messageSource.getMessage(anyString(), any(), anyString(), any()))
                .thenReturn("Test message");

        assertThrows(BadRequestException.class, () -> service.createApplicationForOrganization(dto, "org@example.com"));
    }

    @Test
    void updateApplicationStatus_rejectWithoutComment_throwsException() {
        CourseApplication app = new CourseApplication();
        app.setId(1);
        app.setStatus(Status.PENDING);

        when(applicationRepository.findById(1)).thenReturn(Optional.of(app));

        ApplicationStatusUpdateDto dto = new ApplicationStatusUpdateDto(Status.REJECTED, "");

        assertThrows(BadRequestException.class, () ->
                service.updateApplicationStatus(1, dto, "admin@example.com")
        );
    }

    @Test
    void updateApplicationStatus_approve_successAndEnrollEmployees() {
        CourseApplication app = new CourseApplication();
        app.setId(1);
        app.setStatus(Status.PENDING);

        Course course = new Course();
        course.setId(10);
        app.setCourse(course);

        User emp1 = new User();
        emp1.setId(100);
        emp1.setName("Emp1");

        User emp2 = new User();
        emp2.setId(101);
        emp2.setName("Emp2");

        CourseApplicationEmployee cae1 = new CourseApplicationEmployee();
        cae1.setId(1);
        cae1.setEmployee(emp1);
        cae1.setApplication(app);
        cae1.setApplicationStatus(Status.APPROVED);

        CourseApplicationEmployee cae2 = new CourseApplicationEmployee();
        cae2.setId(2);
        cae2.setEmployee(emp2);
        cae2.setApplication(app);
        cae2.setApplicationStatus(Status.APPROVED);

        List<CourseApplicationEmployee> employeeList = List.of(cae1, cae2);

        when(applicationRepository.findById(1)).thenReturn(Optional.of(app));
        when(employeeRepository.findByApplicationId(1)).thenReturn(employeeList);

        ApplicationStatusUpdateDto dto = new ApplicationStatusUpdateDto(Status.APPROVED, null);

        service.updateApplicationStatus(1, dto, "admin@example.com");

        assertEquals(Status.APPROVED, app.getStatus());
        verify(applicationRepository).save(app);

    }

    @Test
    void addComment_success() {
        User admin = new User();
        admin.setEmail("admin@example.com");
        admin.setName("A");
        admin.setLastName("B");

        Role studentRole = new Role();
        studentRole.setName("STUDENT");

        User applicant = new User();
        applicant.setRole(studentRole);

        CourseApplication app = new CourseApplication();
        app.setId(1);
        app.setSubmittedBy(applicant);

        when(userRepository.findByEmail("admin@example.com")).thenReturn(Optional.of(admin));
        when(applicationRepository.findById(1)).thenReturn(Optional.of(app));
        when(commentRepository.save(any())).thenAnswer(invocation -> {
            ApplicationComment comment = invocation.getArgument(0);
            comment.setId(1);
            return comment;
        });

        service.addCommentToApplication(1, "Тест", "admin@example.com");

        verify(commentRepository).save(any());
    }


    @Test
    void getComments_success() {
        ApplicationComment comment = new ApplicationComment();
        comment.setId(1);
        comment.setComment("Хорошо");
        User admin = new User();
        admin.setName("A");
        admin.setLastName("B");
        comment.setAdmin(admin);
        comment.setCreatedAt(java.time.LocalDateTime.now());

        when(commentRepository.findAllByApplicationIdOrderByCreatedAtAsc(1))
                .thenReturn(List.of(comment));

        List<ApplicationCommentDto> result = service.getCommentsForApplication(1);

        assertEquals(1, result.size());
        assertEquals("Хорошо", result.get(0).getComment());
    }
} 
