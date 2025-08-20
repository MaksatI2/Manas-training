package manasTrainingService.service.course;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.ValidationException;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.entity.CourseCategory;
import manasTrainingService.repositories.course.CourseCategoryRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.impl.course.CourseCategoryServiceImpl;
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
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
@DisplayName("CourseCategoryService Tests")
class CourseCategoryServiceTest {

    @Mock
    private CourseCategoryRepository categoryRepository;
    @Mock
    private UserService userService;
    @Mock
    private ActivityLogService activityLogService;
    @Mock
    private MessageSource messageSource;

    @InjectMocks
    private CourseCategoryServiceImpl courseCategoryService;

    private CourseCategory testCategory;
    private CourseCategoryDto testCategoryDto;

    @BeforeEach
    void setUp() {
        testCategory = CourseCategory.builder()
                .id(1)
                .name("Java Programming")
                .description("Java programming course category")
                .build();

        testCategoryDto = CourseCategoryDto.builder()
                .id(1)
                .name("Java Programming")
                .description("Java programming course category")
                .build();
        when(messageSource.getMessage(
                eq("category.name.exists"),
                any(Object[].class),
                any(Locale.class)
        )).thenAnswer(invocation -> "Категория с таким именем уже существует");

        lenient().when(messageSource.getMessage(
                eq("category.not.found.withId"),
                eq(new Object[]{999}),
                any(Locale.class)
        )).thenReturn("Категория с ID 999 не найдена");
        lenient().when(messageSource.getMessage(
                eq("category.name.exists"),
                any(Object[].class),
                any(Locale.class)
        )).thenAnswer(invocation -> {
            Object[] args = invocation.getArgument(1);
            return "Категория с именем " + args[0] + " уже существует";
        });



    }

    @Nested
    @DisplayName("getAllCategories() Tests")
    class GetAllCategoriesTests {

        @Test
        @DisplayName("Should return all categories as DTOs when categories exist")
        void shouldReturnAllCategoriesAsDtos_WhenCategoriesExist() {
            CourseCategory category2 = CourseCategory.builder()
                    .id(2)
                    .name("Python Programming")
                    .description("Python programming course category")
                    .build();

            List<CourseCategory> categories = Arrays.asList(testCategory, category2);
            when(categoryRepository.findAll()).thenReturn(categories);

            List<CourseCategoryDto> result = courseCategoryService.getAllCategories();

            assertThat(result).hasSize(2);
            assertThat(result.get(0).getName()).isEqualTo("Java Programming");
            assertThat(result.get(1).getName()).isEqualTo("Python Programming");
            verify(categoryRepository).findAll();
        }

        @Test
        @DisplayName("Should return empty list when no categories exist")
        void shouldReturnEmptyList_WhenNoCategoriesExist() {
            when(categoryRepository.findAll()).thenReturn(Collections.emptyList());

            List<CourseCategoryDto> result = courseCategoryService.getAllCategories();

            assertThat(result).isEmpty();
            verify(categoryRepository).findAll();
        }
    }

    @Nested
    @DisplayName("getAll(String search) Tests")
    class GetAllWithSearchTests {

        @Test
        @DisplayName("Should return all categories when search is null")
        void shouldReturnAllCategories_WhenSearchIsNull() {
            when(categoryRepository.findAll()).thenReturn(Arrays.asList(testCategory));

            List<CourseCategoryDto> result = courseCategoryService.getAll(null);

            assertThat(result).hasSize(1);
            assertThat(result.get(0).getName()).isEqualTo("Java Programming");
            verify(categoryRepository).findAll();
            verify(categoryRepository, never()).findByNameContainingIgnoreCase(anyString());
        }

        @Test
        @DisplayName("Should return all categories when search is empty")
        void shouldReturnAllCategories_WhenSearchIsEmpty() {
            when(categoryRepository.findAll()).thenReturn(Arrays.asList(testCategory));

            List<CourseCategoryDto> result = courseCategoryService.getAll("");

            assertThat(result).hasSize(1);
            assertThat(result.get(0).getName()).isEqualTo("Java Programming");
            verify(categoryRepository).findAll();
            verify(categoryRepository, never()).findByNameContainingIgnoreCase(anyString());
        }

        @Test
        @DisplayName("Should return filtered categories when search is provided")
        void shouldReturnFilteredCategories_WhenSearchIsProvided() {
            String searchTerm = "Java";
            when(categoryRepository.findByNameContainingIgnoreCase(searchTerm))
                    .thenReturn(Arrays.asList(testCategory));

            List<CourseCategoryDto> result = courseCategoryService.getAll(searchTerm);

            assertThat(result).hasSize(1);
            assertThat(result.get(0).getName()).isEqualTo("Java Programming");
            verify(categoryRepository).findByNameContainingIgnoreCase(searchTerm);
            verify(categoryRepository, never()).findAll();
        }

        @Test
        @DisplayName("Should return empty list when no categories match search")
        void shouldReturnEmptyList_WhenNoCategoriesMatchSearch() {
            String searchTerm = "NonExistent";
            when(categoryRepository.findByNameContainingIgnoreCase(searchTerm))
                    .thenReturn(Collections.emptyList());

            List<CourseCategoryDto> result = courseCategoryService.getAll(searchTerm);

            assertThat(result).isEmpty();
            verify(categoryRepository).findByNameContainingIgnoreCase(searchTerm);
        }
    }

    @Nested
    @DisplayName("create(CourseCategoryDto) Tests")
    class CreateTests {

        @Test
        @DisplayName("Should create category successfully when valid data provided")
        void shouldCreateCategorySuccessfully_WhenValidDataProvided() {
            CourseCategoryDto newCategoryDto = CourseCategoryDto.builder()
                    .name("New Category")
                    .description("New category description")
                    .build();

            when(categoryRepository.existsByName(newCategoryDto.getName())).thenReturn(false);
            when(categoryRepository.save(any(CourseCategory.class))).thenReturn(testCategory);

            assertThatCode(() -> courseCategoryService.create(newCategoryDto))
                    .doesNotThrowAnyException();

            verify(categoryRepository).existsByName(newCategoryDto.getName());
            verify(categoryRepository).save(any(CourseCategory.class));
        }

        @Test
        @DisplayName("Should throw ValidationException when category name already exists")
        void shouldThrowValidationException_WhenCategoryNameAlreadyExists() {
            when(categoryRepository.existsByName(testCategoryDto.getName())).thenReturn(true);

            assertThatThrownBy(() -> courseCategoryService.create(testCategoryDto))
                    .isInstanceOf(ValidationException.class)
                    .hasMessageContaining(messageSource.getMessage(
                            "category.name.exists",
                            new Object[]{testCategoryDto.getName()},
                            LocaleContextHolder.getLocale()
                    ));

            verify(categoryRepository).existsByName(testCategoryDto.getName());
            verify(categoryRepository, never()).save(any(CourseCategory.class));
        }
    }

    @Nested
    @DisplayName("update(Integer id, CourseCategoryDto) Tests")
    class UpdateTests {

        @Test
        @DisplayName("Should update category successfully when valid data provided")
        void shouldUpdateCategorySuccessfully_WhenValidDataProvided() {
            Integer categoryId = 1;
            CourseCategoryDto updateDto = CourseCategoryDto.builder()
                    .name("Updated Category")
                    .description("Updated description")
                    .build();

            when(categoryRepository.findById(categoryId)).thenReturn(Optional.of(testCategory));
            when(categoryRepository.existsByName(updateDto.getName())).thenReturn(false);
            when(categoryRepository.save(any(CourseCategory.class))).thenReturn(testCategory);

            assertThatCode(() -> courseCategoryService.update(categoryId, updateDto))
                    .doesNotThrowAnyException();

            verify(categoryRepository).findById(categoryId);
            verify(categoryRepository).existsByName(updateDto.getName());
            verify(categoryRepository).save(testCategory);
            assertThat(testCategory.getName()).isEqualTo(updateDto.getName());
            assertThat(testCategory.getDescription()).isEqualTo(updateDto.getDescription());
        }

        @Test
        @DisplayName("Should throw EntityNotFoundException when category not found")
        void shouldThrowEntityNotFoundException_WhenCategoryNotFound() {
            Integer categoryId = 999;
            when(categoryRepository.findById(categoryId)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> courseCategoryService.update(categoryId, testCategoryDto))
                    .isInstanceOf(EntityNotFoundException.class)
                    .hasMessageContaining("Категория с ID 999 не найдена");


            verify(categoryRepository).findById(categoryId);
            verify(categoryRepository, never()).save(any(CourseCategory.class));
        }

        @Test
        @DisplayName("Should throw ValidationException when updated name already exists")
        void shouldThrowValidationException_WhenUpdatedNameAlreadyExists() {
            Integer categoryId = 1;
            CourseCategoryDto updateDto = CourseCategoryDto.builder()
                    .name("Existing Category")
                    .description("Updated description")
                    .build();

            when(categoryRepository.findById(categoryId)).thenReturn(Optional.of(testCategory));
            when(categoryRepository.existsByName(updateDto.getName())).thenReturn(true);

            assertThatThrownBy(() -> courseCategoryService.update(categoryId, updateDto))
                    .isInstanceOf(ValidationException.class)
                    .hasMessageContaining("Категория с именем " + updateDto.getName() + " уже существует");

            verify(categoryRepository).findById(categoryId);
            verify(categoryRepository).existsByName(updateDto.getName());
            verify(categoryRepository, never()).save(any(CourseCategory.class));
        }
    }


    @Nested
    @DisplayName("getById(Integer id) Tests")
    class GetByIdTests {

        @Test
        @DisplayName("Should return category DTO when category exists")
        void shouldReturnCategoryDto_WhenCategoryExists() {
            Integer categoryId = 1;
            when(categoryRepository.findById(categoryId)).thenReturn(Optional.of(testCategory));

            CourseCategoryDto result = courseCategoryService.getById(categoryId);

            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(testCategory.getId());
            assertThat(result.getName()).isEqualTo(testCategory.getName());
            assertThat(result.getDescription()).isEqualTo(testCategory.getDescription());
            verify(categoryRepository).findById(categoryId);
        }

    }

    @Nested
    @DisplayName("convertToDto(CourseCategory) Tests")
    class ConvertToDtoTests {

        @Test
        @DisplayName("Should convert CourseCategory to CourseCategoryDto correctly")
        void shouldConvertCourseCategoryToCategoryDto_Correctly() {
            CourseCategoryDto result = courseCategoryService.convertToDto(testCategory);

            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(testCategory.getId());
            assertThat(result.getName()).isEqualTo(testCategory.getName());
            assertThat(result.getDescription()).isEqualTo(testCategory.getDescription());
        }

        @Test
        @DisplayName("Should handle null values in CourseCategory fields")
        void shouldHandleNullValues_InCourseCategoryFields() {
            CourseCategory categoryWithNulls = CourseCategory.builder()
                    .id(1)
                    .name("Test Category")
                    .description(null)
                    .build();

            CourseCategoryDto result = courseCategoryService.convertToDto(categoryWithNulls);

            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(1);
            assertThat(result.getName()).isEqualTo("Test Category");
            assertThat(result.getDescription()).isNull();
        }
    }

    @Nested
    @DisplayName("getCategoryById(Integer id) Tests")
    class GetCategoryByIdTests {

        @Test
        @DisplayName("Should return CourseCategory entity when category exists")
        void shouldReturnCourseCategoryEntity_WhenCategoryExists() {
            Integer categoryId = 1;
            when(categoryRepository.findById(categoryId)).thenReturn(Optional.of(testCategory));

            CourseCategory result = courseCategoryService.getCategoryById(categoryId);

            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(testCategory.getId());
            assertThat(result.getName()).isEqualTo(testCategory.getName());
            assertThat(result.getDescription()).isEqualTo(testCategory.getDescription());
            verify(categoryRepository).findById(categoryId);
        }

    }

    @Nested
    @DisplayName("Edge Cases and Integration Tests")
    class EdgeCasesTests {

        @Test
        @DisplayName("Should handle category with empty description")
        void shouldHandleCategoryWithEmptyDescription() {
            CourseCategoryDto categoryWithEmptyDescription = CourseCategoryDto.builder()
                    .name("Test Category")
                    .description("")
                    .build();

            when(categoryRepository.existsByName(categoryWithEmptyDescription.getName())).thenReturn(false);
            when(categoryRepository.save(any(CourseCategory.class))).thenReturn(testCategory);

            assertThatCode(() -> courseCategoryService.create(categoryWithEmptyDescription))
                    .doesNotThrowAnyException();

            verify(categoryRepository).save(any(CourseCategory.class));
        }

        @Test
        @DisplayName("Should handle search with special characters")
        void shouldHandleSearchWithSpecialCharacters() {
            String searchWithSpecialChars = "Java@#$%";
            when(categoryRepository.findByNameContainingIgnoreCase(searchWithSpecialChars))
                    .thenReturn(Collections.emptyList());

            List<CourseCategoryDto> result = courseCategoryService.getAll(searchWithSpecialChars);

            assertThat(result).isEmpty();
            verify(categoryRepository).findByNameContainingIgnoreCase(searchWithSpecialChars);
        }

    }
}