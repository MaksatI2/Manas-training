package manasTrainingService.service.quiz;

import manasTrainingService.dto.quiz.LessonQuizQuestionDto;
import manasTrainingService.entity.LessonQuiz;
import manasTrainingService.entity.LessonQuizQuestion;

import java.util.List;

public interface LessonQuizQuestionService {
    void saveQuizQuestions(List<LessonQuizQuestionDto> questions, LessonQuiz lessonQuiz);

    void editQuizQuestion(List<LessonQuizQuestionDto> questions, LessonQuiz quiz);

    List<LessonQuizQuestionDto> getQuizQuestionsByQuizId(int quizId);

    LessonQuizQuestion getQuizQuestinEntityById(int id);
}
