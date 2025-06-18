package manasTrainingService.service;

import manasTrainingService.dto.instance.CourseModuleCreationDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.CoursePlanDTO;
import manasTrainingService.entity.CourseModule;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface CourseModuleService {

//    void createCourseModules(CoursePlanDTO planDTO);

    @Transactional
    void createCourseModules(Integer courseInstanceId, List<CourseModuleCreationDTO> dtos);

    List<CourseModule> getModulesByCourseInstanceId(Integer courseInstanceId);


    CourseModule getCourseModuleById(Integer moduleId);

    @Transactional(readOnly = true)
    List<CourseModuleDTO> findByCourseInstanceId(Integer courseInstanceId);
}
