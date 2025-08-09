package manasTrainingService.service.impl.course;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.ValidationException;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.CourseCategory;
import manasTrainingService.entity.TargetType;
import manasTrainingService.repositories.course.CourseCategoryRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.course.CourseCategoryService;
import manasTrainingService.service.user.UserService;
import org.apache.coyote.BadRequestException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CourseCategoryServiceImpl implements CourseCategoryService {

    private final CourseCategoryRepository categoryRepository;
    private final ActivityLogService activityLogService;
    private final UserService userService;

    @Override
    public List<CourseCategoryDto> getAllCategories() {
        return categoryRepository.findAll()
                .stream()
                .map(this::convertToDto)
                .toList();
    }

    @Override
    public CourseCategoryDto getById(Integer id) {
        CourseCategory category = getCategoryById(id);
        return convertToDto(category);
    }

    @Override
    public List<CourseCategoryDto> getAll(String search) {
        List<CourseCategory> categories = (search == null || search.isEmpty())
                ? categoryRepository.findAll()
                : categoryRepository.findByNameContainingIgnoreCase(search);
        return categories.stream()
                .map(category -> CourseCategoryDto.builder()
                        .id(category.getId())
                        .name(category.getName())
                        .build())
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void create(CourseCategoryDto dto) {
        validateCategory(dto);
        CourseCategory category = convertToEntity(dto);
        CourseCategory saved = categoryRepository.save(category);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.CREATE,
                TargetType.COURSE_CATEGORY,
                saved.getId()
        );
    }


    @Override
    @Transactional
    public void update(Integer id, CourseCategoryDto dto) {
        CourseCategory category = getCategoryById(id);
        validateCategory(dto);
        category.setName(dto.getName());
        category.setDescription(dto.getDescription());
        CourseCategory updated = categoryRepository.save(category);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.COURSE_CATEGORY,
                updated.getId()
        );
    }

    @Override
    @Transactional
    public void delete(Integer id) {
        if (!categoryRepository.existsById(id)) {
            throw new EntityNotFoundException("Категория с ID " + id + " не найдена");
        }

        CourseCategory category = getCategoryById(id);
        if (!category.getCourses().isEmpty()) {
            throw new IllegalStateException("У категории есть курсы. Удаление невозможно");
        }

        categoryRepository.deleteById(id);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.DELETE,
                TargetType.COURSE_CATEGORY,
                id
        );
    }

    @Override
    public CourseCategoryDto convertToDto(CourseCategory category) {
        return CourseCategoryDto.builder()
                .id(category.getId())
                .name(category.getName())
                .description(category.getDescription())
                .build();
    }

    private CourseCategory convertToEntity(CourseCategoryDto dto) {
        return CourseCategory.builder()
                .id(dto.getId())
                .name(dto.getName())
                .description(dto.getDescription())
                .build();
    }

    @Override
    public CourseCategory getCategoryById(Integer id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Категория с ID " + id + " не найдена"));
    }


    private void validateCategory(CourseCategoryDto dto) {
        if (categoryRepository.existsByName(dto.getName())) {
            throw new ValidationException("Категория с именем " + dto.getName() + " уже существует");
        }
    }
}