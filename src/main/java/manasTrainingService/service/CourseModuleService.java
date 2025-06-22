package manasTrainingService.service;

import manasTrainingService.dto.instance.CourseModuleApiDto;
import manasTrainingService.dto.instance.CourseModuleCreationDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.CourseModuleUpdateDTO;
import manasTrainingService.dto.instance.CoursePlanDTO;
import manasTrainingService.entity.CourseModule;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface CourseModuleService {

    @Transactional
    void createCourseModules(Integer courseInstanceId, List<CourseModuleCreationDTO> dtos);

    CourseModule getCourseModuleById(Integer moduleId);

}
