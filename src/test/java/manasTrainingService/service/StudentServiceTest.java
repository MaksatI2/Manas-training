package manasTrainingService.service;

import manasTrainingService.dto.edit.UserProfileEditDto;
import manasTrainingService.dto.profile.StudentProfileDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.StudentProfile;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.user.PhoneAlreadyExistsException;
import manasTrainingService.exceptions.nsee.user.StudentProfileNotFoundException;
import manasTrainingService.repositories.user.StudentProfileRepository;
import manasTrainingService.service.impl.user.StudentServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("StudentService Unit Tests")
class StudentServiceTest {

    @Mock
    private StudentProfileRepository studentProfileRepository;

    @Mock
    private UserService userService;

    @Mock
    private ActivityLogService activityLogService;
    @Mock
    private MessageSource messageSource;

    @InjectMocks
    private StudentServiceImpl studentService;

    private User testUser;
    private Organization testOrganization;
    private StudentProfile testStudentProfile;
    private StudentProfileDto testStudentProfileDto;
    private UserProfileEditDto testUserProfileEditDto;

    @BeforeEach
    void setUp() {
        testUser = User.builder()
                .id(1)
                .name("Иван")
                .lastName("Иванов")
                .email("ivan@test.com")
                .phone("+996555123456")
                .build();

        User organizationUser = User.builder()
                .id(2)
                .name("Тест Организация")
                .email("org@test.com")
                .build();

        testOrganization = Organization.builder()
                .id(1)
                .code("ORG0001")
                .user(organizationUser)
                .build();

        testStudentProfile = StudentProfile.builder()
                .id(1)
                .user(testUser)
                .organization(testOrganization)
                .specialization("Информатика")
                .build();

        testStudentProfileDto = StudentProfileDto.builder()
                .student(testUser)
                .organization(testOrganization)
                .organizationName("Тест Организация")
                .specialization("Информатика")
                .build();

        testUserProfileEditDto = UserProfileEditDto.builder()
                .userId(1)
                .name("Петр")
                .surname("Петров")
                .phone("+996555654321")
                .specialization("Математика")
                .build();
    }

    @Nested
    @DisplayName("createStudentProfile() Tests")
    class CreateStudentProfileTests {

        @Test
        @DisplayName("Should successfully create student profile")
        void shouldCreateStudentProfileSuccessfully() {
            StudentProfile expectedProfile = StudentProfile.builder()
                    .user(testStudentProfileDto.getStudent())
                    .organization(testStudentProfileDto.getOrganization())
                    .build();

            when(studentProfileRepository.save(any(StudentProfile.class))).thenReturn(expectedProfile);

            studentService.createStudentProfile(testStudentProfileDto);

            verify(studentProfileRepository).save(argThat(profile ->
                    profile.getUser().equals(testStudentProfileDto.getStudent()) &&
                    profile.getOrganization().equals(testStudentProfileDto.getOrganization())
            ));
        }

        @Test
        @DisplayName("Should handle null organization when creating profile")
        void shouldHandleNullOrganizationWhenCreatingProfile() {
            StudentProfileDto dtoWithNullOrg = StudentProfileDto.builder()
                    .student(testUser)
                    .organization(null)
                    .build();

            studentService.createStudentProfile(dtoWithNullOrg);

            verify(studentProfileRepository).save(argThat(profile ->
                    profile.getUser().equals(testUser) &&
                    profile.getOrganization() == null
            ));
        }
    }

    @Nested
    @DisplayName("editStudentInformation() Tests")
    class EditStudentInformationTests {

        @Test
        @DisplayName("Should successfully edit student information with different phone")
        void shouldEditStudentInformationWithDifferentPhone() {
            when(studentProfileRepository.findByUserId(testUserProfileEditDto.getUserId()))
                    .thenReturn(Optional.of(testStudentProfile));
            when(userService.existsByPhone(testUserProfileEditDto.getPhone())).thenReturn(false);

            studentService.editStudentInformation(testUserProfileEditDto);

            verify(studentProfileRepository).findByUserId(testUserProfileEditDto.getUserId());
            verify(userService).existsByPhone(testUserProfileEditDto.getPhone());
            verify(userService).editStudentInformation(testUserProfileEditDto);
            verify(studentProfileRepository).saveAndFlush(argThat(profile ->
                    profile.getSpecialization().equals(testUserProfileEditDto.getSpecialization())
            ));
        }

        @Test
        @DisplayName("Should successfully edit student information with same phone")
        void shouldEditStudentInformationWithSamePhone() {
            testUserProfileEditDto.setPhone(testUser.getPhone());
            when(studentProfileRepository.findByUserId(testUserProfileEditDto.getUserId()))
                    .thenReturn(Optional.of(testStudentProfile));

            studentService.editStudentInformation(testUserProfileEditDto);

            verify(studentProfileRepository).findByUserId(testUserProfileEditDto.getUserId());
            verify(userService, never()).existsByPhone(any());
            verify(userService).editStudentInformation(testUserProfileEditDto);
            verify(studentProfileRepository).saveAndFlush(any(StudentProfile.class));
        }

        @Test
        @DisplayName("Should throw StudentProfileNotFoundException when profile not found")
        void shouldThrowExceptionWhenStudentProfileNotFound() {
            when(studentProfileRepository.findByUserId(testUserProfileEditDto.getUserId()))
                    .thenReturn(Optional.empty());

            assertThatThrownBy(() -> studentService.editStudentInformation(testUserProfileEditDto))
                    .isInstanceOf(StudentProfileNotFoundException.class)
                    .hasMessage(messageSource.getMessage(
                            "student.profile.not.found",
                            null,
                            "Профиль студента не найден",
                            LocaleContextHolder.getLocale()
                    )
                    );

            verify(studentProfileRepository).findByUserId(testUserProfileEditDto.getUserId());
            verify(userService, never()).existsByPhone(any());
            verify(userService, never()).editStudentInformation(any());
            verify(studentProfileRepository, never()).saveAndFlush(any());
        }

        @Test
        @DisplayName("Should throw PhoneAlreadyExistsException when phone already exists")
        void shouldThrowExceptionWhenPhoneAlreadyExists() {
            when(studentProfileRepository.findByUserId(testUserProfileEditDto.getUserId()))
                    .thenReturn(Optional.of(testStudentProfile));
            when(userService.existsByPhone(testUserProfileEditDto.getPhone())).thenReturn(true);

            assertThatThrownBy(() -> studentService.editStudentInformation(testUserProfileEditDto))
                    .isInstanceOf(PhoneAlreadyExistsException.class)
                    .hasMessage("Пользователь с таким номером телефона уже существует");

            verify(studentProfileRepository).findByUserId(testUserProfileEditDto.getUserId());
            verify(userService).existsByPhone(testUserProfileEditDto.getPhone());
            verify(userService, never()).editStudentInformation(any());
            verify(studentProfileRepository, never()).saveAndFlush(any());
        }
    }

    @Nested
    @DisplayName("getAuthorizedStudentProfile() Tests")
    class GetAuthorizedStudentProfileTests {

        @Test
        @DisplayName("Should return student profile with organization name")
        void shouldReturnStudentProfileWithOrganizationName() {
            when(studentProfileRepository.findByUserId(testUser.getId()))
                    .thenReturn(Optional.of(testStudentProfile));

            StudentProfileDto result = studentService.getAuthorizedStudentProfile(testUser);

            assertThat(result).isNotNull();
            assertThat(result.getStudent()).isEqualTo(testUser);
            assertThat(result.getOrganization()).isEqualTo(testOrganization);
            assertThat(result.getOrganizationName()).isEqualTo("Тест Организация");
            assertThat(result.getSpecialization()).isEqualTo("Информатика");

            verify(studentProfileRepository).findByUserId(testUser.getId());
        }

        @Test
        @DisplayName("Should return student profile with null organization name when organization is null")
        void shouldReturnStudentProfileWithNullOrganizationNameWhenOrganizationIsNull() {
            StudentProfile profileWithoutOrg = StudentProfile.builder()
                    .id(1)
                    .user(testUser)
                    .organization(null)
                    .specialization("Информатика")
                    .build();

            when(studentProfileRepository.findByUserId(testUser.getId()))
                    .thenReturn(Optional.of(profileWithoutOrg));

            StudentProfileDto result = studentService.getAuthorizedStudentProfile(testUser);

            assertThat(result).isNotNull();
            assertThat(result.getStudent()).isEqualTo(testUser);
            assertThat(result.getOrganization()).isNull();
            assertThat(result.getOrganizationName()).isNull();
            assertThat(result.getSpecialization()).isEqualTo("Информатика");

            verify(studentProfileRepository).findByUserId(testUser.getId());
        }

        @Test
        @DisplayName("Should return student profile with null organization name when organization user is null")
        void shouldReturnStudentProfileWithNullOrganizationNameWhenOrganizationUserIsNull() {
            Organization orgWithoutUser = Organization.builder()
                    .id(1)
                    .code("ORG0001")
                    .user(null)
                    .build();

            StudentProfile profileWithOrgWithoutUser = StudentProfile.builder()
                    .id(1)
                    .user(testUser)
                    .organization(orgWithoutUser)
                    .specialization("Информатика")
                    .build();

            when(studentProfileRepository.findByUserId(testUser.getId()))
                    .thenReturn(Optional.of(profileWithOrgWithoutUser));

            StudentProfileDto result = studentService.getAuthorizedStudentProfile(testUser);

            assertThat(result).isNotNull();
            assertThat(result.getStudent()).isEqualTo(testUser);
            assertThat(result.getOrganization()).isEqualTo(orgWithoutUser);
            assertThat(result.getOrganizationName()).isNull();
            assertThat(result.getSpecialization()).isEqualTo("Информатика");

            verify(studentProfileRepository).findByUserId(testUser.getId());
        }

        @Test
        @DisplayName("Should throw StudentProfileNotFoundException when profile not found")
        void shouldThrowExceptionWhenAuthorizedStudentProfileNotFound() {
            when(studentProfileRepository.findByUserId(testUser.getId()))
                    .thenReturn(Optional.empty());

            assertThatThrownBy(() -> studentService.getAuthorizedStudentProfile(testUser))
                    .isInstanceOf(StudentProfileNotFoundException.class)
                    .hasMessage(messageSource.getMessage(
                            "student.profile.not.found",
                            null,
                            "Профиль студента не найден",
                            LocaleContextHolder.getLocale()
                    )
                    );

            verify(studentProfileRepository).findByUserId(testUser.getId());
        }
    }

    @Nested
    @DisplayName("getStudentInformationForEdit() Tests")
    class GetStudentInformationForEditTests {

        @Test
        @DisplayName("Should return user profile edit dto successfully")
        void shouldReturnUserProfileEditDtoSuccessfully() {
            when(studentProfileRepository.findByUserId(testUser.getId()))
                    .thenReturn(Optional.of(testStudentProfile));

            UserProfileEditDto result = studentService.getStudentInformationForEdit(testUser);

            assertThat(result).isNotNull();
            assertThat(result.getUserId()).isEqualTo(testUser.getId());
            assertThat(result.getName()).isEqualTo(testUser.getName());
            assertThat(result.getSurname()).isEqualTo(testUser.getLastName());
            assertThat(result.getPhone()).isEqualTo(testUser.getPhone());
            assertThat(result.getSpecialization()).isEqualTo(testStudentProfile.getSpecialization());

            verify(studentProfileRepository).findByUserId(testUser.getId());
        }

        @Test
        @DisplayName("Should handle null specialization")
        void shouldHandleNullSpecialization() {
            StudentProfile profileWithNullSpecialization = StudentProfile.builder()
                    .id(1)
                    .user(testUser)
                    .organization(testOrganization)
                    .specialization(null)
                    .build();

            when(studentProfileRepository.findByUserId(testUser.getId()))
                    .thenReturn(Optional.of(profileWithNullSpecialization));

            UserProfileEditDto result = studentService.getStudentInformationForEdit(testUser);

            assertThat(result).isNotNull();
            assertThat(result.getUserId()).isEqualTo(testUser.getId());
            assertThat(result.getName()).isEqualTo(testUser.getName());
            assertThat(result.getSurname()).isEqualTo(testUser.getLastName());
            assertThat(result.getPhone()).isEqualTo(testUser.getPhone());
            assertThat(result.getSpecialization()).isNull();

            verify(studentProfileRepository).findByUserId(testUser.getId());
        }

        @Test
        @DisplayName("Should throw exception when profile not found for edit")
        void shouldThrowExceptionWhenProfileNotFoundForEdit() {
            when(studentProfileRepository.findByUserId(testUser.getId()))
                    .thenReturn(Optional.empty());

            assertThatThrownBy(() -> studentService.getStudentInformationForEdit(testUser))
                    .isInstanceOf(RuntimeException.class);

            verify(studentProfileRepository).findByUserId(testUser.getId());
        }
    }

    @Nested
    @DisplayName("Integration and Edge Cases Tests")
    class IntegrationAndEdgeCasesTests {

        @Test
        @DisplayName("Should handle user with null values gracefully")
        void shouldHandleUserWithNullValuesGracefully() {
            User userWithNulls = User.builder()
                    .id(1)
                    .name(null)
                    .lastName(null)
                    .phone(null)
                    .build();

            StudentProfile profileWithNullUser = StudentProfile.builder()
                    .id(1)
                    .user(userWithNulls)
                    .organization(null)
                    .specialization(null)
                    .build();

            when(studentProfileRepository.findByUserId(userWithNulls.getId()))
                    .thenReturn(Optional.of(profileWithNullUser));

            UserProfileEditDto result = studentService.getStudentInformationForEdit(userWithNulls);

            assertThat(result).isNotNull();
            assertThat(result.getUserId()).isEqualTo(userWithNulls.getId());
            assertThat(result.getName()).isNull();
            assertThat(result.getSurname()).isNull();
            assertThat(result.getPhone()).isNull();
            assertThat(result.getSpecialization()).isNull();
        }

        @Test
        @DisplayName("Should verify repository interactions for all methods")
        void shouldVerifyRepositoryInteractionsForAllMethods() {
            when(studentProfileRepository.findByUserId(testUser.getId()))
                    .thenReturn(Optional.of(testStudentProfile));
            when(userService.existsByPhone(any())).thenReturn(false);

            studentService.createStudentProfile(testStudentProfileDto);
            studentService.getAuthorizedStudentProfile(testUser);
            studentService.getStudentInformationForEdit(testUser);
            studentService.editStudentInformation(testUserProfileEditDto);

            verify(studentProfileRepository, times(1)).save(any(StudentProfile.class));
            verify(studentProfileRepository, times(3)).findByUserId(testUser.getId());
            verify(studentProfileRepository, times(1)).saveAndFlush(any(StudentProfile.class));
            verify(userService, times(1)).existsByPhone(any());
            verify(userService, times(1)).editStudentInformation(any());
        }
    }
}
