package manasTrainingService;

import manasTrainingService.dto.application.ApplicationCommentDto;
import manasTrainingService.dto.application.ApplicationStatusUpdateDto;
import manasTrainingService.dto.application.CourseApplicationCreateDto;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.BadRequestException;
import manasTrainingService.repositories.course.*;
import manasTrainingService.repositories.user.OrganizationRepository;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.impl.CourseApplicationServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

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

        CourseInstance instance = new CourseInstance();
        instance.setId(100);

        User emp = new User();
        emp.setId(200);

        CourseApplicationEmployee cae = new CourseApplicationEmployee();
        cae.setEmployee(emp);
        cae.setApplication(app);

        when(applicationRepository.findById(1)).thenReturn(Optional.of(app));
        when(instanceRepository.findByCourseId(10)).thenReturn(List.of(instance));
        when(employeeRepository.findByApplicationId(1)).thenReturn(List.of(cae));
        when(enrollmentRepository.existsByStudentIdAndCourseInstanceId(200, 100)).thenReturn(false);

        ApplicationStatusUpdateDto dto = new ApplicationStatusUpdateDto(Status.APPROVED, null);
        service.updateApplicationStatus(1, dto, "admin@example.com");

        assertEquals(Status.APPROVED, app.getStatus());
        verify(enrollmentRepository).save(any());
    }

    @Test
    void addComment_success() {
        User admin = new User();
        admin.setEmail("admin@example.com");
        admin.setName("A");
        admin.setLastName("B");

        CourseApplication app = new CourseApplication();
        app.setId(1);

        when(userRepository.findByEmail("admin@example.com")).thenReturn(Optional.of(admin));
        when(applicationRepository.findById(1)).thenReturn(Optional.of(app));

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
