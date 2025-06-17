package manasTrainingService.service;

import manasTrainingService.dto.instance.CoursePlanDTO;
import manasTrainingService.entity.CourseModule;

import java.util.List;

public interface CourseModuleService {

//    void createCourseModules(CoursePlanDTO planDTO);

    List<CourseModule> getModulesByCourseInstanceId(Integer courseInstanceId);


    CourseModule getCourseModuleById(Integer moduleId);
}
