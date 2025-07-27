package manasTrainingService.service.test;

import manasTrainingService.dto.answers.QuestionAnswerDto;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.entity.TestResult;

import java.util.List;

public interface TestAnswerService {
    void saveTestAnswers(TestAnswerDto result, TestResult savedTestResult);

    List<QuestionAnswerDto> getAnswersByAttemtId(int attemptId);
}
