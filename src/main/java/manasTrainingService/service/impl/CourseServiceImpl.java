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
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CourseServiceImpl implements CourseService {

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private CourseCategoryRepository categoryRepository;

    @Override
    public Page<CourseDto> getCourses(Pageable pageable, Integer categoryId, String search) {
        if (categoryId != null && !categoryRepository.existsById(categoryId)) {
            throw new EntityNotFoundException("Category with ID " + categoryId + " not found");
        }
        if (search != null && !search.trim().isEmpty()) {
            return courseRepository.findByTitleContainingIgnoreCaseOrCodeContainingIgnoreCaseAndCategoryId(
                    search, search, categoryId, pageable).map(this::toDto);
        }
        if (categoryId != null) {
            return courseRepository.findByCategoryId(categoryId, pageable).map(this::toDto);
        }
        return courseRepository.findAll(pageable).map(this::toDto);
    }

    @Override
    public CourseDto getCourseById(Integer id) {
        Course course = courseRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Course with ID " + id + " not found"));
        return toDto(course);
    }

    @Override
    public List<CourseCategoryDto> getCategories() {
        return categoryRepository.findAll().stream()
                .map(this::toCategoryDto)
                .collect(Collectors.toList());
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