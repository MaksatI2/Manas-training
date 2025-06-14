package manasTrainingService.service;

import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.entity.CourseCategory;

import java.util.List;

public interface CourseCategoryService {
    List<CourseCategoryDto> getAllCategories();
    List<CourseCategoryDto> getAll(String search);

    void create(CourseCategoryDto dto);
    void update(Integer id, CourseCategoryDto dto);
    void delete(Integer id);

    CourseCategoryDto getById(Integer id);
    CourseCategoryDto convertToDto(CourseCategory category);
    CourseCategory getCategoryById(Integer id);
}