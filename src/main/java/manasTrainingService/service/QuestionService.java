package manasTrainingService.service;

import manasTrainingService.dto.tests.QuestionDto;
import manasTrainingService.entity.Test;
import manasTrainingService.entity.TestQuestion;

import java.util.List;

public interface QuestionService {
    void saveQuestions(List<QuestionDto> questions, Test test);

    void editQuestions(QuestionDto questionDto);

    List<QuestionDto> getQuestionsByTestId(int testId);

    TestQuestion getQuestionById(int id);
}
