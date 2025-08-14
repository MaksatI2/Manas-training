package manasTrainingService.service;

import manasTrainingService.dto.create.CreateOrganizationDto;
import manasTrainingService.dto.create.CreateTeacherDto;
import manasTrainingService.dto.edit.OrganizationProfileEditDto;
import manasTrainingService.dto.edit.TeacherProfileEditDto;
import manasTrainingService.dto.edit.UserProfileEditDto;
import manasTrainingService.dto.profile.StudentProfileDto;
import manasTrainingService.dto.register.OrganizationRegisterDto;
import manasTrainingService.dto.register.StudentRegisterDto;
import manasTrainingService.dto.register.TeacherRegisterDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.Role;
import manasTrainingService.entity.StudentProfile;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.user.*;
import manasTrainingService.repositories.user.StudentProfileRepository;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.impl.user.UserServiceImpl;
import manasTrainingService.service.user.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;
    @Mock
    private RoleService roleService;
    @Mock
    private PasswordEncoder passwordEncoder;
    @Mock
    private OrganizationService organizationService;
    @Mock
    private StudentService studentService;
    @Mock
    private TeacherService teacherService;
    @Mock
    private EmailVerificationService emailVerificationService;
    @Mock
    private PasswordResetService passwordResetService;
    @Mock
    private StudentProfileRepository studentProfileRepository;
    @Mock
    private SecurityContext securityContext;
    @Mock
    private Authentication authentication;
    @Mock
    private UserDetails userDetails;
    @Mock
    private ActivityLogService activityLogService;

    @Mock
    private MessageSource messageSource;

    @InjectMocks
    private UserServiceImpl userService;

    private User testUser;
    private Role studentRole;
    private Role teacherRole;
    private Role companyRole;
    private Organization testOrganization;

    @BeforeEach
    void setUp() {
        studentRole = Role.builder().id(1).name("STUDENT").build();
        teacherRole = Role.builder().id(2).name("TEACHER").build();
        companyRole = Role.builder().id(3).name("COMPANY").build();

        testUser = User.builder()
                .id(1)
                .email("test@example.com")
                .name("Test")
                .lastName("User")
                .phone("+996555123456")
                .role(studentRole)
                .isActive(true)
                .build();

        testOrganization = Organization.builder()
                .id(1)
                .code("ORG0001")
                .user(testUser)
                .build();
    }

    @Test
    void registerOrganization_Success() {
        OrganizationRegisterDto dto = OrganizationRegisterDto.builder()
                .email("org@example.com")
                .password("password123")
                .companyName("Test Company")
                .phone("+996555987654")
                .build();

        when(userRepository.existsByEmail(dto.getEmail())).thenReturn(false);
        when(userRepository.existsByPhone(dto.getPhone())).thenReturn(false);
        when(userRepository.existsByName(dto.getCompanyName())).thenReturn(false);
        when(roleService.getCompanyTypeId()).thenReturn(companyRole);
        when(passwordEncoder.encode(dto.getPassword())).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenReturn(testUser);

        userService.registerOrganization(dto);

        verify(userRepository).save(any(User.class));
        verify(emailVerificationService).generateVerificationToken(any(User.class));
        verify(organizationService).createOrganization(any(CreateOrganizationDto.class));
    }

    @Test
    void registerOrganization_EmailAlreadyExists_ThrowsException() {
        OrganizationRegisterDto dto = OrganizationRegisterDto.builder()
                .email("existing@example.com")
                .password("password123")
                .companyName("Test Company")
                .phone("+996555987654")
                .build();

        when(userRepository.existsByEmail(dto.getEmail())).thenReturn(true);

        assertThatThrownBy(() -> userService.registerOrganization(dto))
                .isInstanceOf(EmailAlreadyExistsException.class)
                .hasMessage(messageSource.getMessage(
                        "organization.email.exists",
                        null,
                        "Организация с такой почтой уже существует",
                        LocaleContextHolder.getLocale()
                ));
    }

    @Test
    void registerOrganization_PhoneAlreadyExists_ThrowsException() {
        OrganizationRegisterDto dto = OrganizationRegisterDto.builder()
                .email("org@example.com")
                .password("password123")
                .companyName("Test Company")
                .phone("+996555987654")
                .build();

        when(userRepository.existsByEmail(dto.getEmail())).thenReturn(false);
        when(userRepository.existsByPhone(dto.getPhone())).thenReturn(true);

        assertThatThrownBy(() -> userService.registerOrganization(dto))
                .isInstanceOf(PhoneAlreadyExistsException.class)
                .hasMessage(messageSource.getMessage(
                        "user.phone.exists",
                        null,
                        "Пользователь с таким номером телефона уже существует",
                        LocaleContextHolder.getLocale()
                ));
    }

    @Test
    void registerOrganization_CompanyNameAlreadyExists_ThrowsException() {
        OrganizationRegisterDto dto = OrganizationRegisterDto.builder()
                .email("org@example.com")
                .password("password123")
                .companyName("Existing Company")
                .phone("+996555987654")
                .build();

        when(userRepository.existsByEmail(dto.getEmail())).thenReturn(false);
        when(userRepository.existsByPhone(dto.getPhone())).thenReturn(false);
        when(userRepository.existsByName(dto.getCompanyName())).thenReturn(true);

        assertThatThrownBy(() -> userService.registerOrganization(dto))
                .isInstanceOf(OrganizationNameAlreadyExistsException.class)
                .hasMessage(messageSource.getMessage(
                        "organization.name.exists",
                        null,
                        "Организация с таким названием уже существует",
                        LocaleContextHolder.getLocale()
                ));
    }

    @Test
    void registerStudent_Success() {
        StudentRegisterDto dto = StudentRegisterDto.builder()
                .email("student@example.com")
                .password("password123")
                .name("John")
                .surname("Doe")
                .phone("+996555123456")
                .organizationCode("ORG0001")
                .build();

        when(userRepository.existsByEmail(dto.getEmail())).thenReturn(false);
        when(userRepository.existsByPhone(dto.getPhone())).thenReturn(false);
        when(organizationService.getOrganizationByCode(dto.getOrganizationCode())).thenReturn(testOrganization);
        when(roleService.getStudentRoleId()).thenReturn(studentRole);
        when(passwordEncoder.encode(dto.getPassword())).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenReturn(testUser);

        userService.registerStudent(dto);

        verify(userRepository).save(any(User.class));
        verify(emailVerificationService).generateVerificationToken(any(User.class));
        verify(studentService).createStudentProfile(any(StudentProfileDto.class));
    }

    @Test
    void registerStudent_WithoutOrganization_Success() {
        StudentRegisterDto dto = StudentRegisterDto.builder()
                .email("student@example.com")
                .password("password123")
                .name("John")
                .surname("Doe")
                .phone("+996555123456")
                .organizationCode(null)
                .build();

        when(userRepository.existsByEmail(dto.getEmail())).thenReturn(false);
        when(userRepository.existsByPhone(dto.getPhone())).thenReturn(false);
        when(roleService.getStudentRoleId()).thenReturn(studentRole);
        when(passwordEncoder.encode(dto.getPassword())).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenReturn(testUser);

        userService.registerStudent(dto);

        verify(userRepository).save(any(User.class));
        verify(emailVerificationService).generateVerificationToken(any(User.class));
        verify(studentService).createStudentProfile(any(StudentProfileDto.class));
        verify(organizationService, never()).getOrganizationByCode(anyString());
    }

    @Test
    void registerTeacher_Success() {
        TeacherRegisterDto dto = TeacherRegisterDto.builder()
                .email("teacher@example.com")
                .password("password123")
                .name("Jane")
                .surname("Smith")
                .phone("+996555987654")
                .department("Mathematics")
                .qualifications("PhD in Mathematics")
                .bio("Experienced teacher")
                .build();

        when(userRepository.existsByEmail(dto.getEmail())).thenReturn(false);
        when(userRepository.existsByPhone(dto.getPhone())).thenReturn(false);
        when(roleService.getTeacherRoleId()).thenReturn(teacherRole);
        when(passwordEncoder.encode(dto.getPassword())).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenReturn(testUser);

        userService.registerTeacher(dto);

        verify(userRepository).save(any(User.class));
        verify(emailVerificationService).generateVerificationToken(any(User.class));
        verify(teacherService).createTeacherProfile(any(CreateTeacherDto.class));
    }

    @Test
    void editStudentInformation_Success() {
        UserProfileEditDto dto = UserProfileEditDto.builder()
                .userId(1)
                .name("Updated Name")
                .surname("Updated Surname")
                .phone("+996555999888")
                .build();

        when(userRepository.findById(dto.getUserId())).thenReturn(Optional.of(testUser));
        when(userRepository.saveAndFlush(any(User.class))).thenReturn(testUser);

        userService.editStudentInformation(dto);

        verify(userRepository).findById(dto.getUserId());
        verify(userRepository).saveAndFlush(any(User.class));
        assertThat(testUser.getName()).isEqualTo("Updated Name");
        assertThat(testUser.getLastName()).isEqualTo("Updated Surname");
        assertThat(testUser.getPhone()).isEqualTo("+996555999888");
    }

    @Test
    void editStudentInformation_UserNotFound_ThrowsException() {
        UserProfileEditDto dto = UserProfileEditDto.builder()
                .userId(999)
                .name("Updated Name")
                .surname("Updated Surname")
                .phone("+996555999888")
                .build();

        when(userRepository.findById(dto.getUserId())).thenReturn(Optional.empty());

        assertThatThrownBy(() -> userService.editStudentInformation(dto))
                .isInstanceOf(UserNotFoundException.class)
                .hasMessage(messageSource.getMessage(
                        "user.id.not.found",
                        null,
                        "Пользователь с таким ID не найден",
                        LocaleContextHolder.getLocale()
                ));
    }

    @Test
    void editManagerInformation_Success() {
        OrganizationProfileEditDto dto = OrganizationProfileEditDto.builder()
                .userId(1)
                .name("Updated Manager")
                .surname("Updated Surname")
                .phone("+996555999888")
                .build();

        when(userRepository.findById(dto.getUserId())).thenReturn(Optional.of(testUser));
        when(userRepository.saveAndFlush(any(User.class))).thenReturn(testUser);

        userService.editManagerInformation(dto);

        verify(userRepository).findById(dto.getUserId());
        verify(userRepository).saveAndFlush(any(User.class));
    }

    @Test
    void editTeacherInformation_Success() {
        TeacherProfileEditDto dto = TeacherProfileEditDto.builder()
                .userId(1)
                .name("Updated Teacher")
                .surname("Updated Surname")
                .phone("+996555999888")
                .department("Physics")
                .qualifications("PhD in Physics")
                .bio("Updated bio")
                .build();

        userService.editTeacherInformation(dto);

        verify(teacherService).editTeacherProfile(dto);
    }

    @Test
    void sendResetToken_Success() {
        String email = "test@example.com";
        when(userRepository.findByEmail(email)).thenReturn(Optional.of(testUser));

        userService.sendResetToken(email);

        verify(userRepository).findByEmail(email);
        verify(passwordResetService).createResetToken(testUser);
    }

    @Test
    void sendResetToken_UserNotFound_ThrowsException() {
        String email = "nonexistent@example.com";
        when(userRepository.findByEmail(email)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> userService.sendResetToken(email))
                .isInstanceOf(UserNotFoundException.class)
                .hasMessage(messageSource.getMessage(
                        "user.email.not.found",
                        null,
                        "Пользователь с таким email не найден",
                        LocaleContextHolder.getLocale()
                ));
    }

    @Test
    void resetPassword_Success() {
        String token = "valid-token";
        String newPassword = "newPassword123";
        when(passwordResetService.resetPassword(token, newPassword)).thenReturn(true);

        boolean result = userService.resetPassword(token, newPassword);

        assertThat(result).isTrue();
        verify(passwordResetService).resetPassword(token, newPassword);
    }

    @Test
    void isValidResetToken_ValidToken_ReturnsTrue() {
        String token = "valid-token";
        when(passwordResetService.isValidToken(token)).thenReturn(true);

        boolean result = userService.isValidResetToken(token);

        assertThat(result).isTrue();
        verify(passwordResetService).isValidToken(token);
    }

    @Test
    void verifyEmailToken_ValidToken_ReturnsTrue() {
        String token = "valid-email-token";
        when(emailVerificationService.verifyEmailToken(token)).thenReturn(true);

        boolean result = userService.verifyEmailToken(token);

        assertThat(result).isTrue();
        verify(emailVerificationService).verifyEmailToken(token);
    }

    @Test
    void existsByPhone_PhoneExists_ReturnsTrue() {
        String phone = "+996555123456";
        when(userRepository.existsByPhone(phone)).thenReturn(true);

        boolean result = userService.existsByPhone(phone);

        assertThat(result).isTrue();
        verify(userRepository).existsByPhone(phone);
    }

    @Test
    void getUserEntityByEmail_UserExists_ReturnsUser() {
        String email = "test@example.com";
        when(userRepository.findByEmail(email)).thenReturn(Optional.of(testUser));

        User result = userService.getUserEntityByEmail(email);

        assertThat(result).isEqualTo(testUser);
        verify(userRepository).findByEmail(email);
    }

    @Test
    void getUserEntityByEmail_UserNotFound_ThrowsException() {
        String email = "nonexistent@example.com";
        when(userRepository.findByEmail(email)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> userService.getUserEntityByEmail(email))
                .isInstanceOf(UserNotFoundException.class)
                .hasMessage(messageSource.getMessage(
                        "user.email.not.found",
                        null,
                        "Пользователь с таким email не найден",
                        LocaleContextHolder.getLocale()
                ));
    }

    @Test
    void getAuthorizedUser_WithUserDetails_ReturnsUser() {
        SecurityContextHolder.setContext(securityContext);
        when(securityContext.getAuthentication()).thenReturn(authentication);
        when(authentication.getPrincipal()).thenReturn(userDetails);
        when(userDetails.getUsername()).thenReturn("test@example.com");
        when(userRepository.findByEmail("test@example.com")).thenReturn(Optional.of(testUser));

        User result = userService.getAuthorizedUser();

        assertThat(result).isEqualTo(testUser);
    }

    @Test
    void getAuthorizedUser_WithStringPrincipal_ReturnsUser() {
        SecurityContextHolder.setContext(securityContext);
        when(securityContext.getAuthentication()).thenReturn(authentication);
        when(authentication.getPrincipal()).thenReturn("test@example.com");
        when(userRepository.findByEmail("test@example.com")).thenReturn(Optional.of(testUser));

        User result = userService.getAuthorizedUser();

        assertThat(result).isEqualTo(testUser);
    }

    @Test
    void getAllUsers_Success() {
        List<User> users = List.of(testUser);
        when(userRepository.findAll()).thenReturn(users);

        List<User> result = userService.getAllUsers();

        assertThat(result).hasSize(1);
        assertThat(result).contains(testUser);
        verify(userRepository).findAll();
    }

    @Test
    void addAvatarUrl_Success() {
        int userId = 1;
        String filename = "avatar.jpg";
        when(userRepository.findById(userId)).thenReturn(Optional.of(testUser));
        when(userRepository.saveAndFlush(any(User.class))).thenReturn(testUser);

        userService.addAvatarUrl(userId, filename);

        verify(userRepository).findById(userId);
        verify(userRepository).saveAndFlush(testUser);
        assertThat(testUser.getAvatarUrl()).isEqualTo(filename);
    }

    @Test
    void addAvatarUrl_UserNotFound_ThrowsException() {
        int userId = 999;
        String filename = "avatar.jpg";
        when(userRepository.findById(userId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> userService.addAvatarUrl(userId, filename))
                .isInstanceOf(UserNotFoundException.class)
                .hasMessage(messageSource.getMessage(
                                "user.id.not.found",
                                null,
                                "Пользователь с таким ID не найден",
                                LocaleContextHolder.getLocale()
                        )
                );
    }

    @Test
    void getUsersWithFilters_Success() {
        String role = "STUDENT";
        String status = "ACTIVE";
        String search = "test";
        Pageable pageable = PageRequest.of(0, 10);
        Page<User> expectedPage = new PageImpl<>(List.of(testUser));

        when(userRepository.findUsersWithFilters(role, status, search, pageable)).thenReturn(expectedPage);

        Page<User> result = userService.getUsersWithFilters(role, status, search, pageable);

        assertThat(result).isEqualTo(expectedPage);
        verify(userRepository).findUsersWithFilters(role, status, search, pageable);
    }

    @Test
    void getUserById_UserExists_ReturnsUser() {
        Integer id = 1;
        when(userRepository.findById(id)).thenReturn(Optional.of(testUser));

        User result = userService.getUserById(id);

        assertThat(result).isEqualTo(testUser);
        verify(userRepository).findById(id);
    }

    @Test
    void getUserById_UserNotFound_ThrowsException() {
        Integer id = 999;
        when(userRepository.findById(id)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> userService.getUserById(id))
                .isInstanceOf(UserNotFoundException.class)
                .hasMessage(messageSource.getMessage(
                        "user.not.found",
                        new Object[]{id},
                        LocaleContextHolder.getLocale()
                ));
    }

    @Test
    void saveUser_Success() {
        when(userRepository.save(testUser)).thenReturn(testUser);

        User result = userService.saveUser(testUser);

        assertThat(result).isEqualTo(testUser);
        verify(userRepository).save(testUser);
    }

    @Test
    void resendVerificationEmail_Success() {
        String email = "test@example.com";
        testUser.setIsActive(false);
        when(userRepository.findByEmail(email)).thenReturn(Optional.of(testUser));

        userService.resendVerificationEmail(email);

        verify(userRepository).findByEmail(email);
        verify(emailVerificationService).generateVerificationToken(testUser);
    }

    @Test
    void resendVerificationEmail_EmailAlreadyVerified_ThrowsException() {
        String email = "test@example.com";
        testUser.setIsActive(true);
        when(userRepository.findByEmail(email)).thenReturn(Optional.of(testUser));

        assertThatThrownBy(() -> userService.resendVerificationEmail(email))
                .isInstanceOf(EmailAlreadyVerifiedException.class)
                .hasMessage(messageSource.getMessage(
                        "email.already.verified",
                        null,
                        "Email уже подтвержден",
                        LocaleContextHolder.getLocale()
                ));
    }

    @Test
    void getStudentsWithoutOrganization_Success() {
        StudentProfile studentProfile = StudentProfile.builder()
                .user(testUser)
                .organization(null)
                .build();
        List<StudentProfile> profiles = List.of(studentProfile);

        when(studentProfileRepository.findAllByOrganizationIsNull()).thenReturn(profiles);

        List<User> result = userService.getStudentsWithoutOrganization();

        assertThat(result).hasSize(1);
        assertThat(result).contains(testUser);
        verify(studentProfileRepository).findAllByOrganizationIsNull();
    }

    @Test
    void countActiveAdmins_Success() {
        long expectedCount = 5L;
        when(userRepository.countByRole_NameAndIsActiveTrue("ADMIN")).thenReturn(expectedCount);

        long result = userService.countActiveAdmins();

        assertThat(result).isEqualTo(expectedCount);
        verify(userRepository).countByRole_NameAndIsActiveTrue("ADMIN");
    }
}