package manasTrainingService.service.test;

import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.entity.TestResult;

public interface TestAnswerService {
    void saveTestAnswers(TestAnswerDto result, TestResult savedTestResult);
}
