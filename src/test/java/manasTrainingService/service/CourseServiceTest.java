package manasTrainingService.service;

import jakarta.persistence.EntityNotFoundException;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseCategory;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.course.CourseNotFoundException;
import manasTrainingService.repositories.course.CourseInstanceRepository;
import manasTrainingService.repositories.course.CourseRepository;
import manasTrainingService.service.course.CourseCategoryService;
import manasTrainingService.service.impl.course.CourseServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CourseService Tests")
class CourseServiceTest {

    @Mock
    private CourseRepository courseRepository;

    @Mock
    private CourseCategoryService categoryService;

    @Mock
    private CourseCategoryService categoryAdminService;

    @Mock
    private CourseInstanceRepository courseInstanceRepository;

    @Mock
    private UserService userService;
    @Mock
    private ActivityLogService activityLogService;

    @InjectMocks
    private CourseServiceImpl courseService;

    private Course testCourse;
    private CourseCategory testCategory;
    private CourseCategoryDto testCategoryDto;
    private CourseInstance testCourseInstance;
    private User testUser;

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

        testCourseInstance = CourseInstance.builder()
                .id(1)
                .course(testCourse)
                .isActive(true)
                .build();

        testUser = User.builder()
                .id(1)
                .name("testuser")
                .build();
    }

    @Nested
    @DisplayName("getAllCourses Tests")
    class GetAllCoursesTests {

        @Test
        @DisplayName("Should return all courses as DTOs using toDto method")
        void shouldReturnAllCoursesAsDtosUsingToDtoMethod() {
            Course course2 = Course.builder()
                    .id(2)
                    .title("Python Basics")
                    .code("PYTHON_BASICS")
                    .description("Python fundamentals")
                    .durationHours(35)
                    .isIndividual(true)
                    .isActive(false)
                    .category(testCategory)
                    .build();

            when(courseRepository.findAll()).thenReturn(Arrays.asList(testCourse, course2));

            List<CourseDto> result = courseService.getAllCourses();

            assertThat(result).hasSize(2);

            CourseDto firstDto = result.get(0);
            assertThat(firstDto.getId()).isEqualTo(1);
            assertThat(firstDto.getTitle()).isEqualTo("Java Основы");
            assertThat(firstDto.getCode()).isEqualTo("JAVA_BASICS");
            assertThat(firstDto.getDescription()).isEqualTo("Изучение основ Java");
            assertThat(firstDto.getDuration()).isEqualTo(40);
            assertThat(firstDto.getCategory().getId()).isEqualTo(1);
            assertThat(firstDto.getCategory().getName()).isEqualTo("Программирование");

            CourseDto secondDto = result.get(1);
            assertThat(secondDto.getId()).isEqualTo(2);
            assertThat(secondDto.getTitle()).isEqualTo("Python Basics");
            assertThat(secondDto.getCode()).isEqualTo("PYTHON_BASICS");

            verify(courseRepository).findAll();
        }

        @Test
        @DisplayName("Should return empty list when no courses exist")
        void shouldReturnEmptyListWhenNoCoursesExist() {
            when(courseRepository.findAll()).thenReturn(Collections.emptyList());

            List<CourseDto> result = courseService.getAllCourses();

            assertThat(result).isEmpty();
            verify(courseRepository).findAll();
        }

        @Test
        @DisplayName("Should handle courses with null categories")
        void shouldHandleCoursesWithNullCategories() {
            Course courseWithNullCategory = Course.builder()
                    .id(1)
                    .title("Test Course")
                    .code("TEST")
                    .description("Test Description")
                    .durationHours(20)
                    .category(null)
                    .build();

            when(courseRepository.findAll()).thenReturn(Arrays.asList(courseWithNullCategory));

            assertThatThrownBy(() -> courseService.getAllCourses())
                    .isInstanceOf(NullPointerException.class);

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
            when(categoryAdminService.convertToDto(testCategory)).thenReturn(testCategoryDto);

            CourseDto result = courseService.getById(1);

            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(1);
            assertThat(result.getTitle()).isEqualTo("Java Основы");
            assertThat(result.getCode()).isEqualTo("JAVA_BASICS");
            assertThat(result.getDescription()).isEqualTo("Изучение основ Java");
            assertThat(result.getDuration()).isEqualTo(40);
            assertThat(result.getIndividual()).isFalse();
            assertThat(result.getActive()).isTrue();
            assertThat(result.getCategory()).isEqualTo(testCategoryDto);
            assertThat(result.getCategoryId()).isEqualTo(1);
            assertThat(result.getCreatedAt()).isEqualTo(testCourse.getCreatedAt());
            assertThat(result.getUpdatedAt()).isEqualTo(testCourse.getUpdatedAt());

            verify(courseRepository).findById(1);
            verify(categoryAdminService).convertToDto(testCategory);
        }

        @Test
        @DisplayName("Should throw EntityNotFoundException when course not found")
        void shouldThrowEntityNotFoundExceptionWhenCourseNotFound() {
            when(courseRepository.findById(999)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> courseService.getById(999))
                    .isInstanceOf(EntityNotFoundException.class)
                    .hasMessage("Курс с ID 999 не найден");

            verify(courseRepository).findById(999);
            verify(categoryAdminService, never()).convertToDto(any());
        }
    }

    @Nested
    @DisplayName("getCategories Tests")
    class GetCategoriesTests {

        @Test
        @DisplayName("Should return all categories")
        void shouldReturnAllCategories() {
            List<CourseCategoryDto> expectedCategories = Arrays.asList(
                    testCategoryDto,
                    CourseCategoryDto.builder()
                            .id(2)
                            .name("Дизайн")
                            .description("Курсы по дизайну")
                            .build()
            );

            when(categoryService.getAllCategories()).thenReturn(expectedCategories);

            List<CourseCategoryDto> result = courseService.getCategories();

            assertThat(result).hasSize(2);
            assertThat(result.get(0).getId()).isEqualTo(1);
            assertThat(result.get(0).getName()).isEqualTo("Программирование");
            assertThat(result.get(1).getId()).isEqualTo(2);
            assertThat(result.get(1).getName()).isEqualTo("Дизайн");

            verify(categoryService).getAllCategories();
        }

        @Test
        @DisplayName("Should return empty list when no categories exist")
        void shouldReturnEmptyListWhenNoCategoriesExist() {
            when(categoryService.getAllCategories()).thenReturn(Collections.emptyList());

            List<CourseCategoryDto> result = courseService.getCategories();

            assertThat(result).isEmpty();
            verify(categoryService).getAllCategories();
        }
    }

    @Nested
    @DisplayName("getCourseById Tests")
    class GetCourseByIdTests {

        @Test
        @DisplayName("Should return course entity when course exists")
        void shouldReturnCourseEntityWhenCourseExists() {
            when(courseRepository.findById(1)).thenReturn(Optional.of(testCourse));

            Course result = courseService.getCourseById(1);

            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(1);
            assertThat(result.getTitle()).isEqualTo("Java Основы");
            assertThat(result.getCode()).isEqualTo("JAVA_BASICS");

            verify(courseRepository).findById(1);
        }

        @Test
        @DisplayName("Should throw CourseNotFoundException when course not found")
        void shouldThrowCourseNotFoundExceptionWhenCourseNotFound() {
            when(courseRepository.findById(999)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> courseService.getCourseById(999))
                    .isInstanceOf(CourseNotFoundException.class)
                    .hasMessage("Курс не был найден");

            verify(courseRepository).findById(999);
        }
    }

    @Nested
    @DisplayName("getAvailableCoursesForOrganization Tests")
    class GetAvailableCoursesForOrganizationTests {

        @Test
        @DisplayName("Should return available courses for organization")
        void shouldReturnAvailableCoursesForOrganization() {
            CourseCategory testCategory = CourseCategory.builder()
                    .id(10)
                    .name("Backend")
                    .build();

            Course course1 = Course.builder()
                    .id(1)
                    .title("Java Основы")
                    .code("JAVA-101")
                    .description("Базовый курс по Java")
                    .durationHours(40)
                    .isActive(true)
                    .isIndividual(false)
                    .createdAt(LocalDateTime.now().minusDays(10))
                    .updatedAt(LocalDateTime.now().minusDays(5))
                    .category(testCategory)
                    .build();

            CourseInstance instance1 = CourseInstance.builder()
                    .id(1)
                    .course(course1)
                    .title("Java Group 1")
                    .isActive(true)
                    .startDate(LocalDateTime.now().plusDays(1))
                    .endDate(LocalDateTime.now().plusDays(30))
                    .build();

            when(courseInstanceRepository.findAllByIsActiveTrue()).thenReturn(List.of(instance1));

            List<CourseDto> result = courseService.getAvailableCoursesForOrganization(testUser);

            assertThat(result).hasSize(1);

            CourseDto dto = result.get(0);
            assertThat(dto.getId()).isEqualTo(1);
            assertThat(dto.getTitle()).isEqualTo("Java Основы");
            assertThat(dto.getCode()).isEqualTo("JAVA-101");
            assertThat(dto.getDescription()).isEqualTo("Базовый курс по Java");
            assertThat(dto.getDuration()).isEqualTo(40);
            assertThat(dto.getCategoryId()).isEqualTo(10);

            verify(courseInstanceRepository).findAllByIsActiveTrue();
        }


        @Test
        @DisplayName("Should return empty list when no active course instances exist")
        void shouldReturnEmptyListWhenNoActiveCourseInstancesExist() {
            when(courseInstanceRepository.findAllByIsActiveTrue())
                    .thenReturn(Collections.emptyList());

            List<CourseDto> result = courseService.getAvailableCoursesForOrganization(testUser);

            assertThat(result).isEmpty();
            verify(courseInstanceRepository).findAllByIsActiveTrue();
        }

        @Test
        @DisplayName("Should handle null user parameter")
        void shouldHandleNullUserParameter() {
            CourseCategory testCategory = CourseCategory.builder()
                    .id(10)
                    .name("Backend")
                    .build();

            Course testCourse = Course.builder()
                    .id(1)
                    .title("Java Основы")
                    .code("JAVA-101")
                    .description("Базовый курс по Java")
                    .durationHours(40)
                    .isActive(true)
                    .isIndividual(false)
                    .createdAt(LocalDateTime.now().minusDays(5))
                    .updatedAt(LocalDateTime.now().minusDays(1))
                    .category(testCategory)
                    .build();

            CourseInstance testCourseInstance = CourseInstance.builder()
                    .id(100)
                    .title("Java Group")
                    .course(testCourse)
                    .startDate(LocalDateTime.now().plusDays(2))
                    .endDate(LocalDateTime.now().plusDays(10))
                    .isActive(true)
                    .build();

            when(courseInstanceRepository.findAllByIsActiveTrue())
                    .thenReturn(List.of(testCourseInstance));

            List<CourseDto> result = courseService.getAvailableCoursesForOrganization(null);

            assertThat(result).hasSize(1);
            CourseDto dto = result.get(0);
            assertThat(dto.getId()).isEqualTo(1);
            assertThat(dto.getTitle()).isEqualTo("Java Основы");
            assertThat(dto.getCode()).isEqualTo("JAVA-101");
            assertThat(dto.getDescription()).isEqualTo("Базовый курс по Java");
            assertThat(dto.getDuration()).isEqualTo(40);
            assertThat(dto.getCategoryId()).isEqualTo(10);

            assertThat(dto.getInstanceTitle()).isNull();
            assertThat(dto.getInstanceStartDate()).isNull();
            assertThat(dto.getInstanceEndDate()).isNull();

            verify(courseInstanceRepository).findAllByIsActiveTrue();
        }


        @Test
        @DisplayName("Should handle course instances with null courses gracefully")
        void shouldHandleCourseInstancesWithNullCourses() {
            CourseInstance instanceWithNullCourse = CourseInstance.builder()
                    .id(2)
                    .course(null)
                    .isActive(true)
                    .build();

            when(courseInstanceRepository.findAllByIsActiveTrue())
                    .thenReturn(List.of(instanceWithNullCourse));

            List<CourseDto> result = courseService.getAvailableCoursesForOrganization(testUser);

            assertThat(result).isEmpty();

            verify(courseInstanceRepository).findAllByIsActiveTrue();
        }

        @Nested
        @DisplayName("Private Method Tests (toDto and toCategoryDto)")
        class PrivateMethodTests {

            @Test
            @DisplayName("Should test toDto method through getAllCourses")
            void shouldTestToDtoMethodThroughGetAllCourses() {
                Course courseWithAllFields = Course.builder()
                        .id(1)
                        .title("Complete Course")
                        .code("COMPLETE")
                        .description("A complete course")
                        .durationHours(50)
                        .category(testCategory)
                        .build();

                when(courseRepository.findAll()).thenReturn(Arrays.asList(courseWithAllFields));

                List<CourseDto> result = courseService.getAllCourses();

                assertThat(result).hasSize(1);
                CourseDto dto = result.get(0);
                assertThat(dto.getId()).isEqualTo(1);
                assertThat(dto.getTitle()).isEqualTo("Complete Course");
                assertThat(dto.getCode()).isEqualTo("COMPLETE");
                assertThat(dto.getDescription()).isEqualTo("A complete course");
                assertThat(dto.getDuration()).isEqualTo(50);
                assertThat(dto.getCategory().getId()).isEqualTo(1);
                assertThat(dto.getCategory().getName()).isEqualTo("Программирование");
            }

            @Test
            @DisplayName("Should test toCategoryDto method through getAllCourses")
            void shouldTestToCategoryDtoMethodThroughGetAllCourses() {
                CourseCategory categoryWithDescription = CourseCategory.builder()
                        .id(2)
                        .name("Advanced Programming")
                        .description("Advanced programming concepts")
                        .build();

                Course course = Course.builder()
                        .id(1)
                        .title("Test Course")
                        .code("TEST")
                        .description("Test")
                        .durationHours(30)
                        .category(categoryWithDescription)
                        .build();

                when(courseRepository.findAll()).thenReturn(Arrays.asList(course));

                List<CourseDto> result = courseService.getAllCourses();

                assertThat(result).hasSize(1);
                CourseCategoryDto categoryDto = result.get(0).getCategory();
                assertThat(categoryDto.getId()).isEqualTo(2);
                assertThat(categoryDto.getName()).isEqualTo("Advanced Programming");
            }
        }

        @Nested
        @DisplayName("convertToDto Tests")
        class ConvertToDtoTests {

            @Test
            @DisplayName("Should convert course entity to full DTO")
            void shouldConvertCourseEntityToFullDto() {
                when(categoryAdminService.convertToDto(testCategory)).thenReturn(testCategoryDto);

                CourseDto result = courseService.convertToDto(testCourse);

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

                verify(categoryAdminService).convertToDto(testCategory);
            }

            @Test
            @DisplayName("Should handle course with null boolean fields")
            void shouldHandleCourseWithNullBooleanFields() {
                Course courseWithNullBooleans = Course.builder()
                        .id(1)
                        .title("Test Course")
                        .code("TEST")
                        .description("Test")
                        .durationHours(30)
                        .isIndividual(null)
                        .isActive(null)
                        .category(testCategory)
                        .createdAt(LocalDateTime.now())
                        .updatedAt(LocalDateTime.now())
                        .build();

                when(categoryAdminService.convertToDto(testCategory)).thenReturn(testCategoryDto);

                CourseDto result = courseService.convertToDto(courseWithNullBooleans);

                assertThat(result.getIndividual()).isNull();
                assertThat(result.getActive()).isNull();
            }
        }

        @Nested
        @DisplayName("Integration Tests")
        class IntegrationTests {

            @Test
            @DisplayName("Should work together with all dependencies")
            void shouldWorkTogetherWithAllDependencies() {
                testCourse.setCategory(testCategory);
                testCourse.setCreatedAt(LocalDateTime.now().minusDays(5));
                testCourse.setUpdatedAt(LocalDateTime.now().minusDays(1));
                testCourse.setIsActive(true);
                testCourse.setIsIndividual(false);

                testCourseInstance.setCourse(testCourse);
                testCourseInstance.setStartDate(LocalDateTime.now().plusDays(2));
                testCourseInstance.setEndDate(LocalDateTime.now().plusDays(20));
                testCourseInstance.setTitle("Test Group");

                when(courseRepository.findAll()).thenReturn(List.of(testCourse));
                when(courseRepository.findById(1)).thenReturn(Optional.of(testCourse));
                when(categoryService.getAllCategories()).thenReturn(List.of(testCategoryDto));
                when(categoryAdminService.convertToDto(testCategory)).thenReturn(testCategoryDto);
                when(courseInstanceRepository.findAllByIsActiveTrue()).thenReturn(List.of(testCourseInstance));

                List<CourseDto> allCourses = courseService.getAllCourses();
                CourseDto courseById = courseService.getById(1);
                List<CourseCategoryDto> categories = courseService.getCategories();
                Course courseEntity = courseService.getCourseById(1);
                List<CourseDto> availableCourses = courseService.getAvailableCoursesForOrganization(testUser);

                assertThat(allCourses).hasSize(1);
                assertThat(courseById.getId()).isEqualTo(1);
                assertThat(categories).hasSize(1);
                assertThat(courseEntity.getId()).isEqualTo(1);
                assertThat(availableCourses).hasSize(1);

                CourseDto dto = availableCourses.get(0);
                assertThat(dto.getInstanceTitle()).isNull();
                assertThat(dto.getInstanceStartDate()).isNull();
                assertThat(dto.getInstanceEndDate()).isNull();

                verify(courseRepository).findAll();
                verify(courseRepository, times(2)).findById(1);
                verify(categoryService).getAllCategories();
                verify(categoryAdminService).convertToDto(testCategory);
                verify(courseInstanceRepository).findAllByIsActiveTrue();
            }
        }


        @Test
        @DisplayName("Should handle error scenarios gracefully")
        void shouldHandleErrorScenariosGracefully() {
            when(courseRepository.findById(999)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> courseService.getById(999))
                    .isInstanceOf(EntityNotFoundException.class);

            assertThatThrownBy(() -> courseService.getCourseById(999))
                    .isInstanceOf(CourseNotFoundException.class);
        }
    }
}

