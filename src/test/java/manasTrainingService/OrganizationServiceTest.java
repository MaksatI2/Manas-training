package manasTrainingService;

import jakarta.validation.ValidationException;
import manasTrainingService.dto.organization.CreateStudentByOrganizationDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.Role;
import manasTrainingService.entity.StudentProfile;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.user.EmailAlreadyExistsException;
import manasTrainingService.exceptions.nsee.user.OrganizationNotFoundException;
import manasTrainingService.exceptions.nsee.user.PhoneAlreadyExistsException;
import manasTrainingService.repositories.course.CourseEnrollmentRepository;
import manasTrainingService.repositories.course.CourseInstanceRepository;
import manasTrainingService.repositories.user.OrganizationRepository;
import manasTrainingService.repositories.user.StudentProfileRepository;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.impl.user.OrganizationServiceImpl;
import manasTrainingService.service.user.EmailService;
import manasTrainingService.service.user.RoleService;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OrganizationServiceTest {

    @Mock
    private OrganizationRepository organizationRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private StudentProfileRepository studentProfileRepository;

    @Mock
    private RoleService roleService;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private EmailService emailService;

    @Mock
    private CourseEnrollmentRepository courseEnrollmentRepository;

    @Mock
    private CourseInstanceRepository courseInstanceRepository;

    @Mock
    private UserService userService;

    @InjectMocks
    private OrganizationServiceImpl organizationService;

    private CreateStudentByOrganizationDto dto;
    private User organizationUser;
    private Organization organization;
    private Role studentRole;

    @BeforeEach
    void setUp() {
        dto = CreateStudentByOrganizationDto.builder()
                .name("John")
                .lastName("Doe")
                .email("john.doe@example.com")
                .phone("0555123456")
                .build();

        organizationUser = User.builder()
                .id(1)
                .email("org@example.com")
                .build();

        organization = Organization.builder()
                .id(1)
                .user(organizationUser)
                .build();

        studentRole = Role.builder()
                .id(2)
                .name("STUDENT")
                .build();
    }

    @Test
    void createStudentByOrganization_Success() {
        when(userRepository.existsByEmail(dto.getEmail())).thenReturn(false);
        when(userRepository.existsByPhone("+996555123456")).thenReturn(false);
        when(organizationRepository.findByUserId(organizationUser.getId())).thenReturn(Optional.of(organization));
        when(roleService.getStudentRoleId()).thenReturn(studentRole);
        when(passwordEncoder.encode(anyString())).thenReturn("encoded_password");
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> {
            User user = invocation.getArgument(0);
            user.setId(2);
            return user;
        });
        when(studentProfileRepository.save(any(StudentProfile.class))).thenReturn(new StudentProfile());

        organizationService.createStudentByOrganization(dto, organizationUser);

        verify(userRepository).save(argThat(user ->
                user.getEmail().equals(dto.getEmail()) &&
                        user.getName().equals(dto.getName()) &&
                        user.getLastName().equals(dto.getLastName()) &&
                        user.getPhone().equals("+996555123456") &&
                        user.getRole().equals(studentRole) &&
                        user.getIsActive()
        ));
        verify(studentProfileRepository).save(argThat(profile ->
                profile.getOrganization().equals(organization)
        ));
        verify(emailService).sendStudentWelcomeEmail(eq(dto.getEmail()), eq(dto.getName()), anyString());
    }

    @Test
    void createStudentByOrganization_EmailAlreadyExists_ThrowsException() {
        when(organizationRepository.findByUserId(organizationUser.getId())).thenReturn(Optional.of(organization));
        when(userRepository.existsByEmail(dto.getEmail())).thenReturn(true);

        assertThrows(EmailAlreadyExistsException.class, () ->
                organizationService.createStudentByOrganization(dto, organizationUser));
        verify(userRepository, never()).save(any());
        verify(studentProfileRepository, never()).save(any());
        verify(emailService, never()).sendStudentWelcomeEmail(anyString(), anyString(), anyString());
    }

    @Test
    void createStudentByOrganization_PhoneAlreadyExists_ThrowsException() {
        when(organizationRepository.findByUserId(organizationUser.getId())).thenReturn(Optional.of(organization));
        when(userRepository.existsByEmail(dto.getEmail())).thenReturn(false);
        when(userRepository.existsByPhone("+996555123456")).thenReturn(true);

        assertThrows(PhoneAlreadyExistsException.class, () ->
                organizationService.createStudentByOrganization(dto, organizationUser));
        verify(userRepository, never()).save(any());
        verify(studentProfileRepository, never()).save(any());
        verify(emailService, never()).sendStudentWelcomeEmail(anyString(), anyString(), anyString());
    }

    @Test
    void createStudentByOrganization_OrganizationNotFound_ThrowsException() {
        when(organizationRepository.findByUserId(organizationUser.getId())).thenReturn(Optional.empty());

        assertThrows(OrganizationNotFoundException.class, () ->
                organizationService.createStudentByOrganization(dto, organizationUser));
        verify(userRepository, never()).existsByEmail(anyString());
        verify(userRepository, never()).existsByPhone(anyString());
        verify(userRepository, never()).save(any());
        verify(studentProfileRepository, never()).save(any());
        verify(emailService, never()).sendStudentWelcomeEmail(anyString(), anyString(), anyString());
    }

    @Test
    void createStudentByOrganization_InvalidPhoneFormat_ThrowsException() {
        dto.setPhone("12345");
        when(organizationRepository.findByUserId(organizationUser.getId())).thenReturn(Optional.of(organization));

        assertThrows(ValidationException.class, () ->
                organizationService.createStudentByOrganization(dto, organizationUser));
        verify(userRepository, never()).existsByEmail(anyString());
        verify(userRepository, never()).existsByPhone(anyString());
        verify(userRepository, never()).save(any());
        verify(studentProfileRepository, never()).save(any());
        verify(emailService, never()).sendStudentWelcomeEmail(anyString(), anyString(), anyString());
    }

    @Test
    void createStudentByOrganization_PhoneWithPlus996_Success() {
        dto.setPhone("+996555123456");
        when(organizationRepository.findByUserId(organizationUser.getId())).thenReturn(Optional.of(organization));
        when(userRepository.existsByEmail(dto.getEmail())).thenReturn(false);
        when(userRepository.existsByPhone("+996555123456")).thenReturn(false);
        when(roleService.getStudentRoleId()).thenReturn(studentRole);
        when(passwordEncoder.encode(anyString())).thenReturn("encoded_password");
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> {
            User user = invocation.getArgument(0);
            user.setId(2);
            return user;
        });
        when(studentProfileRepository.save(any(StudentProfile.class))).thenReturn(new StudentProfile());

        organizationService.createStudentByOrganization(dto, organizationUser);

        verify(userRepository).save(argThat(user ->
                user.getPhone().equals("+996555123456")
        ));
        verify(studentProfileRepository).save(any());
        verify(emailService).sendStudentWelcomeEmail(eq(dto.getEmail()), eq(dto.getName()), anyString());
    }
}