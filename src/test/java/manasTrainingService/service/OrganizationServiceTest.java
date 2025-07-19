package manasTrainingService.service;

import jakarta.validation.ValidationException;
import manasTrainingService.dto.create.CreateOrganizationDto;
import manasTrainingService.dto.edit.OrganizationProfileEditDto;
import manasTrainingService.dto.organization.CreateStudentByOrganizationDto;
import manasTrainingService.dto.organization.StudentCourseInfoDto;
import manasTrainingService.dto.organization.StudentEditByOrganizationDto;
import manasTrainingService.dto.profile.OrganizationProfileDto;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.course.CourseEnrollmentNotFoundException;
import manasTrainingService.exceptions.nsee.user.*;
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
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrganizationService Unit Tests")
@MockitoSettings(strictness = Strictness.LENIENT)
class OrganizationServiceTest {

    @Mock
    private OrganizationRepository organizationRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private CourseEnrollmentRepository courseEnrollmentRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private RoleService roleService;

    @Mock
    private StudentProfileRepository studentProfileRepository;

    @Mock
    private CourseInstanceRepository courseInstanceRepository;

    @Mock
    private EmailService emailService;

    @Mock
    private UserService userService;

    @Mock
    private ActivityLogService activityLogService;

    @InjectMocks
    private OrganizationServiceImpl organizationService;

    private User testUser;
    private Organization testOrganization;
    private StudentProfile testStudentProfile;
    private CourseInstance testCourseInstance;
    private Course testCourse;
    private Role studentRole;

    @BeforeEach
    void setUp() {
        organizationService.setUserService(userService);

        testUser = User.builder()
                .id(1)
                .email("test@example.com")
                .name("Test")
                .lastName("User")
                .phone("+996123456789")
                .isActive(true)
                .build();

        testOrganization = Organization.builder()
                .id(1)
                .user(testUser)
                .code("ORG0001")
                .description("Test Organization")
                .build();

        testStudentProfile = StudentProfile.builder()
                .id(1)
                .user(testUser)
                .organization(testOrganization)
                .build();

        testCourse = Course.builder()
                .id(1)
                .title("Test Course")
                .build();

        testCourseInstance = CourseInstance.builder()
                .id(1)
                .course(testCourse)
                .build();

        studentRole = Role.builder()
                .id(3)
                .name("ROLE_STUDENT")
                .build();
    }

    @Nested
    @DisplayName("Create Organization Tests")
    class CreateOrganizationTests {

        @Test
        @DisplayName("Should create organization successfully")
        void shouldCreateOrganizationSuccessfully() {
            CreateOrganizationDto dto = CreateOrganizationDto.builder()
                    .user(testUser)
                    .build();

            when(organizationRepository.findByCode(anyString())).thenReturn(Optional.empty());
            when(organizationRepository.save(any(Organization.class))).thenReturn(testOrganization);

            organizationService.createOrganization(dto);

            verify(organizationRepository).save(argThat(org ->
                    org.getUser().equals(testUser) &&
                    org.getCode().startsWith("ORG")
            ));
        }

        @Test
        @DisplayName("Should throw exception when unable to generate unique code")
        void shouldThrowExceptionWhenUnableToGenerateUniqueCode() {
            CreateOrganizationDto dto = CreateOrganizationDto.builder()
                    .user(testUser)
                    .build();

            when(organizationRepository.findByCode(anyString())).thenReturn(Optional.of(testOrganization));

            assertThatThrownBy(() -> organizationService.createOrganization(dto))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Не удалось сгенерировать уникальный код организации");
        }
    }

    @Nested
    @DisplayName("Edit Organization Tests")
    class EditOrganizationTests {

        @Test
        @DisplayName("Should edit organization information successfully")
        void shouldEditOrganizationInformationSuccessfully() {
            OrganizationProfileEditDto dto = OrganizationProfileEditDto.builder()
                    .userId(1)
                    .organizationName("Updated Organization")
                    .name("Updated Name")
                    .surname("Updated Surname")
                    .phone("+996987654321")
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));

            organizationService.editOrganizationInformation(dto);

            verify(organizationRepository).findByUserId(1);
            verify(userService).editManagerInformation(dto);
            assertThat(testOrganization.getDescription()).isEqualTo("Updated Organization");
        }

        @Test
        @DisplayName("Should throw exception when organization not found")
        void shouldThrowExceptionWhenOrganizationNotFound() {
            OrganizationProfileEditDto dto = OrganizationProfileEditDto.builder()
                    .userId(999)
                    .build();

            when(organizationRepository.findByUserId(999)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> organizationService.editOrganizationInformation(dto))
                    .isInstanceOf(OrganizationNotFoundException.class)
                    .hasMessageContaining("Организация не найдена");
        }
    }

    @Nested
    @DisplayName("Get Organization Tests")
    class GetOrganizationTests {

        @Test
        @DisplayName("Should get organization information for edit successfully")
        void shouldGetOrganizationInformationForEditSuccessfully() {
            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));

            OrganizationProfileEditDto result = organizationService.getOrganizationUserInformationForEdit(testUser);

            assertThat(result).isNotNull();
            assertThat(result.getUserId()).isEqualTo(1);
            assertThat(result.getName()).isEqualTo("Test");
            assertThat(result.getSurname()).isEqualTo("User");
            assertThat(result.getPhone()).isEqualTo("+996123456789");
            assertThat(result.getOrganizationName()).isEqualTo("Test Organization");
        }

        @Test
        @DisplayName("Should get organization by code successfully")
        void shouldGetOrganizationByCodeSuccessfully() {
            when(organizationRepository.findByCode("ORG0001")).thenReturn(Optional.of(testOrganization));

            Organization result = organizationService.getOrganizationByCode("ORG0001");

            assertThat(result).isEqualTo(testOrganization);
        }

        @Test
        @DisplayName("Should throw exception when organization not found by code")
        void shouldThrowExceptionWhenOrganizationNotFoundByCode() {
            when(organizationRepository.findByCode("INVALID")).thenReturn(Optional.empty());

            assertThatThrownBy(() -> organizationService.getOrganizationByCode("INVALID"))
                    .isInstanceOf(OrganizationCodeNotFound.class)
                    .hasMessageContaining("Организация с таким кодом не найдена");
        }

        @Test
        @DisplayName("Should get organization by ID successfully")
        void shouldGetOrganizationByIdSuccessfully() {
            when(organizationRepository.findById(1)).thenReturn(Optional.of(testOrganization));

            Organization result = organizationService.getOrganizationById(1);

            assertThat(result).isEqualTo(testOrganization);
        }

        @Test
        @DisplayName("Should throw exception when organization not found by ID")
        void shouldThrowExceptionWhenOrganizationNotFoundById() {
            when(organizationRepository.findById(999)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> organizationService.getOrganizationById(999))
                    .isInstanceOf(OrganizationCodeNotFound.class)
                    .hasMessageContaining("Организация с таким ID не найдена");
        }

        @Test
        @DisplayName("Should get authorized user organization successfully")
        void shouldGetAuthorizedUserOrganizationSuccessfully() {
            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));

            OrganizationProfileDto result = organizationService.getAuthorizedUserOrganization(testUser);

            assertThat(result).isNotNull();
            assertThat(result.getUser()).isEqualTo(testUser);
            assertThat(result.getOrganization()).isEqualTo(testOrganization);
        }

        @Test
        @DisplayName("Should get organization name successfully")
        void shouldGetOrganizationNameSuccessfully() {
            String result = organizationService.getOrganizationName(testOrganization);

            assertThat(result).isEqualTo("Test");
        }

        @Test
        @DisplayName("Should return null for organization name when organization is null")
        void shouldReturnNullForOrganizationNameWhenOrganizationIsNull() {
            String result = organizationService.getOrganizationName(null);

            assertThat(result).isNull();
        }

        @Test
        @DisplayName("Should get organization name by code successfully")
        void shouldGetOrganizationNameByCodeSuccessfully() {
            when(organizationRepository.findByCode("ORG0001")).thenReturn(Optional.of(testOrganization));

            String result = organizationService.getOrganizationNameByCode("ORG0001");

            assertThat(result).isEqualTo("Test");
        }

        @Test
        @DisplayName("Should get organization name by ID successfully")
        void shouldGetOrganizationNameByIdSuccessfully() {
            when(organizationRepository.findById(1)).thenReturn(Optional.of(testOrganization));

            String result = organizationService.getOrganizationNameById(1);

            assertThat(result).isEqualTo("Test");
        }
    }

    @Nested
    @DisplayName("Student Course Info Tests")
    class StudentCourseInfoTests {

        @Test
        @DisplayName("Should get students course info for organization successfully")
        void shouldGetStudentsCourseInfoForOrganizationSuccessfully() {

            User student = User.builder()
                    .id(2)
                    .name("Student")
                    .lastName("Test")
                    .email("student@test.com")
                    .phone("+996111111111")
                    .build();


            StudentProfile studentProfile = StudentProfile.builder()
                    .user(student)
                    .organization(testOrganization)
                    .build();


            Course course = Course.builder()
                    .id(1)
                    .title("Test Course")
                    .build();

            CourseInstance courseInstance = CourseInstance.builder()
                    .id(1)
                    .course(course)
                    .build();


            CourseEnrollment enrollment = CourseEnrollment.builder()
                    .id(1)
                    .student(student)
                    .courseInstance(courseInstance)
                    .status(Status.ENROLLED)
                    .progressPercentage(BigDecimal.valueOf(75))
                    .finalGrade(BigDecimal.valueOf(85))
                    .build();


            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(studentProfileRepository.findAllByOrganization(testOrganization))
                    .thenReturn(List.of(studentProfile));
            when(courseEnrollmentRepository.findWithCourseByStudentIn(List.of(student)))
                    .thenReturn(List.of(enrollment));


            List<StudentCourseInfoDto> result = organizationService.getStudentsCourseInfoForOrganization(testUser);


            assertThat(result).hasSize(1);
            StudentCourseInfoDto dto = result.get(0);
            assertThat(dto.getStudentId()).isEqualTo(2);
            assertThat(dto.getFullName()).isEqualTo("Student Test");
            assertThat(dto.getCourseTitle()).isEqualTo("Test Course");
            assertThat(dto.getProgress()).isEqualTo(BigDecimal.valueOf(75));
            assertThat(dto.getFinalGrade()).isEqualTo(BigDecimal.valueOf(85));
        }

        @Test
        @DisplayName("Should return student info with no course when no enrollments")
        void shouldReturnStudentInfoWithNoCourseWhenNoEnrollments() {
            User student = User.builder()
                    .id(2)
                    .name("Student")
                    .lastName("Test")
                    .email("student@test.com")
                    .phone("+996111111111")
                    .build();

            StudentProfile studentProfile = StudentProfile.builder()
                    .user(student)
                    .organization(testOrganization)
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(studentProfileRepository.findAllByOrganization(testOrganization))
                    .thenReturn(List.of(studentProfile));
            when(courseEnrollmentRepository.findByStudentIn(List.of(student)))
                    .thenReturn(Collections.emptyList());

            List<StudentCourseInfoDto> result = organizationService.getStudentsCourseInfoForOrganization(testUser);

            assertThat(result).hasSize(1);
            StudentCourseInfoDto dto = result.get(0);
            assertThat(dto.getStudentId()).isEqualTo(2);
            assertThat(dto.getCourseTitle()).isEqualTo("-");
            assertThat(dto.getStatus()).isEqualTo("-");
            assertThat(dto.getProgress()).isEqualTo(BigDecimal.ZERO);
        }
    }

        @Nested
    @DisplayName("Edit Student Profile Tests")
    class EditStudentProfileTests {

        @Test
        @DisplayName("Should edit student profile by organization successfully")
        void shouldEditStudentProfileByOrganizationSuccessfully() {
            StudentEditByOrganizationDto dto = StudentEditByOrganizationDto.builder()
                    .studentId(1L)
                    .name("Updated Name")
                    .lastName("Updated Last")
                    .phone("+996999999999")
                    .email("updated@test.com")
                    .build();

            when(userRepository.findById(1)).thenReturn(Optional.of(testUser));
            when(userRepository.save(any(User.class))).thenReturn(testUser);

            organizationService.editStudentProfileByOrganization(dto);

            verify(userRepository).save(argThat(user ->
                    user.getName().equals("Updated Name") &&
                    user.getLastName().equals("Updated Last") &&
                    user.getPhone().equals("+996999999999") &&
                    user.getEmail().equals("updated@test.com")
            ));
        }

        @Test
        @DisplayName("Should throw exception when student not found for editing")
        void shouldThrowExceptionWhenStudentNotFoundForEditing() {
            StudentEditByOrganizationDto dto = StudentEditByOrganizationDto.builder()
                    .studentId(999L)
                    .build();

            when(userRepository.findById(999)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> organizationService.editStudentProfileByOrganization(dto))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessageContaining("Студент не найден");
        }
    }

    @Nested
    @DisplayName("Remove Student from Course Tests")
    class RemoveStudentFromCourseTests {

        @Test
        @DisplayName("Should remove student from course successfully")
        void shouldRemoveStudentFromCourseSuccessfully() {
            User student = User.builder()
                    .id(2)
                    .studentProfile(testStudentProfile)
                    .build();
            testStudentProfile.setUser(student);

            CourseEnrollment enrollment = CourseEnrollment.builder()
                    .id(1)
                    .student(student)
                    .courseInstance(testCourseInstance)
                    .build();

            when(courseEnrollmentRepository.findById(1)).thenReturn(Optional.of(enrollment));
            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));

            organizationService.removeStudentFromCourse(1, testUser);

            verify(courseEnrollmentRepository).delete(enrollment);
        }

        @Test
        @DisplayName("Should throw exception when enrollment not found")
        void shouldThrowExceptionWhenEnrollmentNotFound() {
            when(courseEnrollmentRepository.findById(999)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> organizationService.removeStudentFromCourse(999, testUser))
                    .isInstanceOf(CourseEnrollmentNotFoundException.class)
                    .hasMessageContaining("Запись на курс не найдена");
        }
    }

    @Nested
    @DisplayName("Delete Student from Organization Tests")
    class DeleteStudentFromOrganizationTests {

        @Test
        @DisplayName("Should delete student from organization successfully")
        void shouldDeleteStudentFromOrganizationSuccessfully() {
            User student = User.builder()
                    .id(2)
                    .studentProfile(testStudentProfile)
                    .build();
            testStudentProfile.setUser(student);

            CourseEnrollment enrollment = CourseEnrollment.builder()
                    .student(student)
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(userRepository.findById(2)).thenReturn(Optional.of(student));
            when(courseEnrollmentRepository.findByStudent(student)).thenReturn(List.of(enrollment));

            organizationService.deleteStudentFromOrganization(2, testUser);

            verify(courseEnrollmentRepository).deleteAll(List.of(enrollment));
            verify(studentProfileRepository).save(argThat(profile ->
                    profile.getOrganization() == null
            ));
            verify(userRepository).save(argThat(user ->
                    !user.getIsActive()
            ));
        }

        @Test
        @DisplayName("Should throw exception when student not belongs to organization")
        void shouldThrowExceptionWhenStudentNotBelongsToOrganization() {
            Organization differentOrg = Organization.builder()
                    .id(2)
                    .build();

            StudentProfile differentProfile = StudentProfile.builder()
                    .organization(differentOrg)
                    .build();

            User student = User.builder()
                    .id(2)
                    .studentProfile(differentProfile)
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(userRepository.findById(2)).thenReturn(Optional.of(student));

            assertThatThrownBy(() -> organizationService.deleteStudentFromOrganization(2, testUser))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Студент не принадлежит данной организации");
        }
    }

    @Nested
    @DisplayName("Create Student by Organization Tests")
    class CreateStudentByOrganizationTests {

        @Test
        @DisplayName("Should create student by organization successfully")
        void shouldCreateStudentByOrganizationSuccessfully() {
            CreateStudentByOrganizationDto dto = CreateStudentByOrganizationDto.builder()
                    .email("newstudent@test.com")
                    .name("New")
                    .lastName("Student")
                    .phone("+996777777777")
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(userRepository.existsByEmail("newstudent@test.com")).thenReturn(false);
            when(userRepository.existsByPhone("+996777777777")).thenReturn(false);
            when(roleService.getStudentRoleId()).thenReturn(studentRole);
            when(passwordEncoder.encode(anyString())).thenReturn("encoded_password");
            when(userRepository.save(any(User.class))).thenReturn(testUser);

            organizationService.createStudentByOrganization(dto, testUser);

            verify(userRepository).save(argThat(user ->
                    user.getEmail().equals("newstudent@test.com") &&
                    user.getName().equals("New") &&
                    user.getLastName().equals("Student") &&
                    user.getPhone().equals("+996777777777") &&
                    user.getIsActive() &&
                    user.getRole().equals(studentRole)
            ));
            verify(studentProfileRepository).save(any(StudentProfile.class));
            verify(emailService).sendStudentWelcomeEmail(eq("newstudent@test.com"), eq("New"), anyString());
        }

        @Test
        @DisplayName("Should throw exception when email already exists")
        void shouldThrowExceptionWhenEmailAlreadyExists() {
            CreateStudentByOrganizationDto dto = CreateStudentByOrganizationDto.builder()
                    .email("existing@test.com")
                    .phone("+996123456789")
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(userRepository.existsByEmail("existing@test.com")).thenReturn(true);

            assertThatThrownBy(() -> organizationService.createStudentByOrganization(dto, testUser))
                    .isInstanceOf(EmailAlreadyExistsException.class)
                    .hasMessageContaining("Email уже используется");
        }

        @Test
        @DisplayName("Should throw exception when phone already exists")
        void shouldThrowExceptionWhenPhoneAlreadyExists() {
            CreateStudentByOrganizationDto dto = CreateStudentByOrganizationDto.builder()
                    .email("new@test.com")
                    .phone("+996777777777")
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(userRepository.existsByEmail("new@test.com")).thenReturn(false);
            when(userRepository.existsByPhone("+996777777777")).thenReturn(true);

            assertThatThrownBy(() -> organizationService.createStudentByOrganization(dto, testUser))
                    .isInstanceOf(PhoneAlreadyExistsException.class)
                    .hasMessageContaining("Телефон уже используется");
        }

        @Test
        @DisplayName("Should normalize phone number correctly")
        void shouldNormalizePhoneNumberCorrectly() {
            CreateStudentByOrganizationDto dto = CreateStudentByOrganizationDto.builder()
                    .email("new@test.com")
                    .name("Test")
                    .lastName("User")
                    .phone("+996777777777")
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(userRepository.existsByEmail("new@test.com")).thenReturn(false);
            when(userRepository.existsByPhone("+996777777777")).thenReturn(false);
            when(roleService.getStudentRoleId()).thenReturn(studentRole);
            when(passwordEncoder.encode(anyString())).thenReturn("encoded_password");

            organizationService.createStudentByOrganization(dto, testUser);

            verify(userRepository).save(argThat(user ->
                    user.getPhone().equals("+996777777777")
            ));
        }
    }

    @Nested
    @DisplayName("Attach Student to Organization Tests")
    class AttachStudentToOrganizationTests {

        @Test
        @DisplayName("Should attach student to organization successfully")
        void shouldAttachStudentToOrganizationSuccessfully() {
            StudentProfile profileWithoutOrg = StudentProfile.builder()
                    .id(1)
                    .user(testUser)
                    .organization(null)
                    .build();

            User student = User.builder()
                    .id(2)
                    .studentProfile(profileWithoutOrg)
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(userRepository.findById(2)).thenReturn(Optional.of(student));

            organizationService.attachStudentToOrganization(2, testUser);

            verify(studentProfileRepository).save(argThat(profile ->
                    profile.getOrganization().equals(testOrganization)
            ));
        }

        @Test
        @DisplayName("Should throw exception when student not found for attachment")
        void shouldThrowExceptionWhenStudentNotFoundForAttachment() {
            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(userRepository.findById(999)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> organizationService.attachStudentToOrganization(999, testUser))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessageContaining("Студент не найден");
        }

        @Test
        @DisplayName("Should throw exception when student has no profile")
        void shouldThrowExceptionWhenStudentHasNoProfile() {
            User studentWithoutProfile = User.builder()
                    .id(2)
                    .studentProfile(null)
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(userRepository.findById(2)).thenReturn(Optional.of(studentWithoutProfile));

            assertThatThrownBy(() -> organizationService.attachStudentToOrganization(2, testUser))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("У пользователя нет профиля студента");
        }

        @Test
        @DisplayName("Should throw exception when student already attached to organization")
        void shouldThrowExceptionWhenStudentAlreadyAttachedToOrganization() {
            Organization anotherOrg = Organization.builder()
                    .id(2)
                    .build();

            StudentProfile profileWithOrg = StudentProfile.builder()
                    .id(1)
                    .user(testUser)
                    .organization(anotherOrg)
                    .build();

            User student = User.builder()
                    .id(2)
                    .studentProfile(profileWithOrg)
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(userRepository.findById(2)).thenReturn(Optional.of(student));

            assertThatThrownBy(() -> organizationService.attachStudentToOrganization(2, testUser))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Студент уже прикреплён к другой организации");
        }

        @Test
        @DisplayName("Should throw exception when organization not found for attachment")
        void shouldThrowExceptionWhenOrganizationNotFoundForAttachment() {
            when(organizationRepository.findByUserId(1)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> organizationService.attachStudentToOrganization(2, testUser))
                    .isInstanceOf(OrganizationNotFoundException.class)
                    .hasMessageContaining("Организация не найдена");
        }
    }

    @Nested
    @DisplayName("Phone Number Normalization Tests")
    class PhoneNumberNormalizationTests {


        @Test
        @DisplayName("Should accept already formatted phone number")
        void shouldAcceptAlreadyFormattedPhoneNumber() {
            CreateStudentByOrganizationDto dto = CreateStudentByOrganizationDto.builder()
                    .email("test@test.com")
                    .name("Test")
                    .lastName("User")
                    .phone("+996555123456")
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(userRepository.existsByEmail("test@test.com")).thenReturn(false);
            when(userRepository.existsByPhone("+996555123456")).thenReturn(false);
            when(roleService.getStudentRoleId()).thenReturn(studentRole);
            when(passwordEncoder.encode(anyString())).thenReturn("encoded");

            organizationService.createStudentByOrganization(dto, testUser);

            verify(userRepository).save(argThat(user ->
                    user.getPhone().equals("+996555123456")
            ));
        }

    }

    @Nested
    @DisplayName("Integration Tests")
    class IntegrationTests {

        @Test
        @DisplayName("Should handle complete student lifecycle in organization")
        void shouldHandleCompleteStudentLifecycleInOrganization() {
            CreateStudentByOrganizationDto createDto = CreateStudentByOrganizationDto.builder()
                    .email("lifecycle@test.com")
                    .name("Lifecycle")
                    .lastName("Student")
                    .phone("0777888999")
                    .build();

            User createdStudent = User.builder()
                    .id(10)
                    .email("lifecycle@test.com")
                    .name("Lifecycle")
                    .lastName("Student")
                    .phone("+996777888999")
                    .isActive(true)
                    .role(studentRole)
                    .build();

            StudentProfile createdProfile = StudentProfile.builder()
                    .user(createdStudent)
                    .organization(testOrganization)
                    .build();

            createdStudent.setStudentProfile(createdProfile);

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(userRepository.existsByEmail("lifecycle@test.com")).thenReturn(false);
            when(userRepository.existsByPhone("+996777888999")).thenReturn(false);
            when(roleService.getStudentRoleId()).thenReturn(studentRole);
            when(passwordEncoder.encode(anyString())).thenReturn("encoded");
            when(userRepository.save(any(User.class))).thenReturn(createdStudent);

            organizationService.createStudentByOrganization(createDto, testUser);

            StudentEditByOrganizationDto editDto = StudentEditByOrganizationDto.builder()
                    .studentId(10L)
                    .name("Updated Lifecycle")
                    .lastName("Updated Student")
                    .phone("+996111222333")
                    .email("updated.lifecycle@test.com")
                    .build();

            when(userRepository.findById(10)).thenReturn(Optional.of(createdStudent));

            organizationService.editStudentProfileByOrganization(editDto);

            verify(emailService).sendStudentWelcomeEmail(eq("lifecycle@test.com"), eq("Lifecycle"), anyString());
        }

        @Test
        @DisplayName("Should maintain data consistency during operations")
        void shouldMaintainDataConsistencyDuringOperations() {
            User student1 = User.builder().id(10).name("Alice").lastName("One").build();
            User student2 = User.builder().id(11).name("Bob").lastName("Two").build();

            StudentProfile profile1 = StudentProfile.builder()
                    .user(student1)
                    .organization(testOrganization)
                    .build();
            StudentProfile profile2 = StudentProfile.builder()
                    .user(student2)
                    .organization(testOrganization)
                    .build();

            student1.setStudentProfile(profile1);
            student2.setStudentProfile(profile2);

            Course course = Course.builder()
                    .id(1)
                    .title("Test Course")
                    .build();

            CourseInstance courseInstance = CourseInstance.builder()
                    .id(1)
                    .course(course)
                    .build();
            CourseEnrollment enrollment1 = CourseEnrollment.builder()
                    .student(student1)
                    .courseInstance(courseInstance)
                    .status(Status.ENROLLED)
                    .progressPercentage(BigDecimal.valueOf(50))
                    .build();

            CourseEnrollment enrollment2 = CourseEnrollment.builder()
                    .student(student2)
                    .courseInstance(courseInstance)
                    .status(Status.COMPLETED)
                    .progressPercentage(BigDecimal.valueOf(100))
                    .finalGrade(BigDecimal.valueOf(95))
                    .build();

            when(organizationRepository.findByUserId(1)).thenReturn(Optional.of(testOrganization));
            when(studentProfileRepository.findAllByOrganization(testOrganization))
                    .thenReturn(List.of(profile1, profile2));
            when(courseEnrollmentRepository.findWithCourseByStudentIn(List.of(student1, student2)))
                    .thenReturn(List.of(enrollment1, enrollment2));

            List<StudentCourseInfoDto> result = organizationService.getStudentsCourseInfoForOrganization(testUser);

            assertThat(result).hasSize(2);

            StudentCourseInfoDto dto1 = result.stream()
                    .filter(dto -> dto.getStudentId().equals(10))
                    .findFirst()
                    .orElseThrow();
            assertThat(dto1.getFullName()).isEqualTo("Alice One");
            assertThat(dto1.getProgress()).isEqualTo(BigDecimal.valueOf(50));
            assertThat(dto1.getFinalGrade()).isNull();

            StudentCourseInfoDto dto2 = result.stream()
                    .filter(dto -> dto.getStudentId().equals(11))
                    .findFirst()
                    .orElseThrow();
            assertThat(dto2.getFullName()).isEqualTo("Bob Two");
            assertThat(dto2.getProgress()).isEqualTo(BigDecimal.valueOf(100));
            assertThat(dto2.getFinalGrade()).isEqualTo(BigDecimal.valueOf(95));
        }

        @Nested
        @DisplayName("Error Handling Tests")
        class ErrorHandlingTests {

            @Test
            @DisplayName("Should handle null values gracefully")
            void shouldHandleNullValuesGracefully() {
                String result = organizationService.getOrganizationName(null);
                assertThat(result).isNull();

                Organization orgWithNullUser = Organization.builder()
                        .id(1)
                        .user(null)
                        .build();

                String result2 = organizationService.getOrganizationName(orgWithNullUser);
                assertThat(result2).isNull();
            }

            @Test
            @DisplayName("Should handle repository exceptions properly")
            void shouldHandleRepositoryExceptionsProperly() {
                when(organizationRepository.findByUserId(1))
                        .thenThrow(new RuntimeException("Database error"));

                assertThatThrownBy(() -> organizationService.getAuthorizedUserOrganization(testUser))
                        .isInstanceOf(RuntimeException.class)
                        .hasMessageContaining("Database error");
            }
        }
    }
}