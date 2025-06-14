package manasTrainingService.service;

import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.create.CreateCourseDto;
import manasTrainingService.dto.edit.CourseEditDto;

import java.util.List;

public interface CourseAdminService {

    CourseEditDto prepareEditDtoWithRequestParams(CourseEditDto updateCourseDto, String[] activeValues, String[] individualValues);
    CourseEditDto convertToEditDto(CourseDto dto);

    List<CourseDto> getAllCourses();

    CourseDto getById(Integer id);
    CourseDto create(CreateCourseDto createCourseDto);
    CourseDto update(CourseEditDto updateCourseDto);

    void delete(Integer id);

    boolean existsByCode(String code);
    boolean existsByCodeAndIdNot(String code, Integer id);
}