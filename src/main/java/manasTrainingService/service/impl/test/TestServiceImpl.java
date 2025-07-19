package manasTrainingService.service.impl.test;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.answers.TestResultDto;
import manasTrainingService.dto.tests.QuestionDto;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.TargetType;
import manasTrainingService.entity.Test;
import manasTrainingService.entity.TestInstance;
import manasTrainingService.entity.TestResult;
import manasTrainingService.exceptions.nsee.IncorrectDateException;
import manasTrainingService.exceptions.nsee.TestNotFoundException;
import manasTrainingService.repositories.test.TestRepository;
import manasTrainingService.service.*;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.test.TestAnswerService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.test.TestService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TestServiceImpl implements TestService {
    private final TestRepository testRepository;
    private final QuestionService questionService;
    private final CourseService courseService;
    private final OptionService optionService;
    private final TestResultService testResultService;
    private final TestAnswerService testAnswerService;
    private final CourseInstanceService courseInstanceService;
    private final ActivityLogService activityLogService;
    private final UserService userService;

    @PostConstruct
    public void checkInjection() {
        System.out.println("userService: " + userService);
    }

    @Override
    public void createTest(TestDto testDto) {
        Test test = new Test();
        test.setTitle(testDto.getTitle());
        test.setDescription(testDto.getDescription());
        test.setPassingScore(BigDecimal.valueOf(testDto.getPassingScore()));
        if (testDto.getIsActive() == null) {
            test.setIsActive(false);
        } else {
            test.setIsActive(testDto.getIsActive());
        }
        test.setCourse(courseService.getCourseById(testDto.getCourseInstanceId()));

        Test savedTest = testRepository.saveAndFlush(test);
        questionService.saveQuestions(testDto.getQuestions(), savedTest);

        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.CREATE,
                TargetType.TEST,
                savedTest.getId()
        );
    }

    @Override
    public void editTest(TestDto testDto) {
        Test test = testRepository.findById(testDto.getId())
                .orElseThrow(() -> new TestNotFoundException("Тест не найден"));
        test.setTitle(testDto.getTitle());
        test.setDescription(testDto.getDescription());
        test.setPassingScore(BigDecimal.valueOf(testDto.getPassingScore()));
        if (testDto.getIsActive() == null) {
            test.setIsActive(false);
        } else {
            test.setIsActive(testDto.getIsActive());
        }
        Test updated = testRepository.saveAndFlush(test);
        questionService.editQuestions(testDto.getQuestions());

        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.TEST,
                updated.getId()
        );
    }

    @Override
    public TestDto getTestById(int id) {
        Test test = testRepository.findById(id)
                .orElseThrow(() -> new TestNotFoundException("Тест не найден"));

        return TestDto.builder()
                .id(test.getId())
                .title(test.getTitle())
                .description(test.getDescription())
                .isActive(test.getIsActive())
                .courseInstanceId(test.getCourse().getId())
                .course(CourseDto.builder()
                        .id(test.getCourse().getId())
                        .title(test.getCourse().getTitle())
                        .build())
                .passingScore(test.getPassingScore().intValue())
                .questions(questionService.getQuestionsByTestId(test.getId()))
                .build();
    }

    @Override
    public TestDto getTestByCourseId(int id) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
        Test test = testRepository.findByCourseId(id)
                .orElse(null);
        if (test == null) {
            return null;
        }
        return TestDto.builder()
                .id(test.getId())
                .title(test.getTitle())
                .description(test.getDescription())
                .isActive(test.getIsActive())
                .courseInstanceId(test.getCourse().getId())
                .course(CourseDto.builder()
                        .id(test.getCourse().getId())
                        .title(test.getCourse().getTitle())
                        .build())
                .passingScore(test.getPassingScore().intValue())
                .questions(questionService.getQuestionsByTestId(test.getId()))
                .build();
    }

    @Override
    public Test getTestEntityByCourseId(int id) {
        return testRepository.findByCourseId(id)
                .orElseThrow(() -> new TestNotFoundException("Тест не найден"));
    }

    @Override
    public Test getTestEntityById(int id) {
        return testRepository.findById(id)
                .orElseThrow(() -> new TestNotFoundException("Тест не найден"));
    }

    @Override
    public TestResultDto checkTestResult(TestAnswerDto result) {
        LocalDateTime endTime = LocalDateTime.now();

        int resultScore = result.getQuestionAnswers()
                .stream()
                .filter(a -> optionService.getOptionById(a.getAnswerId()).getIsCorrect())
                .mapToInt(a -> a.getPoints().intValue())
                .sum();

        boolean isPassed = true;
        if (getTestById(result.getTestId()).getPassingScore() > resultScore) {
            isPassed = false;
        }
        TestResult savedTestResult = testResultService.saveTestResult(result, resultScore, isPassed, endTime);
        testAnswerService.saveTestAnswers(result, savedTestResult);

        return TestResultDto.builder()
                .correctAnswersCount((int) result.getQuestionAnswers()
                        .stream()
                        .filter(a -> a.getAnswerId() != null)
                        .filter(a -> optionService.getOptionById(a.getAnswerId()).getIsCorrect())
                        .count())
                .wrongAnswersCount((int) result.getQuestionAnswers()
                        .stream()
                        .filter(a -> a.getAnswerId() != null)
                        .filter(a -> !optionService.getOptionById(a.getAnswerId()).getIsCorrect())
                        .count())
                .totalPoints(resultScore)
                .withoutAnswersCount((int) result.getQuestionAnswers()
                        .stream()
                        .filter(a -> a.getAnswerId() == null)
                        .count())
                .questionsCount(result.getQuestionAnswers().size())
                .passingTime(endTime.minusMinutes(result.getPassingStart().getMinute()).getMinute())
                .isPassed(isPassed)
                .build();
    }

    @Override
    public Integer deactivateTest(int id){
        Test test = testRepository.findById(id)
                .orElseThrow(() -> new TestNotFoundException("Тест не найден"));
        List<TestInstance> testInstances = test.getTestInstances();
        if(testInstances.isEmpty()){
            test.setIsActive(false);
            return testRepository.saveAndFlush(test).getCourse().getId();
        }else if(testInstances.stream().anyMatch(t -> t.getInstance().getEndDate().isBefore(LocalDateTime.now()))){
            test.setIsActive(false);
            activityLogService.log(
                    userService.getAuthorizedUser(),
                    ActionType.UPDATE,
                    TargetType.TEST,
                    id
            );
            return testRepository.saveAndFlush(test).getCourse().getId();
        } else {
            throw new IncorrectDateException("Тест нельзя деактивироанть если он прикреплен к активному потоку");
        }
    }

    @Override
    public Integer activateTest(int id){
        Test test = testRepository.findById(id)
                .orElseThrow(() -> new TestNotFoundException("Тест не найден"));
        test.setIsActive(true);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.TEST,
                id
        );
        return testRepository.saveAndFlush(test).getCourse().getId();
    }

    @Override
    public List<TestDto> getAllTestsByCourseId(int courseId){
        List<Test> tests = testRepository.findAllByCourseId(courseId);
        return tests.stream().map(t -> TestDto.builder()
                .id(t.getId())
                .title(t.getTitle())
                .description(t.getDescription())
                .isActive(t.getIsActive())
                .course(CourseDto.builder()
                        .id(t.getCourse().getId())
                        .title(t.getCourse().getTitle())
                        .build())
                .passingScore(t.getPassingScore().intValue())
                .questions(t.getQuestions().stream().map(q -> QuestionDto.builder()
                        .question(q.getQuestion())
                        .points(q.getPoints())
                        .build()).toList())
                .build()).toList();
    }

    public void clearNoData(TestDto testDto) {
        if (testDto.getQuestions() == null) return;
        testDto.setQuestions(
                testDto.getQuestions().stream()
                        .filter(q -> q.getQuestion() != null && !q.getQuestion().isBlank())
                        .peek(q -> {
                            if (q.getOptions() != null) {
                                q.setOptions(
                                        q.getOptions().stream()
                                                .filter(o -> o.getOptionText() != null && !o.getOptionText().isBlank())
                                                .toList()
                                );
                            }
                        })
                        .toList()
        );
    }

    @Override
    public Integer deleteTest(int id) {
        Test test = testRepository.findById(id)
                        .orElseThrow(() -> new TestNotFoundException("Тест не найден"));
        int courseId = test.getCourse().getId();
        List<TestInstance> testInstances = test.getTestInstances();
        if(testInstances.isEmpty()){
            testRepository.deleteById(id);
            activityLogService.log(
                    userService.getAuthorizedUser(),
                    ActionType.DELETE,
                    TargetType.TEST,
                    id
            );
            return courseId;
        }else if(testInstances.stream().anyMatch(t -> t.getInstance().getEndDate().isBefore(LocalDateTime.now()))){
            testRepository.deleteById(id);
            activityLogService.log(
                    userService.getAuthorizedUser(),
                    ActionType.DELETE,
                    TargetType.TEST,
                    id
            );
            return courseId;
        } else {
            throw new IncorrectDateException("Тест нельзя удалить если он привязван к активному потоку");
        }
    }

    @Override
    public long getTotalTests() {
        return testRepository.count();
    }

}
