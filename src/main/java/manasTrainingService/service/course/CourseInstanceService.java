package manasTrainingService.service.course;

import manasTrainingService.dto.CourseInstanceCreationDTO;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.instance.CourseInstanceUpdateDTO;
import manasTrainingService.entity.CourseInstance;

import java.util.List;

public interface CourseInstanceService {
    Integer createCourseInstance(CourseInstanceCreationDTO dto);

    List<CourseInstanceDTO> findAll();

    CourseInstanceDTO getCourseInstanceById(Integer id);

    CourseInstance getCourseInstanceModelById(Integer id);

    CourseInstanceDTO getCourseInstanceByLessonId(Integer lessonId);

    CourseInstanceUpdateDTO getUpdateDtoById(Integer id);

    void updateCourseInstance(Integer id, CourseInstanceUpdateDTO dto);

    void deleteCourseInstance(Integer id);
}
