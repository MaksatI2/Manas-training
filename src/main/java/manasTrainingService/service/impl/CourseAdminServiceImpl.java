package manasTrainingService.service.impl;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.ValidationException;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.create.CreateCourseDto;
import manasTrainingService.dto.edit.CourseEditDto;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseCategory;
import manasTrainingService.repositories.CourseRepository;
import manasTrainingService.service.CourseAdminService;
import manasTrainingService.service.CourseCategoryService;
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
        updateCourseDto.setIndividual(individual);

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
            throw new ValidationException("Курс с кодом '" + createCourseDto.getCode() + "' уже существует");
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
                .isIndividual(Boolean.TRUE.equals(createCourseDto.getIndividual()))
                .isActive(Boolean.TRUE.equals(createCourseDto.getActive()))
                .category(category)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        Course savedCourse = courseRepository.save(course);
        return convertToDto(savedCourse);
    }

    @Transactional
    @Override
    public CourseDto update(CourseEditDto updateCourseDto) {
        Course existingCourse = courseRepository.findById(updateCourseDto.getId())
                .orElseThrow(() -> new EntityNotFoundException("Курс с ID " + updateCourseDto.getId() + " не найден"));

        if (existsByCodeAndIdNot(updateCourseDto.getCode(), updateCourseDto.getId())) {
            throw new ValidationException("Курс с кодом '" + updateCourseDto.getCode() + "' уже существует");
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
        existingCourse.setIsIndividual(Boolean.TRUE.equals(updateCourseDto.getIndividual()));
        existingCourse.setIsActive(Boolean.TRUE.equals(updateCourseDto.getActive()));
        existingCourse.setCategory(category);
        existingCourse.setUpdatedAt(LocalDateTime.now());

        Course updatedCourse = courseRepository.save(existingCourse);
        return convertToDto(updatedCourse);
    }

    @Transactional
    @Override
    public void delete(Integer id) {
        if (!courseRepository.existsById(id)) {
            throw new EntityNotFoundException("Курс с ID " + id + " не найден");
        }
        courseRepository.deleteById(id);
    }

    @Override
    public boolean existsByCode(String code) {
        return courseRepository.existsByCode(code);
    }

    @Override
    public boolean existsByCodeAndIdNot(String code, Integer id) {
        return courseRepository.existsByCodeAndIdNot(code, id);
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
                .individual(dto.getIndividual())
                .active(dto.getActive())
                .categoryId(dto.getCategoryId())
                .build();
    }

}