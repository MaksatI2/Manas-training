package manasTrainingService.service;

import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.tests.QuestionDto;
import manasTrainingService.entity.Test;
import manasTrainingService.entity.TestQuestion;

import java.util.List;

public interface QuestionService {
    List<QuestionDto> getQuestionsForPassingByTestId(Integer testId);

    void saveQuestions(List<QuestionDto> questions, Test test);

    void editQuestions(List<QuestionDto> questions);

    List<QuestionDto> getQuestionsByTestId(int testId);

    TestQuestion getQuestionById(int id);

    List<QuestionDto> getQuestionsByAnswerQuestionId(TestAnswerDto testAnswerDto);
}
