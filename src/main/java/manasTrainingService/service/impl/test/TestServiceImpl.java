package manasTrainingService.service.impl.test;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.answers.QuestionAnswerDto;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.answers.TestResultDto;
import manasTrainingService.dto.tests.OptionDto;
import manasTrainingService.dto.tests.QuestionDto;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.IncorrectDateException;
import manasTrainingService.exceptions.nsee.TestNotFoundException;
import manasTrainingService.repositories.TestRepository;
import manasTrainingService.service.*;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.test.TestAnswerService;
import manasTrainingService.service.test.TestInstanceService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.test.TestService;
import manasTrainingService.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TestServiceImpl implements TestService {
    private final TestRepository testRepository;
    private final QuestionService questionService;
    private final CourseService courseService;
    private final OptionService optionService;
    private TestResultService testResultService;
    private final TestAnswerService testAnswerService;
    private final ActivityLogService activityLogService;
    private final UserService userService;
    private TestInstanceService testInstanceService;
    private final EnrollmentService enrollmentService;
    private final HttpSession session;
    private final MessageSource messageSource;

    @Autowired
    public void testInstanceService(@Lazy TestInstanceService testInstanceService) {
        this.testInstanceService = testInstanceService;
    }

    @Autowired
    public void TestResultService(@Lazy TestResultService testResultService) {
        this.testResultService = testResultService;
    }

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
                .orElseThrow(() -> new TestNotFoundException(
                        messageSource.getMessage(
                                "test.not.found",
                                null,
                                "Тест не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        test.setTitle(testDto.getTitle());
        test.setDescription(testDto.getDescription());
        test.setPassingScore(BigDecimal.valueOf(testDto.getPassingScore()));
        test.setIsActive(testDto.getIsActive());
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
                .orElseThrow(() -> new TestNotFoundException(
                        messageSource.getMessage(
                                "test.not.found",
                                null,
                                "Тест не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));

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
    public TestDto getTestForPassingById(int id) {
        Test test = testRepository.findById(id)
                .orElseThrow(() -> new TestNotFoundException(
                        messageSource.getMessage(
                                "test.not.found",
                                null,
                                "Тест не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        List<QuestionDto> questions = questionService.getQuestionsForPassingByTestId(test.getId());
        session.setAttribute("questionsCount", questions.size());
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
                .questions(questions)
                .build();
    }

    @Override
    public TestDto getTestByCourseId(int id) {
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
                .orElseThrow(() -> new TestNotFoundException(
                        messageSource.getMessage(
                                "test.not.found",
                                null,
                                "Тест не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
    }

    @Override
    public Test getTestEntityById(int id) {
        return testRepository.findById(id)
                .orElseThrow(() -> new TestNotFoundException(
                        messageSource.getMessage(
                                "test.not.found",
                                null,
                                "Тест не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
    }

    @Override
    public TestResultDto checkTestResult(TestAnswerDto result) {
        Test test = testRepository.findById(result.getTestId())
                .orElseThrow(() -> new TestNotFoundException(
                        messageSource.getMessage(
                                "test.not.found",
                                null,
                                "Тест не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        int questionsCount = (Integer) session.getAttribute("questionsCount");
        session.removeAttribute("questionsCount");
        double basePoints = 100 / questionsCount;
        int remainder = 100 % questionsCount;
        for (int i = 0; i < result.getQuestionAnswers().size(); i++) {
            result.getQuestionAnswers().get(i).setPoints(BigDecimal.valueOf(basePoints + (i < remainder ? 1 : 0)));
            }
        int resultScore = (int) Math.ceil(result.getQuestionAnswers()
                .stream()
                .filter(a -> optionService.getOptionById(a.getAnswerId()).getIsCorrect())
                .mapToDouble(a -> a.getPoints().doubleValue())
                .sum());
        boolean isPassed = false;
        int percentage = (int) Math.round((resultScore * 100.0) / 100);
        if (resultScore >= test.getPassingScore().intValue()) {
            isPassed = true;
        }
        TestResult savedTestResult = testResultService.saveTestResult(result, resultScore, percentage, isPassed);
        testAnswerService.saveTestAnswers(result, savedTestResult);

        enrollmentService.courseComplete(savedTestResult);

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
                .passingTime(LocalDateTime.now().minusMinutes(result.getPassingStart().getMinute()).getMinute())
                .isPassed(isPassed)
                .testInstance(testInstanceService.getTestInstanceById(result.getTestInstanceId()))
                .build();
    }

    @Override
    public void deactivateTest(int id){
        Test test = testRepository.findById(id)
                .orElseThrow(() -> new TestNotFoundException(
                        messageSource.getMessage(
                                "test.not.found",
                                null,
                                "Тест не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        List<TestInstance> testInstances = test.getTestInstances();
        if(testInstances.isEmpty()){
            test.setIsActive(false);
            testRepository.saveAndFlush(test);
        }else if(testInstances.stream().anyMatch(t -> t.getInstance().getEndDate().isBefore(LocalDateTime.now()))){
            test.setIsActive(false);
            activityLogService.log(
                    userService.getAuthorizedUser(),
                    ActionType.UPDATE,
                    TargetType.TEST,
                    id
            );
            testRepository.saveAndFlush(test);
        } else {
            throw new IncorrectDateException(
                    messageSource.getMessage(
                            "test.deactivate.active.instance",
                            null,
                            "Тест нельзя деактивировать, если он прикреплен к активному потоку",
                            LocaleContextHolder.getLocale()
                    )
            );
        }
    }

    @Override
    public void activateTest(int id){
        Test test = testRepository.findById(id)
                .orElseThrow(() -> new TestNotFoundException(
                        messageSource.getMessage(
                                "test.not.found",
                                null,
                                "Тест не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        test.setIsActive(true);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.TEST,
                id
        );
        testRepository.saveAndFlush(test);
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
    public void deleteTest(int id) {
        Test test = testRepository.findById(id)
                .orElseThrow(() -> new TestNotFoundException(
                        messageSource.getMessage(
                                "test.not.found",
                                null,
                                "Тест не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        List<TestInstance> testInstances = test.getTestInstances();
        if(testInstances.isEmpty()){
            testRepository.deleteById(id);
            activityLogService.log(
                    userService.getAuthorizedUser(),
                    ActionType.DELETE,
                    TargetType.TEST,
                    id
            );
        }else if(testInstances.stream().anyMatch(t -> t.getInstance().getEndDate().isBefore(LocalDateTime.now()))){
            testRepository.deleteById(id);
            activityLogService.log(
                    userService.getAuthorizedUser(),
                    ActionType.DELETE,
                    TargetType.TEST,
                    id
            );
        } else {
            throw new IncorrectDateException(
                    messageSource.getMessage(
                            "test.delete.active.instance",
                            null,
                            "Тест нельзя удалить, если он привязан к активному потоку",
                            LocaleContextHolder.getLocale()
                    )
            );
        }
    }

    @Override
    public long getTotalTests() {
        return testRepository.count();
    }

    @Override
    public Boolean testExistById(int id){
        return testRepository.existsById(id);
    }

    @Override
    public TestDto getTestByIdForTestResult(int testInstanceId) {
        TestInstance testInstance = testInstanceService.getTestInstanceEntityById(testInstanceId);
        Test test = testRepository.findById(testInstance.getTest().getId())
                .orElseThrow(() -> new TestNotFoundException(
                        messageSource.getMessage(
                                "test.not.found",
                                null,
                                "Тест не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        List<QuestionAnswerDto> answers = testAnswerService.getAnswersByAttemtId(testResultService.getResultsByTestInstanceIdAndStudentId(testInstanceId).getId());
        List<QuestionDto> questions = test.getQuestions()
                .stream()
                .filter(q -> answers.stream().map(qa -> qa.getQuestionId()).toList().contains(q.getId()))
                .map(q -> QuestionDto.builder()
                        .id(q.getId())
                        .testId(q.getTest().getId())
                        .question(q.getQuestion())
                        .options(q.getOptions().stream().map(o -> OptionDto.builder()
                                .optionText(o.getOptionText())
                                .isCorrect(o.getIsCorrect())
                                .questionId(o.getQuestion().getId())
                                .id(o.getId())
                                .build()).toList())
                        .isRequired(q.getIsRequired())
                        .build())
                .toList();

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
                .questions(questions)
                .build();
    }

    @Override
    public TestDto getTestByIdForTestResult(int testInstanceId, int userId) {
        TestInstance testInstance = testInstanceService.getTestInstanceEntityById(testInstanceId);
        Test test = testRepository.findById(testInstance.getTest().getId())
                .orElseThrow(() -> new TestNotFoundException(
                        messageSource.getMessage(
                                "test.not.found",
                                null,
                                "Тест не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        List<QuestionAnswerDto> answers = testAnswerService.getAnswersByAttemtId(testResultService.getResultsByTestInstanceIdAndStudentId(testInstanceId, userId).getId());
        List<QuestionDto> questions = test.getQuestions()
                .stream()
                .filter(q -> answers.stream().map(qa -> qa.getQuestionId()).toList().contains(q.getId()))
                .map(q -> QuestionDto.builder()
                        .id(q.getId())
                        .testId(q.getTest().getId())
                        .question(q.getQuestion())
                        .options(q.getOptions().stream().map(o -> OptionDto.builder()
                                .optionText(o.getOptionText())
                                .isCorrect(o.getIsCorrect())
                                .questionId(o.getQuestion().getId())
                                .id(o.getId())
                                .build()).toList())
                        .isRequired(q.getIsRequired())
                        .build())
                .toList();

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
                .questions(questions)
                .build();
    }
}
