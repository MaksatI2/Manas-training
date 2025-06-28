package manasTrainingService.service.test;

import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.entity.TestResult;

import java.time.LocalDateTime;
import java.time.LocalTime;

public interface TestResultService {
    TestResult saveTestResult(TestAnswerDto testAnswerDto, int resultPoints, boolean isPassed, LocalDateTime endTime);
}
