package manasTrainingService.service.quiz;

import manasTrainingService.dto.quiz.LessonQuizDto;
import manasTrainingService.dto.quiz.answers.QuizAnswerDto;
import manasTrainingService.dto.quiz.answers.QuizResultDto;
import manasTrainingService.entity.LessonQuiz;

public interface LessonQuizService {
    void createQuiz(LessonQuizDto lessonQuizDto);

    void editQuiz(LessonQuizDto lessonQuizDto);

    LessonQuizDto getQuizById(int id);

    LessonQuizDto getQuizByLessonId(int lessonId);

    LessonQuiz getQuizEntityByLessonId(int id);

    LessonQuiz getQuizEntityById(int id);

    QuizResultDto checkQuizResults(QuizAnswerDto quizAnswerDto);

    void deleteQuiz(int id);

    void deactivateQuiz(int id);

    void activateQuiz(int id);
}
