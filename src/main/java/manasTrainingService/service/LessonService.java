package manasTrainingService.service;

import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;

import java.util.List;

public interface LessonService {

    Lesson createLesson(LessonDTO dto, CourseModule module);

    List<Lesson> getLessonsByModuleId(Integer moduleId);
}
