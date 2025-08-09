package manasTrainingService.service.impl.course;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.ValidationException;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDeletionDependenciesDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.ShortDto;
import manasTrainingService.dto.create.CreateCourseDto;
import manasTrainingService.dto.edit.CourseEditDto;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseCategory;
import manasTrainingService.exceptions.nsee.course.CourseDeletionException;
import manasTrainingService.entity.TargetType;
import manasTrainingService.repositories.course.CourseRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.CourseApplicationService;
import manasTrainingService.service.course.CourseAdminService;
import manasTrainingService.service.course.CourseCategoryService;
import manasTrainingService.service.user.UserService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseTeacherService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CourseAdminServiceImpl implements CourseAdminService {

    private final CourseRepository courseRepository;
    private final CourseCategoryService categoryService;
    private final CourseApplicationService courseApplicationService;
    private final CourseTeacherService courseTeacherService;
    private final CourseInstanceService courseInstanceService;

    private final ActivityLogService activityLogService;
    private final UserService userService;
    @Override
    public CourseEditDto prepareEditDtoWithRequestParams(CourseEditDto updateCourseDto, String[] activeValues, String[] individualValues) {
        Boolean active = false;
        Boolean individual = false;

        if (activeValues != null) {
            for (String value : activeValues) {
                if ("true".equals(value)) {
                    active = true;
                    break;
                }
            }
        }

        if (individualValues != null) {
            for (String value : individualValues) {
                if ("true".equals(value)) {
                    individual = true;
                    break;
                }
            }
        }

        updateCourseDto.setActive(active);

        return updateCourseDto;
    }

    @Override
    public List<CourseDto> getAllCourses() {
        return courseRepository.findAll().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Override
    public CourseDto getById(Integer id) {
        Course course = courseRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Курс с ID " + id + " не найден"));
        return convertToDto(course);
    }

    @Transactional
    @Override
    public CourseDto create(CreateCourseDto createCourseDto) {
        if (existsByCode(createCourseDto.getCode())) {
            throw new ValidationException("Курс с кодом " + createCourseDto.getCode() + " уже существует");
        }
        if (existsByTitle(createCourseDto.getTitle())) {
            throw new ValidationException("Курс с названием " + createCourseDto.getTitle() + " уже существует");
        }

        CourseCategoryDto categoryDto = categoryService.getById(createCourseDto.getCategoryId());
        CourseCategory category = CourseCategory.builder()
                .id(categoryDto.getId())
                .name(categoryDto.getName())
                .description(categoryDto.getDescription())
                .build();

        Course course = Course.builder()
                .title(createCourseDto.getTitle())
                .code(createCourseDto.getCode())
                .description(createCourseDto.getDescription())
                .durationHours(createCourseDto.getDuration())
                .isActive(Boolean.TRUE.equals(createCourseDto.getActive()))
                .category(category)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        Course savedCourse = courseRepository.save(course);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.CREATE,
                TargetType.COURSE,
                savedCourse.getId()
        );
        return convertToDto(savedCourse);
    }

    @Transactional
    @Override
    public CourseDto update(CourseEditDto updateCourseDto) {
        Course existingCourse = courseRepository.findById(updateCourseDto.getId())
                .orElseThrow(() -> new EntityNotFoundException("Курс с ID " + updateCourseDto.getId() + " не найден"));

        if (existsByCodeAndIdNot(updateCourseDto.getCode(), updateCourseDto.getId())) {
            throw new ValidationException("Курс с кодом " + updateCourseDto.getCode() + " уже существует");
        }
        if (existsByTitleAndIdNot(updateCourseDto.getTitle(), updateCourseDto.getId())) {
            throw new ValidationException("Курс с названием " + updateCourseDto.getTitle() + " уже существует");
        }


        CourseCategoryDto categoryDto = categoryService.getById(updateCourseDto.getCategoryId());
        CourseCategory category = CourseCategory.builder()
                .id(categoryDto.getId())
                .name(categoryDto.getName())
                .description(categoryDto.getDescription())
                .build();

        existingCourse.setTitle(updateCourseDto.getTitle());
        existingCourse.setCode(updateCourseDto.getCode());
        existingCourse.setDescription(updateCourseDto.getDescription());
        existingCourse.setDurationHours(updateCourseDto.getDuration());
        existingCourse.setIsActive(Boolean.TRUE.equals(updateCourseDto.getActive()));
        existingCourse.setCategory(category);
        existingCourse.setUpdatedAt(LocalDateTime.now());

        Course updatedCourse = courseRepository.save(existingCourse);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.COURSE,
                updatedCourse.getId()
        );
        return convertToDto(updatedCourse);
    }

    @Override
    public boolean existsByCode(String code) {
        return courseRepository.existsByCode(code);
    }

    @Override
    public boolean existsByCodeAndIdNot(String code, Integer id) {
        return courseRepository.existsByCodeAndIdNot(code, id);
    }


    @Transactional(readOnly = true)
    @Override
    public CourseDeletionDependenciesDto getDeletionDependencies(Integer courseId) {
        if (!courseRepository.existsById(courseId))
            throw new EntityNotFoundException("Курс с id=" + courseId + " не найден");

        List<ShortDto> applications = courseApplicationService.getByCourseId(courseId);
        List<ShortDto> instances = courseInstanceService.getByCourseId(courseId);
        List<ShortDto> teachers = courseTeacherService.getByCourseId(courseId);

        return new CourseDeletionDependenciesDto(applications, instances, teachers);
    }

    @Transactional
    @Override
    public void deleteCourse(Integer courseId) {
        if (!courseRepository.existsById(courseId))
            throw new EntityNotFoundException("Курс с id=" + courseId + " не найден");

        var deps = getDeletionDependencies(courseId);
        if (deps.hasAny())
            throw new CourseDeletionException("Невозможно удалить курс: найдены связанные элементы");

        courseRepository.deleteById(courseId);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.DELETE,
                TargetType.COURSE,
                courseId
        );
    }


    public CourseDto convertToDto(Course course) {
        CourseCategoryDto categoryDto = categoryService.convertToDto(course.getCategory());
        return CourseDto.builder()
                .id(course.getId())
                .title(course.getTitle())
                .code(course.getCode())
                .description(course.getDescription())
                .duration(course.getDurationHours())
                .individual(course.getIsIndividual())
                .active(course.getIsActive())
                .createdAt(course.getCreatedAt())
                .updatedAt(course.getUpdatedAt())
                .category(categoryDto)
                .categoryId(course.getCategory().getId())
                .build();
    }

    @Override
    public CourseEditDto convertToEditDto(CourseDto dto) {
        return CourseEditDto.builder()
                .id(dto.getId())
                .title(dto.getTitle())
                .code(dto.getCode())
                .description(dto.getDescription())
                .duration(dto.getDuration())
                .active(dto.getActive())
                .categoryId(dto.getCategoryId())
                .build();
    }

    @Override
    public boolean existsByTitle(String title) {
        return courseRepository.existsByTitle(title);
    }

    @Override
    public boolean existsByTitleAndIdNot(String title, Integer id) {
        return courseRepository.existsByTitleAndIdNot(title, id);
    }

}