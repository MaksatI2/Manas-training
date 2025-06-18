package manasTrainingService.service;

import manasTrainingService.dto.CourseInstanceCreationDTO;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.entity.CourseInstance;

import java.util.List;

public interface CourseInstanceService {
    Integer createCourseInstance(CourseInstanceCreationDTO dto);

    List<CourseInstanceDTO> findAll();

    CourseInstanceDTO getCourseInstanceById(Integer id);

    CourseInstance getCourseInstanceModelById(Integer id);

    CourseInstanceDTO getCourseInstanceByLessonId(Integer lessonId);
}
