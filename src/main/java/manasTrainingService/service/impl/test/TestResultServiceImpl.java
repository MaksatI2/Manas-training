package manasTrainingService.service.impl.test;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.answers.TestResultDto;
import manasTrainingService.entity.TestResult;
import manasTrainingService.exceptions.nsee.TestResultNotFoundException;
import manasTrainingService.repositories.test.TestResultRepository;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.test.TestService;
import manasTrainingService.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TestResultServiceImpl implements TestResultService {
    private final TestResultRepository testResultRepository;
    private TestService testService;
    private UserService userService;

    @Autowired
    public void setUserService(@Lazy UserService userService) {
        this.userService = userService;
    }

    @Autowired
    public void setTestService(@Lazy TestService testService) {
        this.testService = testService;
    }

    @Override
    public TestResult saveTestResult(TestAnswerDto testAnswerDto, int resultPoints, boolean isPassed, LocalDateTime endTime) {
        int duration = (int) Duration.between(testAnswerDto.getPassingStart(), endTime).toMinutes();
        TestResult testResult = new TestResult();
        testResult.setTest(testService.getTestEntityById(testAnswerDto.getTestId()));
        testResult.setStudent(userService.getAuthorizedUser());
        testResult.setScore(BigDecimal.valueOf(resultPoints));
        testResult.setStartedAt(testAnswerDto.getPassingStart());
        testResult.setSubmittedAt(endTime);
        testResult.setTimeSpentMinutes(duration);
        testResult.setIsPassed(isPassed);
        return testResultRepository.saveAndFlush(testResult);
    }

    @Override
    public TestResultDto getTestResultsByUserId(){
        TestResult testResult = testResultRepository.findByStudentId(userService.getAuthorizedUser().getId())
                .orElseThrow(() -> new TestResultNotFoundException("Результатов по данному пользователю не найденно"));
        return TestResultDto.builder()
                .totalPoints(testResult.getScore().intValue())
                .passingTime(testResult.getTimeSpentMinutes())
                .isPassed(testResult.getIsPassed())
                .build();
    }

    @Override
    public Boolean userHasTestAttempt(int testId) {
        return testResultRepository.existsByStudentIdAndTestId(userService.getAuthorizedUser().getId(), testId);
    }

    public List<TestResult> getTestResultsByStudentId(Integer studentId) {
        return testResultRepository.findAllByStudentId(studentId);
    }

    @Override
    public BigDecimal getAverageScore() {
        BigDecimal avg = testResultRepository.findAverageScore();
        return avg != null ? avg : BigDecimal.ZERO;
    }

    @Override
    public long getTotalPassedTestsInMonth(LocalDateTime start, LocalDateTime end) {
        return testResultRepository.countByIsPassedTrueAndSubmittedAtBetween(start, end);
    }

}
