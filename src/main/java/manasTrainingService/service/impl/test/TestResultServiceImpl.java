package manasTrainingService.service.impl.test;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.answers.TestResultDto;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.tests.TestInstanceDto;
import manasTrainingService.entity.TestInstance;
import manasTrainingService.entity.TestResult;
import manasTrainingService.exceptions.nsee.TestResultNotFoundException;
import manasTrainingService.repositories.test.TestResultRepository;
import manasTrainingService.service.test.TestInstanceService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TestResultServiceImpl implements TestResultService {
    private final TestResultRepository testResultRepository;
    private UserService userService;
    private TestInstanceService testInstanceService;

    @Autowired
    public void setUserService(@Lazy UserService userService) {
        this.userService = userService;
    }
    @Autowired
    public void setTestInstanceService(TestInstanceService testInstanceService) {
        this.testInstanceService = testInstanceService;
    }

    @Override
    public TestResult saveTestResult(TestAnswerDto testAnswerDto, int resultScore, int percentage,  Boolean isPassed) {
        LocalDateTime endTime = LocalDateTime.now();
        int duration = (int) Duration.between(testAnswerDto.getPassingStart(), endTime).toMinutes();
        TestResult testResult = new TestResult();
        testResult.setTestInstance(testInstanceService.getTestInstanceEntityById(testAnswerDto.getTestInstanceId()));
        testResult.setStudent(userService.getAuthorizedUser());
        testResult.setScore(BigDecimal.valueOf(resultScore));
        testResult.setPercentage(BigDecimal.valueOf(percentage));
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
    public TestResultDto getResultsByTestInstanceIdAndStudentId(int testInstanceId){
        TestResult testResult = testResultRepository.findOneByStudentIdAndTestInstanceId(userService.getAuthorizedUser().getId(), testInstanceId)
                .orElseThrow(() -> new TestResultNotFoundException("Результатов по данному запросу не найденно"));
        return TestResultDto.builder()
                .id(testResult.getId())
                .totalPoints(testResult.getScore().intValue())
                .passingTime(testResult.getTimeSpentMinutes())
                .testInstance(TestInstanceDto.builder()
                        .courseInstance(CourseInstanceDTO.builder()
                                .id(testResult.getTestInstance().getInstance().getId())
                                .title(testResult.getTestInstance().getInstance().getTitle())
                                .build())
                        .build())
                .isPassed(testResult.getIsPassed())
                .build();
    }

    @Override
    public Boolean userHasTestAttempt(int testId) {
        return testResultRepository.existsByStudentIdAndTestInstanceId(userService.getAuthorizedUser().getId(), testId);
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

    @Override
    public Boolean hasResultsByTestInstanceId(int testInstanceId){
        return testResultRepository.existsByTestInstance_Id(testInstanceId);
    }

    @Override
    public List<TestResult> getTestResultsByCourseInstanceId(Integer id) {
        Optional<TestInstance> testInstanceOpt = testInstanceService.getTestInstanceModelByCourseInstanceId(id);

        if (testInstanceOpt.isEmpty()) {
            return Collections.emptyList();
        }

        return testResultRepository.findAllByTestInstanceId(testInstanceOpt.get().getId());
    }

}
