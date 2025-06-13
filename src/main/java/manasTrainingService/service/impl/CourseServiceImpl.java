package manasTrainingService.service.impl;

import jakarta.persistence.EntityNotFoundException;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseCategory;
import manasTrainingService.repositories.CourseCategoryRepository;
import manasTrainingService.repositories.CourseRepository;
import manasTrainingService.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CourseServiceImpl implements CourseService {

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private CourseCategoryRepository categoryRepository;

    @Override
    public List<CourseDto> getAllCourses() {
        return courseRepository.findAll().stream().map(this::toDto).toList();
    }

    @Override
    public CourseDto getCourseById(Integer id) {
        Course course = courseRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Course not found with id: " + id));
        return toDto(course);
    }

    @Override
    public List<CourseCategoryDto> getCategories() {
        return categoryRepository.findAll().stream().map(this::toCategoryDto).toList();
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
}