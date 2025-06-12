package manasTrainingService.service;

import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface CourseService {
    Page<CourseDto> getCourses(Pageable pageable, Integer categoryId, String search);

    CourseDto getCourseById(Integer id);

    List<CourseCategoryDto> getCategories();
}