package manasTrainingService.service.impl.test;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.answers.TestResultDto;
import manasTrainingService.dto.certificate.StudentDto;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.dto.tests.TestInstanceDto;
import manasTrainingService.dto.tests.TestResultAdminDto;
import manasTrainingService.entity.TestInstance;
import manasTrainingService.entity.TestResult;
import manasTrainingService.exceptions.nsee.TestResultNotFoundException;
import manasTrainingService.repositories.test.TestResultRepository;
import manasTrainingService.service.test.TestInstanceService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.i18n.LocaleContextHolder;
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
    private final MessageSource messageSource;

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
        
        List<TestResult> existingAttempts = testResultRepository
                .findAllByStudentIdAndTestInstanceId(userService.getAuthorizedUser().getId(), testAnswerDto.getTestInstanceId());
        int attemptNumber = existingAttempts.size() + 1;
        
        TestResult testResult = new TestResult();
        testResult.setTestInstance(testInstanceService.getTestInstanceEntityById(testAnswerDto.getTestInstanceId()));
        testResult.setStudent(userService.getAuthorizedUser());
        testResult.setScore(BigDecimal.valueOf(resultScore));
        testResult.setPercentage(BigDecimal.valueOf(percentage));
        testResult.setStartedAt(testAnswerDto.getPassingStart());
        testResult.setSubmittedAt(endTime);
        testResult.setTimeSpentMinutes(duration);
        testResult.setIsPassed(isPassed);
        testResult.setAttemptNumber(attemptNumber);
        return testResultRepository.saveAndFlush(testResult);
    }

    @Override
    public TestResultDto getTestResultsByUserId(){
        TestResult testResult = testResultRepository.findByStudentId(userService.getAuthorizedUser().getId())
                .orElseThrow(() -> new TestResultNotFoundException(
                        messageSource.getMessage(
                                "test.result.not.found.for.user",
                                null,
                                "Результатов по данному пользователю не найдено",
                                LocaleContextHolder.getLocale()
                        )
                ));
        return TestResultDto.builder()
                .totalPoints(testResult.getScore().intValue())
                .passingTime(testResult.getTimeSpentMinutes())
                .isPassed(testResult.getIsPassed())
                .build();
    }

    @Override
    public TestResultDto getResultsByTestInstanceIdAndStudentId(int testInstanceId){
        TestResult testResult = testResultRepository.findOneByStudentIdAndTestInstanceId(userService.getAuthorizedUser().getId(), testInstanceId)
                .orElseThrow(() -> new TestResultNotFoundException(
                        messageSource.getMessage(
                                "test.result.not.found.for.request",
                                null,
                                "Результатов по данному запросу не найдено",
                                LocaleContextHolder.getLocale()
                        )
                ));
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
    public TestResultDto getResultsByTestInstanceIdAndStudentId(int testInstanceId, int userId){
        TestResult testResult = testResultRepository.findOneByStudentIdAndTestInstanceId(userId, testInstanceId)
                .orElseThrow(() -> new TestResultNotFoundException(
                        messageSource.getMessage(
                                "test.result.not.found.for.request",
                                null,
                                "Результатов по данному запросу не найдено",
                                LocaleContextHolder.getLocale()
                        )
                ));
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

    @Override
    public int countUserTestAttempts(int testInstanceId) {
        List<TestResult> attempts = testResultRepository
                .findAllByStudentIdAndTestInstanceId(userService.getAuthorizedUser().getId(), testInstanceId);
        return attempts.size();
    }

    @Override
    public boolean hasPassedAttempt(int testInstanceId) {
        List<TestResult> attempts = testResultRepository
                .findAllByStudentIdAndTestInstanceId(userService.getAuthorizedUser().getId(), testInstanceId);
        return attempts.stream().anyMatch(TestResult::getIsPassed);
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

    @Override
    public List<TestResultAdminDto> getAllResults(){
        List<TestResult> testResults = testResultRepository.findAll();
        return testResults
                .stream()
                .map(t ->
                        TestResultAdminDto
                                .builder()
                                .id(t.getId())
                                .student(StudentDto
                                        .builder()
                                        .id(t.getStudent().getId())
                                        .email(t.getStudent().getEmail())
                                        .name(t.getStudent().getName())
                                        .lastName(t.getStudent().getLastName())
                                        .build())
                                .testInstance(TestInstanceDto
                                        .builder()
                                        .id(t.getTestInstance().getId())
                                        .test(TestDto
                                                .builder()
                                                .id(t.getTestInstance().getTest().getId())
                                                .title(t.getTestInstance().getTest().getTitle())
                                                .description(t.getTestInstance().getTest().getDescription())
                                                .passingScore(t.getTestInstance().getTest().getPassingScore().intValue())
                                                .course(CourseDto
                                                        .builder()
                                                        .id(t.getTestInstance().getTest().getCourse().getId())
                                                        .title(t.getTestInstance().getTest().getCourse().getTitle())
                                                        .description(t.getTestInstance().getTest().getCourse().getDescription())
                                                        .build())
                                                .build())
                                        .build())
                                .courseInstance(CourseInstanceDTO
                                        .builder()
                                        .id(t.getTestInstance().getInstance().getId())
                                        .title(t.getTestInstance().getInstance().getTitle())
                                        .build())
                                .isPassed(t.getIsPassed())
                                .percentage(t.getPercentage())
                                .score(t.getScore())
                                .timeSpentMinutes(t.getTimeSpentMinutes())
                                .build())
                .toList();
    }

    @Override
    public TestResultAdminDto getTestResultById(int id){
        TestResult testResult = testResultRepository.findById(id)
                .orElseThrow(() -> new TestResultNotFoundException(
                        messageSource.getMessage(
                                "test.result.not.found.for.request",
                                null,
                                "Результатов по данному запросу не найдено",
                                LocaleContextHolder.getLocale()
                        )
                ));
        return TestResultAdminDto
                                .builder()
                                .id(testResult.getId())
                                .student(StudentDto
                                        .builder()
                                        .id(testResult.getStudent().getId())
                                        .email(testResult.getStudent().getEmail())
                                        .name(testResult.getStudent().getName())
                                        .lastName(testResult.getStudent().getLastName())
                                        .build())
                                .testInstance(TestInstanceDto
                                        .builder()
                                        .id(testResult.getTestInstance().getId())
                                        .test(TestDto
                                                .builder()
                                                .id(testResult.getTestInstance().getTest().getId())
                                                .title(testResult.getTestInstance().getTest().getTitle())
                                                .description(testResult.getTestInstance().getTest().getDescription())
                                                .passingScore(testResult.getTestInstance().getTest().getPassingScore().intValue())
                                                .course(CourseDto
                                                        .builder()
                                                        .id(testResult.getTestInstance().getTest().getCourse().getId())
                                                        .title(testResult.getTestInstance().getTest().getCourse().getTitle())
                                                        .description(testResult.getTestInstance().getTest().getCourse().getDescription())
                                                        .build())
                                                .build())
                                        .build())
                                .courseInstance(CourseInstanceDTO
                                        .builder()
                                        .id(testResult.getTestInstance().getInstance().getId())
                                        .title(testResult.getTestInstance().getInstance().getTitle())
                                        .build())
                                .isPassed(testResult.getIsPassed())
                                .percentage(testResult.getPercentage())
                                .score(testResult.getScore())
                                .timeSpentMinutes(testResult.getTimeSpentMinutes())
                                .build();
    }

}
