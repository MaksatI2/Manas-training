package manasTrainingService.service.course;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.ValidationException;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.create.CreateCourseDto;
import manasTrainingService.dto.edit.CourseEditDto;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseCategory;
import manasTrainingService.repositories.course.CourseRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.CourseApplicationService;
import manasTrainingService.service.impl.course.CourseAdminServiceImpl;
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

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CourseAdminService Tests")
class CourseAdminServiceTest {

    @Mock
    private CourseRepository courseRepository;

    @Mock
    private CourseCategoryService categoryService;

    @Mock
    private CourseApplicationService courseApplicationService;
    @Mock
    private CourseInstanceService courseInstanceService;
    @Mock
    private CourseTeacherService courseTeacherService;

    @Mock
    private UserService userService;
    @Mock
    private ActivityLogService activityLogService;
    @Mock
    private MessageSource messageSource;

    @InjectMocks
    private CourseAdminServiceImpl courseAdminService;

    private Course testCourse;
    private CourseCategory testCategory;
    private CourseDto testCourseDto;
    private CourseCategoryDto testCategoryDto;
    private CreateCourseDto createCourseDto;
    private CourseEditDto courseEditDto;

    @BeforeEach
    void setUp() {
        testCategory = CourseCategory.builder()
                .id(1)
                .name("Программирование")
                .description("Курсы по программированию")
                .build();

        testCategoryDto = CourseCategoryDto.builder()
                .id(1)
                .name("Программирование")
                .description("Курсы по программированию")
                .build();

        testCourse = Course.builder()
                .id(1)
                .title("Java Основы")
                .code("JAVA_BASICS")
                .description("Изучение основ Java")
                .durationHours(40)
                .isIndividual(false)
                .isActive(true)
                .category(testCategory)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        testCourseDto = CourseDto.builder()
                .id(1)
                .title("Java Основы")
                .code("JAVA_BASICS")
                .description("Изучение основ Java")
                .duration(40)
                .individual(false)
                .active(true)
                .category(testCategoryDto)
                .categoryId(1)
                .createdAt(testCourse.getCreatedAt())
                .updatedAt(testCourse.getUpdatedAt())
                .build();

        createCourseDto = CreateCourseDto.builder()
                .title("Spring Boot")
                .code("SPRING_BOOT")
                .description("Изучение Spring Boot")
                .duration(60)
                .active(true)
                .categoryId(1)
                .build();

        courseEditDto = CourseEditDto.builder()
                .id(1)
                .title("Java Advanced")
                .code("JAVA_ADV")
                .description("Продвинутая Java")
                .duration(80)
                .active(false)
                .categoryId(1)
                .build();
    }

    @Nested
    @DisplayName("prepareEditDtoWithRequestParams Tests")
    class PrepareEditDtoWithRequestParamsTests {

        @Test
        @DisplayName("Should set active to true when activeValues contains 'true'")
        void shouldSetActiveToTrueWhenActiveValuesContainsTrue() {
            CourseEditDto editDto = new CourseEditDto();
            String[] activeValues = {"false", "true", "invalid"};
            String[] individualValues = {"false"};

            CourseEditDto result = courseAdminService.prepareEditDtoWithRequestParams(
                    editDto, activeValues, individualValues);

            assertThat(result.getActive()).isTrue();
        }

        @Test
        @DisplayName("Should set both to false when no 'true' values provided")
        void shouldSetBothToFalseWhenNoTrueValues() {
            CourseEditDto editDto = new CourseEditDto();
            String[] activeValues = {"false", "invalid"};
            String[] individualValues = {"false", "no"};

            CourseEditDto result = courseAdminService.prepareEditDtoWithRequestParams(
                    editDto, activeValues, individualValues);

            assertThat(result.getActive()).isFalse();
        }

        @Test
        @DisplayName("Should handle null arrays")
        void shouldHandleNullArrays() {
            CourseEditDto editDto = new CourseEditDto();

            CourseEditDto result = courseAdminService.prepareEditDtoWithRequestParams(
                    editDto, null, null);

            assertThat(result.getActive()).isFalse();
        }

        @Test
        @DisplayName("Should handle empty arrays")
        void shouldHandleEmptyArrays() {
            CourseEditDto editDto = new CourseEditDto();
            String[] emptyArray = {};

            CourseEditDto result = courseAdminService.prepareEditDtoWithRequestParams(
                    editDto, emptyArray, emptyArray);

            assertThat(result.getActive()).isFalse();
        }
    }

    @Nested
    @DisplayName("getAllCourses Tests")
    class GetAllCoursesTests {

        @Test
        @DisplayName("Should return all courses as DTOs")
        void shouldReturnAllCoursesAsDtos() {
            Course course2 = Course.builder()
                    .id(2)
                    .title("Python Basics")
                    .code("PYTHON_BASICS")
                    .description("Python fundamentals")
                    .durationHours(35)
                    .isIndividual(true)
                    .isActive(false)
                    .category(testCategory)
                    .createdAt(LocalDateTime.now())
                    .updatedAt(LocalDateTime.now())
                    .build();

            when(courseRepository.findAll()).thenReturn(Arrays.asList(testCourse, course2));
            when(categoryService.convertToDto(testCategory)).thenReturn(testCategoryDto);

            List<CourseDto> result = courseAdminService.getAllCourses();

            assertThat(result).hasSize(2);
            assertThat(result.get(0).getId()).isEqualTo(1);
            assertThat(result.get(0).getTitle()).isEqualTo("Java Основы");
            assertThat(result.get(1).getId()).isEqualTo(2);
            assertThat(result.get(1).getTitle()).isEqualTo("Python Basics");

            verify(courseRepository).findAll();
            verify(categoryService, times(2)).convertToDto(testCategory);
        }

        @Test
        @DisplayName("Should return empty list when no courses exist")
        void shouldReturnEmptyListWhenNoCoursesExist() {
            when(courseRepository.findAll()).thenReturn(Arrays.asList());

            List<CourseDto> result = courseAdminService.getAllCourses();

            assertThat(result).isEmpty();
            verify(courseRepository).findAll();
        }
    }

    @Nested
    @DisplayName("getById Tests")
    class GetByIdTests {

        @Test
        @DisplayName("Should return course DTO when course exists")
        void shouldReturnCourseDtoWhenCourseExists() {
            when(courseRepository.findById(1)).thenReturn(Optional.of(testCourse));
            when(categoryService.convertToDto(testCategory)).thenReturn(testCategoryDto);

            CourseDto result = courseAdminService.getById(1);

            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(1);
            assertThat(result.getTitle()).isEqualTo("Java Основы");
            assertThat(result.getCode()).isEqualTo("JAVA_BASICS");

            verify(courseRepository).findById(1);
            verify(categoryService).convertToDto(testCategory);
        }

        @Test
        @DisplayName("Should throw EntityNotFoundException when course not found")
        void shouldThrowEntityNotFoundExceptionWhenCourseNotFound() {
            when(courseRepository.findById(999)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> courseAdminService.getById(999))
                    .isInstanceOf(EntityNotFoundException.class)
                    .hasMessage(messageSource.getMessage(
                            "course.not.found",
                            new Object[]{999},
                            LocaleContextHolder.getLocale()
                    ));

            verify(courseRepository).findById(999);
        }
    }

    @Nested
    @DisplayName("create Tests")
    class CreateTests {

        @Test
        @DisplayName("Should create course successfully")
        void shouldCreateCourseSuccessfully() {
            when(courseRepository.existsByCode("SPRING_BOOT")).thenReturn(false);
            when(categoryService.getById(1)).thenReturn(testCategoryDto);
            when(courseRepository.save(any(Course.class))).thenAnswer(invocation -> {
                Course course = invocation.getArgument(0);
                course.setId(2);
                return course;
            });
            when(categoryService.convertToDto(any(CourseCategory.class))).thenReturn(testCategoryDto);

            CourseDto result = courseAdminService.create(createCourseDto);

            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(2);
            assertThat(result.getTitle()).isEqualTo("Spring Boot");
            assertThat(result.getCode()).isEqualTo("SPRING_BOOT");
            assertThat(result.getActive()).isTrue();

            verify(courseRepository).existsByCode("SPRING_BOOT");
            verify(categoryService).getById(1);
            verify(courseRepository).save(any(Course.class));
        }

        @Test
        @DisplayName("Should throw ValidationException when course code already exists")
        void shouldThrowValidationExceptionWhenCourseCodeAlreadyExists() {
            when(courseRepository.existsByCode("SPRING_BOOT")).thenReturn(true);

            assertThatThrownBy(() -> courseAdminService.create(createCourseDto))
                    .isInstanceOf(ValidationException.class)
                    .hasMessage(messageSource.getMessage(
                            "course.code.exists",
                            new Object[]{"SPRING_BOOT"},
                            LocaleContextHolder.getLocale()
                    ));

            verify(courseRepository).existsByCode("SPRING_BOOT");
            verify(courseRepository, never()).save(any());
        }

        @Test
        @DisplayName("Should handle null boolean values in CreateCourseDto")
        void shouldHandleNullBooleanValuesInCreateCourseDto() {
            createCourseDto.setActive(null);

            when(courseRepository.existsByCode("SPRING_BOOT")).thenReturn(false);
            when(categoryService.getById(1)).thenReturn(testCategoryDto);
            when(courseRepository.save(any(Course.class))).thenAnswer(invocation -> {
                Course course = invocation.getArgument(0);
                course.setId(2);
                return course;
            });
            when(categoryService.convertToDto(any(CourseCategory.class))).thenReturn(testCategoryDto);

            CourseDto result = courseAdminService.create(createCourseDto);

            assertThat(result.getIndividual()).isFalse();
            assertThat(result.getActive()).isFalse();
        }
    }

    @Nested
    @DisplayName("update Tests")
    class UpdateTests {

        @Test
        @DisplayName("Should update course successfully")
        void shouldUpdateCourseSuccessfully() {
            when(courseRepository.findById(1)).thenReturn(Optional.of(testCourse));
            when(courseRepository.existsByCodeAndIdNot("JAVA_ADV", 1)).thenReturn(false);
            when(categoryService.getById(1)).thenReturn(testCategoryDto);
            when(courseRepository.save(testCourse)).thenReturn(testCourse);
            when(categoryService.convertToDto(any(CourseCategory.class))).thenReturn(testCategoryDto);

            CourseDto result = courseAdminService.update(courseEditDto);

            assertThat(result).isNotNull();
            assertThat(result.getTitle()).isEqualTo("Java Advanced");
            assertThat(result.getCode()).isEqualTo("JAVA_ADV");
            assertThat(result.getDuration()).isEqualTo(80);
            assertThat(result.getActive()).isFalse();

            verify(courseRepository).findById(1);
            verify(courseRepository).existsByCodeAndIdNot("JAVA_ADV", 1);
            verify(courseRepository).save(testCourse);
        }

        @Test
        @DisplayName("Should throw EntityNotFoundException when course not found for update")
        void shouldThrowEntityNotFoundExceptionWhenCourseNotFoundForUpdate() {
            when(courseRepository.findById(1)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> courseAdminService.update(courseEditDto))
                    .isInstanceOf(EntityNotFoundException.class)
                    .hasMessage(messageSource.getMessage(
                            "course.not.found",
                            new Object[]{1},
                            LocaleContextHolder.getLocale()
                    ));

            verify(courseRepository).findById(1);
            verify(courseRepository, never()).save(any());
        }

        @Test
        @DisplayName("Should throw ValidationException when updating to existing code")
        void shouldThrowValidationExceptionWhenUpdatingToExistingCode() {
            when(courseRepository.findById(1)).thenReturn(Optional.of(testCourse));
            when(courseRepository.existsByCodeAndIdNot("JAVA_ADV", 1)).thenReturn(true);

            assertThatThrownBy(() -> courseAdminService.update(courseEditDto))
                    .isInstanceOf(ValidationException.class)
                    .hasMessage(messageSource.getMessage(
                            "course.code.exists",
                            new Object[]{"JAVA_ADV"},
                            LocaleContextHolder.getLocale()
                    ));

            verify(courseRepository).findById(1);
            verify(courseRepository).existsByCodeAndIdNot("JAVA_ADV", 1);
            verify(courseRepository, never()).save(any());
        }

        @Test
        @DisplayName("Should handle null boolean values in CourseEditDto")
        void shouldHandleNullBooleanValuesInCourseEditDto() {
            courseEditDto.setActive(null);

            when(courseRepository.findById(1)).thenReturn(Optional.of(testCourse));
            when(courseRepository.existsByCodeAndIdNot("JAVA_ADV", 1)).thenReturn(false);
            when(categoryService.getById(1)).thenReturn(testCategoryDto);
            when(courseRepository.save(testCourse)).thenReturn(testCourse);
            when(categoryService.convertToDto(any(CourseCategory.class))).thenReturn(testCategoryDto);

            CourseDto result = courseAdminService.update(courseEditDto);

            assertThat(result.getIndividual()).isFalse();
            assertThat(result.getActive()).isFalse();
        }
    }

    @Nested
    @DisplayName("delete Tests")
    class DeleteTests {

        @Test
        @DisplayName("Should delete course successfully")
        void shouldDeleteCourseSuccessfully() {
            Integer courseId = 1;

            when(courseRepository.existsById(courseId)).thenReturn(true);

            when(courseApplicationService.getByCourseId(courseId)).thenReturn(Collections.emptyList());
            when(courseInstanceService.getByCourseId(courseId)).thenReturn(Collections.emptyList());
            when(courseTeacherService.getByCourseId(courseId)).thenReturn(Collections.emptyList());

            courseAdminService.deleteCourse(courseId);

            verify(courseRepository, times(2)).existsById(courseId);
            verify(courseApplicationService, times(1)).getByCourseId(courseId);
            verify(courseInstanceService, times(1)).getByCourseId(courseId);
            verify(courseTeacherService, times(1)).getByCourseId(courseId);
            verify(courseRepository, times(1)).deleteById(courseId);
        }

        @Test
        @DisplayName("Should throw EntityNotFoundException when course not found for deletion")
        void shouldThrowEntityNotFoundExceptionWhenCourseNotFoundForDeletion() {
            when(courseRepository.existsById(999)).thenReturn(false);

            assertThatThrownBy(() -> courseAdminService.deleteCourse(999))
                    .isInstanceOf(EntityNotFoundException.class)
                    .hasMessage(messageSource.getMessage(
                            "course.not.found",
                            new Object[]{999},
                            LocaleContextHolder.getLocale()
                    ));

            verify(courseRepository).existsById(999);
            verify(courseRepository, never()).deleteById(any());
        }
    }

    @Nested
    @DisplayName("existsByCode Tests")
    class ExistsByCodeTests {

        @Test
        @DisplayName("Should return true when course exists by code")
        void shouldReturnTrueWhenCourseExistsByCode() {
            when(courseRepository.existsByCode("JAVA_BASICS")).thenReturn(true);

            boolean result = courseAdminService.existsByCode("JAVA_BASICS");

            assertThat(result).isTrue();
            verify(courseRepository).existsByCode("JAVA_BASICS");
        }

        @Test
        @DisplayName("Should return false when course does not exist by code")
        void shouldReturnFalseWhenCourseDoesNotExistByCode() {
            when(courseRepository.existsByCode("NON_EXISTENT")).thenReturn(false);

            boolean result = courseAdminService.existsByCode("NON_EXISTENT");

            assertThat(result).isFalse();
            verify(courseRepository).existsByCode("NON_EXISTENT");
        }
    }

    @Nested
    @DisplayName("existsByCodeAndIdNot Tests")
    class ExistsByCodeAndIdNotTests {

        @Test
        @DisplayName("Should return true when another course exists with same code")
        void shouldReturnTrueWhenAnotherCourseExistsWithSameCode() {
            when(courseRepository.existsByCodeAndIdNot("JAVA_BASICS", 2)).thenReturn(true);

            boolean result = courseAdminService.existsByCodeAndIdNot("JAVA_BASICS", 2);

            assertThat(result).isTrue();
            verify(courseRepository).existsByCodeAndIdNot("JAVA_BASICS", 2);
        }

        @Test
        @DisplayName("Should return false when no other course exists with same code")
        void shouldReturnFalseWhenNoOtherCourseExistsWithSameCode() {
            when(courseRepository.existsByCodeAndIdNot("UNIQUE_CODE", 1)).thenReturn(false);

            boolean result = courseAdminService.existsByCodeAndIdNot("UNIQUE_CODE", 1);

            assertThat(result).isFalse();
            verify(courseRepository).existsByCodeAndIdNot("UNIQUE_CODE", 1);
        }
    }

    @Nested
    @DisplayName("convertToEditDto Tests")
    class ConvertToEditDtoTests {

        @Test
        @DisplayName("Should convert CourseDto to CourseEditDto successfully")
        void shouldConvertCourseDtoToCourseEditDtoSuccessfully() {
            CourseEditDto result = courseAdminService.convertToEditDto(testCourseDto);

            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(testCourseDto.getId());
            assertThat(result.getTitle()).isEqualTo(testCourseDto.getTitle());
            assertThat(result.getCode()).isEqualTo(testCourseDto.getCode());
            assertThat(result.getDescription()).isEqualTo(testCourseDto.getDescription());
            assertThat(result.getDuration()).isEqualTo(testCourseDto.getDuration());
            assertThat(result.getActive()).isEqualTo(testCourseDto.getActive());
            assertThat(result.getCategoryId()).isEqualTo(testCourseDto.getCategoryId());
        }

        @Test
        @DisplayName("Should handle null values in CourseDto")
        void shouldHandleNullValuesInCourseDto() {
            CourseDto dtoWithNulls = CourseDto.builder()
                    .id(1)
                    .title("Test Course")
                    .code("TEST")
                    .individual(null)
                    .active(null)
                    .categoryId(1)
                    .build();

            CourseEditDto result = courseAdminService.convertToEditDto(dtoWithNulls);

            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(1);
            assertThat(result.getTitle()).isEqualTo("Test Course");
            assertThat(result.getCode()).isEqualTo("TEST");
            assertThat(result.getActive()).isNull();
            assertThat(result.getCategoryId()).isEqualTo(1);
        }
    }

    @Nested
    @DisplayName("convertToDto Tests")
    class ConvertToDtoTests {

        @Test
        @DisplayName("Should convert Course entity to CourseDto successfully")
        void shouldConvertCourseEntityToCourseDtoSuccessfully() {
            when(categoryService.convertToDto(testCategory)).thenReturn(testCategoryDto);

            CourseDto result = courseAdminService.convertToDto(testCourse);

            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(testCourse.getId());
            assertThat(result.getTitle()).isEqualTo(testCourse.getTitle());
            assertThat(result.getCode()).isEqualTo(testCourse.getCode());
            assertThat(result.getDescription()).isEqualTo(testCourse.getDescription());
            assertThat(result.getDuration()).isEqualTo(testCourse.getDurationHours());
            assertThat(result.getIndividual()).isEqualTo(testCourse.getIsIndividual());
            assertThat(result.getActive()).isEqualTo(testCourse.getIsActive());
            assertThat(result.getCreatedAt()).isEqualTo(testCourse.getCreatedAt());
            assertThat(result.getUpdatedAt()).isEqualTo(testCourse.getUpdatedAt());
            assertThat(result.getCategory()).isEqualTo(testCategoryDto);
            assertThat(result.getCategoryId()).isEqualTo(testCategory.getId());

            verify(categoryService).convertToDto(testCategory);
        }

        @Test
        @DisplayName("Should handle null category in Course entity")
        void shouldHandleNullCategoryInCourseEntity() {
            Course courseWithNullCategory = Course.builder()
                    .id(1)
                    .title("Test Course")
                    .code("TEST")
                    .description("Test Description")
                    .durationHours(20)
                    .isIndividual(false)
                    .isActive(true)
                    .category(null)
                    .createdAt(LocalDateTime.now())
                    .updatedAt(LocalDateTime.now())
                    .build();

            assertThatThrownBy(() -> courseAdminService.convertToDto(courseWithNullCategory))
                    .isInstanceOf(NullPointerException.class);
        }
    }

    @Nested
    @DisplayName("Integration Tests")
    class IntegrationTests {

        @Test
        @DisplayName("Should perform complete CRUD cycle")
        void shouldPerformCompleteCrudCycle() {
            when(courseRepository.existsByCode("NEW_COURSE")).thenReturn(false);
            when(categoryService.getById(1)).thenReturn(testCategoryDto);
            when(courseRepository.save(any(Course.class))).thenAnswer(invocation -> {
                Course course = invocation.getArgument(0);
                course.setId(10);
                return course;
            });
            when(categoryService.convertToDto(any(CourseCategory.class))).thenReturn(testCategoryDto);

            CreateCourseDto newCourseDto = CreateCourseDto.builder()
                    .title("New Course")
                    .code("NEW_COURSE")
                    .description("New course description")
                    .duration(30)
                    .active(true)
                    .categoryId(1)
                    .build();

            CourseDto created = courseAdminService.create(newCourseDto);
            assertThat(created.getId()).isEqualTo(10);
            assertThat(created.getCode()).isEqualTo("NEW_COURSE");

            Course persistedCourse = Course.builder()
                    .id(10)
                    .title("New Course")
                    .code("NEW_COURSE")
                    .description("New course description")
                    .durationHours(30)
                    .isIndividual(false)
                    .isActive(true)
                    .category(testCategory)
                    .createdAt(LocalDateTime.now())
                    .updatedAt(LocalDateTime.now())
                    .build();

            when(courseRepository.findById(10)).thenReturn(Optional.of(persistedCourse));
            CourseDto retrieved = courseAdminService.getById(10);
            assertThat(retrieved.getId()).isEqualTo(10);

            CourseEditDto updateDto = CourseEditDto.builder()
                    .id(10)
                    .title("Updated Course")
                    .code("UPDATED_COURSE")
                    .description("Updated description")
                    .duration(40)
                    .active(false)
                    .categoryId(1)
                    .build();

            when(courseRepository.existsByCodeAndIdNot("UPDATED_COURSE", 10)).thenReturn(false);
            when(courseRepository.save(persistedCourse)).thenReturn(persistedCourse);

            CourseDto updated = courseAdminService.update(updateDto);
            assertThat(updated.getTitle()).isEqualTo("Updated Course");

            when(courseRepository.existsById(10)).thenReturn(true);
            courseAdminService.deleteCourse(10);

            verify(courseRepository).deleteById(10);
        }
    }
}