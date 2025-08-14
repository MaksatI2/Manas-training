package manasTrainingService.service;

import manasTrainingService.dto.TeacherCardDto;
import manasTrainingService.dto.create.CreateTeacherDto;
import manasTrainingService.dto.edit.TeacherProfileEditDto;
import manasTrainingService.dto.profile.TeacherProfileDto;
import manasTrainingService.entity.Role;
import manasTrainingService.entity.TeacherProfile;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.user.PhoneAlreadyExistsException;
import manasTrainingService.exceptions.nsee.user.UserNotFoundException;
import manasTrainingService.repositories.user.TeacherProfileRepository;
import manasTrainingService.service.impl.user.TeacherServiceImpl;
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
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("TeacherService Unit Tests")
class TeacherServiceTest {

    @Mock
    private TeacherProfileRepository teacherProfileRepository;

    @Mock
    private UserService userService;

    @Mock
    private ActivityLogService activityLogService;

    @Mock
    private MessageSource messageSource;

    @InjectMocks
    private TeacherServiceImpl teacherService;



    private User testUser;
    private Role teacherRole;
    private TeacherProfile testTeacherProfile;
    private CreateTeacherDto createTeacherDto;
    private TeacherProfileEditDto teacherProfileEditDto;

    @BeforeEach
    void setUp() {
        teacherRole = Role.builder()
                .id(2)
                .name("TEACHER")
                .build();

        testUser = User.builder()
                .id(1)
                .name("Анна")
                .lastName("Петрова")
                .email("anna@test.com")
                .phone("+996555123456")
                .isActive(true)
                .role(teacherRole)
                .avatarUrl("avatar.jpg")
                .build();

        testTeacherProfile = TeacherProfile.builder()
                .id(1)
                .user(testUser)
                .department("Математика")
                .qualifications("Кандидат наук")
                .bio("Опытный преподаватель математики")
                .build();

        createTeacherDto = CreateTeacherDto.builder()
                .user(testUser)
                .department("Физика")
                .qualifications("Доктор наук")
                .bio("Преподаватель физики")
                .build();

        teacherProfileEditDto = TeacherProfileEditDto.builder()
                .userId(1)
                .name("Анна")
                .surname("Иванова")
                .phone("+996555654321")
                .department("Информатика")
                .qualifications("Магистр")
                .bio("Преподаватель информатики")
                .build();
    }

    @Nested
    @DisplayName("createTeacherProfile() Tests")
    class CreateTeacherProfileTests {

        @Test
        @DisplayName("Should successfully create teacher profile")
        void shouldCreateTeacherProfileSuccessfully() {
            TeacherProfile expectedProfile = TeacherProfile.builder()
                    .user(createTeacherDto.getUser())
                    .department(createTeacherDto.getDepartment())
                    .qualifications(createTeacherDto.getQualifications())
                    .bio(createTeacherDto.getBio())
                    .build();

            when(teacherProfileRepository.save(any(TeacherProfile.class))).thenReturn(expectedProfile);

            teacherService.createTeacherProfile(createTeacherDto);

            verify(teacherProfileRepository).save(argThat(profile ->
                    profile.getUser().equals(createTeacherDto.getUser()) &&
                    profile.getDepartment().equals(createTeacherDto.getDepartment()) &&
                    profile.getQualifications().equals(createTeacherDto.getQualifications()) &&
                    profile.getBio().equals(createTeacherDto.getBio())
            ));
        }

        @Test
        @DisplayName("Should create teacher profile with null values")
        void shouldCreateTeacherProfileWithNullValues() {
            CreateTeacherDto dtoWithNulls = CreateTeacherDto.builder()
                    .user(testUser)
                    .department(null)
                    .qualifications(null)
                    .bio(null)
                    .build();

            teacherService.createTeacherProfile(dtoWithNulls);

            verify(teacherProfileRepository).save(argThat(profile ->
                    profile.getUser().equals(testUser) &&
                    profile.getDepartment() == null &&
                    profile.getQualifications() == null &&
                    profile.getBio() == null
            ));
        }
    }

    @Nested
    @DisplayName("getTeacherProfile() Tests")
    class GetTeacherProfileTests {

        @Test
        @DisplayName("Should return teacher profile successfully")
        void shouldReturnTeacherProfileSuccessfully() {
            when(teacherProfileRepository.findByUser(testUser))
                    .thenReturn(Optional.of(testTeacherProfile));

            TeacherProfileDto result = teacherService.getTeacherProfile(testUser);

            assertThat(result).isNotNull();
            assertThat(result.getTeacher()).isEqualTo(testUser);
            assertThat(result.getDepartment()).isEqualTo(testTeacherProfile.getDepartment());
            assertThat(result.getQualifications()).isEqualTo(testTeacherProfile.getQualifications());
            assertThat(result.getBio()).isEqualTo(testTeacherProfile.getBio());

            verify(teacherProfileRepository).findByUser(testUser);
        }

        @Test
        @DisplayName("Should throw UserNotFoundException when profile not found")
        void shouldThrowExceptionWhenTeacherProfileNotFound() {
            when(teacherProfileRepository.findByUser(testUser))
                    .thenReturn(Optional.empty());

            assertThatThrownBy(() -> teacherService.getTeacherProfile(testUser))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(messageSource.getMessage(
                            "teacher.profile.not.found",
                            null,
                            "Профиль преподавателя не найден",
                            LocaleContextHolder.getLocale()
                    ));

            verify(teacherProfileRepository).findByUser(testUser);
        }
    }

    @Nested
    @DisplayName("editTeacherProfile() Tests")
    class EditTeacherProfileTests {

        @Test
        @DisplayName("Should successfully edit teacher profile with different phone")
        void shouldEditTeacherProfileWithDifferentPhone() {
            when(userService.getUserById(teacherProfileEditDto.getUserId())).thenReturn(testUser);
            when(userService.existsByPhone(teacherProfileEditDto.getPhone())).thenReturn(false);
            when(teacherProfileRepository.findByUser(testUser)).thenReturn(Optional.of(testTeacherProfile));

            teacherService.editTeacherProfile(teacherProfileEditDto);

            verify(userService).getUserById(teacherProfileEditDto.getUserId());
            verify(userService).existsByPhone(teacherProfileEditDto.getPhone());
            verify(userService).saveUser(argThat(user ->
                    user.getName().equals(teacherProfileEditDto.getName()) &&
                    user.getLastName().equals(teacherProfileEditDto.getSurname()) &&
                    user.getPhone().equals(teacherProfileEditDto.getPhone())
            ));
            verify(teacherProfileRepository).findByUser(testUser);
            verify(teacherProfileRepository).save(argThat(profile ->
                    profile.getDepartment().equals(teacherProfileEditDto.getDepartment()) &&
                    profile.getQualifications().equals(teacherProfileEditDto.getQualifications()) &&
                    profile.getBio().equals(teacherProfileEditDto.getBio())
            ));
        }

        @Test
        @DisplayName("Should successfully edit teacher profile with same phone")
        void shouldEditTeacherProfileWithSamePhone() {
            teacherProfileEditDto.setPhone(testUser.getPhone());
            when(userService.getUserById(teacherProfileEditDto.getUserId())).thenReturn(testUser);
            when(teacherProfileRepository.findByUser(testUser)).thenReturn(Optional.of(testTeacherProfile));

            teacherService.editTeacherProfile(teacherProfileEditDto);

            verify(userService).getUserById(teacherProfileEditDto.getUserId());
            verify(userService, never()).existsByPhone(any());
            verify(userService).saveUser(any(User.class));
            verify(teacherProfileRepository).findByUser(testUser);
            verify(teacherProfileRepository).save(any(TeacherProfile.class));
        }

        @Test
        @DisplayName("Should throw PhoneAlreadyExistsException when phone already exists")
        void shouldThrowExceptionWhenPhoneAlreadyExists() {
            when(userService.getUserById(teacherProfileEditDto.getUserId())).thenReturn(testUser);
            when(userService.existsByPhone(teacherProfileEditDto.getPhone())).thenReturn(true);

            assertThatThrownBy(() -> teacherService.editTeacherProfile(teacherProfileEditDto))
                    .isInstanceOf(PhoneAlreadyExistsException.class)
                    .hasMessage("Пользователь с таким номером телефона уже существует");

            verify(userService).getUserById(teacherProfileEditDto.getUserId());
            verify(userService).existsByPhone(teacherProfileEditDto.getPhone());
            verify(userService, never()).saveUser(any());
            verify(teacherProfileRepository, never()).findByUser(any());
            verify(teacherProfileRepository, never()).save(any());
        }

        @Test
        @DisplayName("Should throw UserNotFoundException when teacher profile not found for edit")
        void shouldThrowExceptionWhenTeacherProfileNotFoundForEdit() {
            when(userService.getUserById(teacherProfileEditDto.getUserId())).thenReturn(testUser);
            when(userService.existsByPhone(teacherProfileEditDto.getPhone())).thenReturn(false);
            when(teacherProfileRepository.findByUser(testUser)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> teacherService.editTeacherProfile(teacherProfileEditDto))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(messageSource.getMessage(
                            "teacher.profile.not.found",
                            null,
                            "Профиль преподавателя не найден",
                            LocaleContextHolder.getLocale()
                    ));

            verify(userService).saveUser(any());
            verify(teacherProfileRepository).findByUser(testUser);
            verify(teacherProfileRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("getTeacherInformationForEdit() Tests")
    class GetTeacherInformationForEditTests {

        @Test
        @DisplayName("Should return teacher information for edit successfully")
        void shouldReturnTeacherInformationForEditSuccessfully() {
            when(teacherProfileRepository.findByUser(testUser))
                    .thenReturn(Optional.of(testTeacherProfile));

            TeacherProfileEditDto result = teacherService.getTeacherInformationForEdit(testUser);

            assertThat(result).isNotNull();
            assertThat(result.getUserId()).isEqualTo(testUser.getId());
            assertThat(result.getName()).isEqualTo(testUser.getName());
            assertThat(result.getSurname()).isEqualTo(testUser.getLastName());
            assertThat(result.getPhone()).isEqualTo(testUser.getPhone());
            assertThat(result.getDepartment()).isEqualTo(testTeacherProfile.getDepartment());
            assertThat(result.getQualifications()).isEqualTo(testTeacherProfile.getQualifications());
            assertThat(result.getBio()).isEqualTo(testTeacherProfile.getBio());

            verify(teacherProfileRepository, times(3)).findByUser(testUser);
        }

        @Test
        @DisplayName("Should throw exception when profile not found for edit")
        void shouldThrowExceptionWhenProfileNotFoundForEdit() {
            when(teacherProfileRepository.findByUser(testUser))
                    .thenReturn(Optional.empty());

            assertThatThrownBy(() -> teacherService.getTeacherInformationForEdit(testUser))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(messageSource.getMessage(
                            "teacher.profile.not.found",
                            null,
                            "Профиль преподавателя не найден",
                            LocaleContextHolder.getLocale()
                    ));

            verify(teacherProfileRepository).findByUser(testUser);
        }
    }

    @Nested
    @DisplayName("getTeachers() Tests")
    class GetTeachersTests {

        @Test
        @DisplayName("Should return paginated teachers without filters")
        void shouldReturnPaginatedTeachersWithoutFilters() {
            Pageable pageable = PageRequest.of(0, 10);
            List<TeacherProfile> teacherProfiles = Arrays.asList(testTeacherProfile);

            when(teacherProfileRepository.findAll()).thenReturn(teacherProfiles);

            Page<TeacherCardDto> result = teacherService.getTeachers(pageable, null, null);

            assertThat(result).isNotNull();
            assertThat(result.getContent()).hasSize(1);

            TeacherCardDto teacherCard = result.getContent().get(0);
            assertThat(teacherCard.getId()).isEqualTo(testUser.getId().longValue());
            assertThat(teacherCard.getFullName()).isEqualTo("Анна Петрова");
            assertThat(teacherCard.getAvatarUrl()).isEqualTo(testUser.getAvatarUrl());
            assertThat(teacherCard.getDepartment()).isEqualTo(testTeacherProfile.getDepartment());
            assertThat(teacherCard.getEmail()).isEqualTo(testUser.getEmail());
            assertThat(teacherCard.getPhone()).isEqualTo(testUser.getPhone());

            verify(teacherProfileRepository).findAll();
        }

        @Test
        @DisplayName("Should filter teachers by search term")
        void shouldFilterTeachersBySearchTerm() {
            Pageable pageable = PageRequest.of(0, 10);
            String searchTerm = "анна";
            List<TeacherProfile> teacherProfiles = Arrays.asList(testTeacherProfile);

            when(teacherProfileRepository.findAll()).thenReturn(teacherProfiles);

            Page<TeacherCardDto> result = teacherService.getTeachers(pageable, searchTerm, null);

            assertThat(result).isNotNull();
            assertThat(result.getContent()).hasSize(1);
            assertThat(result.getContent().get(0).getFullName()).contains("Анна");

            verify(teacherProfileRepository).findAll();
        }

        @Test
        @DisplayName("Should filter teachers by department")
        void shouldFilterTeachersByDepartment() {
            Pageable pageable = PageRequest.of(0, 10);
            String department = "Математика";
            List<TeacherProfile> teacherProfiles = Arrays.asList(testTeacherProfile);

            when(teacherProfileRepository.findAll()).thenReturn(teacherProfiles);

            Page<TeacherCardDto> result = teacherService.getTeachers(pageable, null, department);

            assertThat(result).isNotNull();
            assertThat(result.getContent()).hasSize(1);
            assertThat(result.getContent().get(0).getDepartment()).isEqualTo(department);

            verify(teacherProfileRepository).findAll();
        }

        @Test
        @DisplayName("Should exclude inactive users")
        void shouldExcludeInactiveUsers() {
            Pageable pageable = PageRequest.of(0, 10);
            User inactiveUser = User.builder()
                    .id(2)
                    .name("Inactive")
                    .lastName("User")
                    .isActive(false)
                    .role(teacherRole)
                    .build();

            TeacherProfile inactiveProfile = TeacherProfile.builder()
                    .id(2)
                    .user(inactiveUser)
                    .department("Test")
                    .build();

            List<TeacherProfile> teacherProfiles = Arrays.asList(testTeacherProfile, inactiveProfile);

            when(teacherProfileRepository.findAll()).thenReturn(teacherProfiles);

            Page<TeacherCardDto> result = teacherService.getTeachers(pageable, null, null);

            assertThat(result).isNotNull();
            assertThat(result.getContent()).hasSize(1);
            assertThat(result.getContent().get(0).getFullName()).isEqualTo("Анна Петрова");

            verify(teacherProfileRepository).findAll();
        }

        @Test
        @DisplayName("Should handle empty result set")
        void shouldHandleEmptyResultSet() {
            Pageable pageable = PageRequest.of(0, 10);
            when(teacherProfileRepository.findAll()).thenReturn(Arrays.asList());

            Page<TeacherCardDto> result = teacherService.getTeachers(pageable, null, null);

            assertThat(result).isNotNull();
            assertThat(result.getContent()).isEmpty();
            assertThat(result.getTotalElements()).isEqualTo(0);

            verify(teacherProfileRepository).findAll();
        }

        @Test
        @DisplayName("Should handle pagination correctly")
        void shouldHandlePaginationCorrectly() {
            Pageable pageable = PageRequest.of(1, 1);

            User secondUser = User.builder()
                    .id(2)
                    .name("Второй")
                    .lastName("Преподаватель")
                    .email("second@test.com")
                    .phone("+996555222222")
                    .isActive(true)
                    .role(teacherRole)
                    .build();

            TeacherProfile secondProfile = TeacherProfile.builder()
                    .id(2)
                    .user(secondUser)
                    .department("Физика")
                    .build();

            List<TeacherProfile> teacherProfiles = Arrays.asList(testTeacherProfile, secondProfile);

            when(teacherProfileRepository.findAll()).thenReturn(teacherProfiles);

            Page<TeacherCardDto> result = teacherService.getTeachers(pageable, null, null);

            assertThat(result).isNotNull();
            assertThat(result.getContent()).hasSize(1);
            assertThat(result.getContent().get(0).getFullName()).isEqualTo("Второй Преподаватель");
            assertThat(result.getTotalElements()).isEqualTo(2);
            assertThat(result.getTotalPages()).isEqualTo(2);

            verify(teacherProfileRepository).findAll();
        }
    }

    @Nested
    @DisplayName("getTeacherProfileById() Tests")
    class GetTeacherProfileByIdTests {

        @Test
        @DisplayName("Should return teacher profile by id successfully")
        void shouldReturnTeacherProfileByIdSuccessfully() {
            Long teacherId = 1L;
            when(userService.getUserById(teacherId.intValue())).thenReturn(testUser);
            when(teacherProfileRepository.findByUser(testUser)).thenReturn(Optional.of(testTeacherProfile));

            TeacherProfileDto result = teacherService.getTeacherProfileById(teacherId);

            assertThat(result).isNotNull();
            assertThat(result.getTeacher()).isEqualTo(testUser);
            assertThat(result.getDepartment()).isEqualTo(testTeacherProfile.getDepartment());
            assertThat(result.getQualifications()).isEqualTo(testTeacherProfile.getQualifications());
            assertThat(result.getBio()).isEqualTo(testTeacherProfile.getBio());
            assertThat(result.getAvatarUrl()).isEqualTo(testUser.getAvatarUrl());

            verify(userService).getUserById(teacherId.intValue());
            verify(teacherProfileRepository).findByUser(testUser);
        }

        @Test
        @DisplayName("Should throw UserNotFoundException when user is not a teacher")
        void shouldThrowExceptionWhenUserIsNotTeacher() {
            Long userId = 1L;
            Role studentRole = Role.builder().id(1).name("STUDENT").build();
            User nonTeacherUser = User.builder()
                    .id(1)
                    .role(studentRole)
                    .build();

            when(userService.getUserById(userId.intValue())).thenReturn(nonTeacherUser);

            assertThatThrownBy(() -> teacherService.getTeacherProfileById(userId))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(messageSource.getMessage(
                            "user.not.teacher",
                            null,
                            "Пользователь не является преподавателем",
                            LocaleContextHolder.getLocale()
                    ));

            verify(userService).getUserById(userId.intValue());
            verify(teacherProfileRepository, never()).findByUser(any());
        }

        @Test
        @DisplayName("Should throw UserNotFoundException when teacher profile not found")
        void shouldThrowExceptionWhenTeacherProfileNotFoundById() {
            Long teacherId = 1L;
            when(userService.getUserById(teacherId.intValue())).thenReturn(testUser);
            when(teacherProfileRepository.findByUser(testUser)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> teacherService.getTeacherProfileById(teacherId))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(messageSource.getMessage(
                            "teacher.profile.not.found",
                            null,
                            "Профиль преподавателя не найден",
                            LocaleContextHolder.getLocale()
                    ));

            verify(userService).getUserById(teacherId.intValue());
            verify(teacherProfileRepository).findByUser(testUser);
        }
    }

    @Nested
    @DisplayName("Integration and Edge Cases Tests")
    class IntegrationAndEdgeCasesTests {

        @Test
        @DisplayName("Should handle null role gracefully")
        void shouldHandleNullRoleGracefully() {
            Pageable pageable = PageRequest.of(0, 10);
            User userWithNullRole = User.builder()
                    .id(1)
                    .name("Test")
                    .lastName("User")
                    .isActive(true)
                    .role(null)
                    .build();

            TeacherProfile profileWithNullRole = TeacherProfile.builder()
                    .id(1)
                    .user(userWithNullRole)
                    .department("Test")
                    .build();

            when(teacherProfileRepository.findAll()).thenReturn(Arrays.asList(profileWithNullRole));

            Page<TeacherCardDto> result = teacherService.getTeachers(pageable, null, null);

            assertThat(result.getContent()).isEmpty();
            verify(teacherProfileRepository).findAll();
        }

        @Test
        @DisplayName("Should verify all repository interactions")
        void shouldVerifyAllRepositoryInteractions() {
            when(teacherProfileRepository.findByUser(testUser)).thenReturn(Optional.of(testTeacherProfile));
            when(teacherProfileRepository.findAll()).thenReturn(Arrays.asList(testTeacherProfile));
            when(userService.getUserById(any())).thenReturn(testUser);
            when(userService.existsByPhone(any())).thenReturn(false);

            Pageable pageable = PageRequest.of(0, 10);

            teacherService.createTeacherProfile(createTeacherDto);
            teacherService.getTeacherProfile(testUser);
            teacherService.getTeacherInformationForEdit(testUser);
            teacherService.editTeacherProfile(teacherProfileEditDto);
            teacherService.getTeachers(pageable, null, null);
            teacherService.getTeacherProfileById(1L);

            verify(teacherProfileRepository, times(2)).save(any(TeacherProfile.class));
            verify(teacherProfileRepository, times(6)).findByUser(any(User.class));
            verify(teacherProfileRepository, times(1)).findAll();
            verify(userService, times(2)).getUserById(any());
            verify(userService, times(1)).existsByPhone(any());
            verify(userService, times(1)).saveUser(any());
        }
    }
}