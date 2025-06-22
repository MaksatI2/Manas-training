package manasTrainingService.service.impl.test;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.entity.TestResult;
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
    public TestResult saveTestResult(TestAnswerDto testAnswerDto, int resultPoints, boolean isPassed) {
        LocalDateTime submittedAt = LocalDateTime.now();
        int duration = (int) Duration.between(testAnswerDto.getPassingStart(), submittedAt).toMinutes();
        TestResult testResult = new TestResult();
        testResult.setTest(testService.getTestEntityById(testAnswerDto.getTestId()));
        testResult.setStudent(userService.getAuthorizedUser());
        testResult.setScore(BigDecimal.valueOf(resultPoints));
        testResult.setStartedAt(testAnswerDto.getPassingStart());
        testResult.setSubmittedAt(submittedAt);
        testResult.setTimeSpentMinutes(duration);
        testResult.setIsPassed(isPassed);
        return testResultRepository.saveAndFlush(testResult);
    }
}
