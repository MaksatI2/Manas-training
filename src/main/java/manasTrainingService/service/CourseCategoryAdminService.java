package manasTrainingService.service;

import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.entity.CourseCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface CourseCategoryAdminService {
    Page<CourseCategoryDto> getPage(String search, Pageable pageable);
    CourseCategoryDto getById(Integer id);
    List<CourseCategoryDto> getAll(String search);
    void create(CourseCategoryDto dto);
    void update(Integer id, CourseCategoryDto dto);
    void delete(Integer id);
    CourseCategoryDto convertToDto(CourseCategory category);
    CourseCategory convertToEntity(CourseCategoryDto dto);
    CourseCategory getCategoryById(Integer id);
    boolean existsById(Integer id);
}