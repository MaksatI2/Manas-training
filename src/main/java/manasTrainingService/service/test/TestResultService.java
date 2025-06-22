package manasTrainingService.service.test;

import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.entity.TestResult;

public interface TestResultService {
    TestResult saveTestResult(TestAnswerDto testAnswerDto, int resultPoints, boolean isPassed);
}
