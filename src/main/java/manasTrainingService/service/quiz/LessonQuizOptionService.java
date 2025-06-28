package manasTrainingService.service.quiz;

import manasTrainingService.dto.quiz.LessonQuizOptionDto;
import manasTrainingService.entity.LessonQuizOption;
import manasTrainingService.entity.LessonQuizQuestion;

import java.util.List;

public interface LessonQuizOptionService {
    void saveQuizOptions(List<LessonQuizOptionDto> options, LessonQuizQuestion lessonQuizQuestion, Integer correctOptionIndex);

    void editQuizOptions(List<LessonQuizOptionDto> options, Integer correctOptionIndex);

    List<LessonQuizOptionDto> getQuizOptionsByQuestionId(int questionId);

    LessonQuizOption getQuizOptionEntityById(int id);
}
