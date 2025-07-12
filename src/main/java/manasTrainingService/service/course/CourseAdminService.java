package manasTrainingService.service.course;

import manasTrainingService.dto.CourseDeletionDependenciesDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.create.CreateCourseDto;
import manasTrainingService.dto.edit.CourseEditDto;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface CourseAdminService {

    CourseEditDto prepareEditDtoWithRequestParams(CourseEditDto updateCourseDto, String[] activeValues, String[] individualValues);

    @Transactional(readOnly = true)
    CourseDeletionDependenciesDto getDeletionDependencies(Integer courseId);

    @Transactional
    void deleteCourse(Integer courseId);

    CourseEditDto convertToEditDto(CourseDto dto);

    List<CourseDto> getAllCourses();

    CourseDto getById(Integer id);
    CourseDto create(CreateCourseDto createCourseDto);
    CourseDto update(CourseEditDto updateCourseDto);

    boolean existsByCode(String code);
    boolean existsByCodeAndIdNot(String code, Integer id);
}