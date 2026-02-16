package manasTrainingService.service;

import manasTrainingService.dto.instance.LessonCreateRequest;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.dto.lesson.LessonEditDto;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;


public interface LessonService {

    Integer createLesson(LessonCreateRequest request, CourseModule module);

    LessonDTO getLessonById(Integer lessonId);

    Lesson getLessonModelById(Integer lessonId);


    void deleteById(Integer lessonId);

    LessonEditDto getLessonEditDto(Integer id);

    void updateLesson(Integer id, LessonEditDto dto);
}
