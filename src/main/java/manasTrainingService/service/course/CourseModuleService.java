package manasTrainingService.service.course;

import manasTrainingService.dto.instance.CourseModuleApiDto;
import manasTrainingService.dto.instance.CourseModuleCreationDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.CourseModuleUpdateDTO;
import manasTrainingService.entity.CourseModule;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface CourseModuleService {

    @Transactional
    void createCourseModules(Integer courseInstanceId, List<CourseModuleCreationDTO> dtos);

    CourseModule getCourseModuleById(Integer moduleId);

    List<CourseModuleApiDto> getModuleApiDtosByCourseInstanceId(Integer courseInstanceId);

    void deleteByIdIfNoLessons(Integer moduleId);

    CourseModuleUpdateDTO getModuleForUpdate(Integer moduleId);

    void updateModule(Integer moduleId, CourseModuleUpdateDTO dto);

    CourseModuleDTO getCourseModuleDTOById(Integer moduleId);
}
