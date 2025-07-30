package manasTrainingService.service.test;

import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.answers.TestResultDto;
import manasTrainingService.entity.TestResult;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

public interface TestResultService {
    TestResult saveTestResult(TestAnswerDto testAnswerDto, int resultPoints, boolean isPassed, LocalDateTime endTime, int percentage);

    TestResultDto getTestResultsByUserId();

    TestResultDto getResultsByTestInstanceIdAndStudentId(int testInstanceId);

    Boolean userHasTestAttempt(int testId);

    List<TestResult> getTestResultsByStudentId(Integer studentId);

    BigDecimal getAverageScore();

    long getTotalPassedTestsInMonth(LocalDateTime start, LocalDateTime end);

    Boolean hasResultsByTestInstanceId(int testInstanceId);

    List<TestResult> getTestResultsByCourseInstanceId(Integer id);
}
