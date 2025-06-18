package manasTrainingService.service;

import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.entity.Course;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface CourseService {

    List<CourseDto> getAllCourses();

    CourseDto getById(Integer id);

    List<CourseCategoryDto> getCategories();

    Course getCourseById(Integer id);
}