package manasTrainingService.service.impl;

import jakarta.persistence.EntityNotFoundException;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseCategory;
import manasTrainingService.repositories.CourseRepository;
import manasTrainingService.service.CourseCategoryService;
import manasTrainingService.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import manasTrainingService.exceptions.nsee.CourseNotFoundException;

import java.util.List;

@Service
public class CourseServiceImpl implements CourseService {

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private CourseCategoryService categoryService;

    @Autowired
    private CourseCategoryService categoryAdminService;

    @Override
    public List<CourseDto> getAllCourses() {
        return courseRepository.findAll().stream().map(this::toDto).toList();
    }

    @Override
    public CourseDto getById(Integer id) {
        Course course = courseRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Курс с ID " + id + " не найден"));
        return convertToDto(course);
    }

    @Override
    public List<CourseCategoryDto> getCategories() {
        return categoryService.getAllCategories();
    }

    private CourseDto toDto(Course course) {
        CourseDto dto = new CourseDto();
        dto.setId(course.getId());
        dto.setTitle(course.getTitle());
        dto.setCode(course.getCode());
        dto.setDescription(course.getDescription());
        dto.setDuration(course.getDurationHours());
        dto.setCategory(toCategoryDto(course.getCategory()));
        return dto;
    }

    private CourseCategoryDto toCategoryDto(CourseCategory category) {
        CourseCategoryDto dto = new CourseCategoryDto();
        dto.setId(category.getId());
        dto.setName(category.getName());
        return dto;
    }

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
    public Course getCourseById(Integer id) {
        return courseRepository.findById(id).orElseThrow(() -> new CourseNotFoundException("Курс не был найден"));
    }
}