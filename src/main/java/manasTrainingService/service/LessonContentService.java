package manasTrainingService.service;

import manasTrainingService.dto.lesson.LessonContentDTO;
import manasTrainingService.entity.Lesson;

import java.util.Optional;

public interface LessonContentService {

    Optional<LessonContentDTO> getContentByLessonId(Integer lessonId);

    void saveOrUpdateContent(Lesson lesson, LessonContentDTO contentDTO);
}
