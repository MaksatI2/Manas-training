package manasTrainingService.service.impl;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.ValidationException;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseCategory;
import manasTrainingService.repositories.CourseRepository;
import manasTrainingService.service.CourseAdminService;
import manasTrainingService.service.CourseCategoryAdminService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CourseAdminServiceImpl implements CourseAdminService {

    private final CourseRepository courseRepository;
    private final CourseCategoryAdminService categoryAdminService;

    @Override
    public Page<CourseDto> getCourses(Pageable pageable, Integer categoryId, String search, Boolean isActive, Boolean isIndividual) {
        return courseRepository.findCourses(categoryId, search, isActive, isIndividual, pageable)
                .map(this::convertToDto);
    }

    @Override
    public CourseDto getById(Integer id) {
        Course course = courseRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Курс с ID " + id + " не найден"));
        return convertToDto(course);
    }

    @Override
    @Transactional
    public void create(CourseDto dto) {
        validateCourse(dto);
        Course course = convertToEntity(dto);
        courseRepository.save(course);
    }

    @Override
    @Transactional
    public void update(Integer id, CourseDto dto) {
        Course course = courseRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Курс с ID " + id + " не найден"));
        validateCourse(dto);
        updateCourseFromDto(course, dto);
        courseRepository.save(course);
    }

    @Override
    @Transactional
    public void delete(Integer id) {
        if (!courseRepository.existsById(id)) {
            throw new EntityNotFoundException("Курс с ID " + id + " не найден");
        }
        courseRepository.deleteById(id);
    }

    @Override
    public CourseDto convertToDto(Course course) {
        CourseCategoryDto categoryDto = categoryAdminService.convertToDto(course.getCategory());
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
    public Course convertToEntity(CourseDto dto) {
        CourseCategory category = categoryAdminService.getCategoryById(dto.getCategoryId());
        return Course.builder()
                .id(dto.getId())
                .title(dto.getTitle())
                .code(dto.getCode())
                .description(dto.getDescription())
                .durationHours(dto.getDuration())
                .isIndividual(dto.getIndividual() != null ? dto.getIndividual() : false)
                .isActive(dto.getActive() != null ? dto.getActive() : true)
                .category(category)
                .build();
    }

    private void validateCourse(CourseDto dto) {
        if (courseRepository.existsByCode(dto.getCode())) {
            throw new ValidationException("Курс с кодом " + dto.getCode() + " уже существует");
        }
        if (dto.getCategoryId() == null) {
            throw new ValidationException("Категория обязательна для курса");
        }
        if (!categoryAdminService.existsById(dto.getCategoryId())) {
            throw new EntityNotFoundException("Категория с ID " + dto.getCategoryId() + " не найдена");
        }
    }

    private void updateCourseFromDto(Course course, CourseDto dto) {
        course.setTitle(dto.getTitle());
        course.setCode(dto.getCode());
        course.setDescription(dto.getDescription());
        course.setDurationHours(dto.getDuration());
        course.setIsIndividual(dto.getIndividual() != null ? dto.getIndividual() : false);
        course.setIsActive(dto.getActive() != null ? dto.getActive() : true);
        course.setCategory(categoryAdminService.getCategoryById(dto.getCategoryId()));
        course.setUpdatedAt(LocalDateTime.now());
    }
}