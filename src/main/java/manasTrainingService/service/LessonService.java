package manasTrainingService.service;

import manasTrainingService.dto.instance.LessonCreateRequest;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;

import java.util.List;

public interface LessonService {


    Integer createLesson(LessonCreateRequest request, CourseModule module);

    List<Lesson> getLessonsByModuleId(Integer moduleId);

    int getMinutesLeft(CourseModule module);
}
