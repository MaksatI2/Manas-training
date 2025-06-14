package manasTrainingService.service;

import manasTrainingService.dto.CourseDto;
import manasTrainingService.entity.Course;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface CourseAdminService {
    Page<CourseDto> getCourses(Pageable pageable, Integer categoryId, String search, Boolean isActive, Boolean isIndividual);
    CourseDto getById(Integer id);
    void create(CourseDto dto);
    void update(Integer id, CourseDto dto);
    void delete(Integer id);
    CourseDto convertToDto(Course course);
    Course convertToEntity(CourseDto dto);
}