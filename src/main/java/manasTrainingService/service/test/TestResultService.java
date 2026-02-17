package manasTrainingService.service.test;

import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.answers.TestResultDto;
import manasTrainingService.dto.tests.TestResultAdminDto;
import manasTrainingService.entity.TestResult;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

public interface TestResultService {
    TestResult saveTestResult(TestAnswerDto testAnswerDto, int resultScore, int percentage, Boolean isPassed);

    TestResultDto getTestResultsByUserId();

    TestResultDto getResultsByTestInstanceIdAndStudentId(int testInstanceId);

    TestResultDto getResultsByTestInstanceIdAndStudentId(int testInstanceId, int userId);

    Boolean userHasTestAttempt(int testId);

    int countUserTestAttempts(int testInstanceId);

    boolean hasPassedAttempt(int testInstanceId);

    List<TestResult> getTestResultsByStudentId(Integer studentId);

    BigDecimal getAverageScore();

    long getTotalPassedTestsInMonth(LocalDateTime start, LocalDateTime end);

    Boolean hasResultsByTestInstanceId(int testInstanceId);

    List<TestResult> getTestResultsByCourseInstanceId(Integer id);

    List<TestResultAdminDto> getAllResults();

    TestResultAdminDto getTestResultById(int id);
}
