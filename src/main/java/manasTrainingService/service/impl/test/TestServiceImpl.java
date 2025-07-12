package manasTrainingService.service.impl.test;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.answers.QuestionAnswerDto;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.answers.TestResultDto;
import manasTrainingService.dto.quiz.answers.QuizResultDto;
import manasTrainingService.dto.tests.OptionDto;
import manasTrainingService.dto.tests.QuestionDto;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.TargetType;
import manasTrainingService.entity.Test;
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
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
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

        LocalDateTime scheduledStart = parseDateRange(testDto).get(0);
        LocalDateTime scheduledEnd = parseDateRange(testDto).get(1);

        if (LocalDateTime.now().isAfter(scheduledStart) && LocalDateTime.now().isAfter(scheduledEnd)) {
            throw new IncorrectDateException("Дата не может быть в прошлом");
        }
        if (scheduledStart.isAfter(scheduledEnd)) {
            throw new IncorrectDateException("Дата открытия доступа не может быть после даты закрытия доступа");
        }
        if (scheduledStart.equals(scheduledEnd)) {
            throw new IncorrectDateException("Дата и время не могут быть равны");
        }
        if (courseInstanceService.getCourseInstanceById(testDto.getCourseInstanceId()).getEndDate().isBefore(scheduledStart.toLocalDate())
                || courseInstanceService.getCourseInstanceById(testDto.getCourseInstanceId()).getEndDate().isBefore(scheduledEnd.toLocalDate())) {
            throw new IncorrectDateException("Дата начала тестирования не может быть позднее даты окончания курса");
        }
        Test test = new Test();
        test.setTitle(testDto.getTitle());
        test.setDescription(testDto.getDescription());
        test.setPassingScore(BigDecimal.valueOf(testDto.getPassingScore()));
        test.setScheduledStart(scheduledStart);
        test.setScheduledEnd(scheduledEnd);
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

        LocalDateTime scheduledStart = parseDateRange(testDto).get(0);
        LocalDateTime scheduledEnd = parseDateRange(testDto).get(1);

        if (LocalDateTime.now().isAfter(scheduledStart) && LocalDateTime.now().isAfter(scheduledEnd)) {
            throw new IncorrectDateException("Дата не может быть в прошлом");
        }
        if (scheduledStart.isAfter(scheduledEnd)) {
            throw new IncorrectDateException("Дата открытия доступа не может быть после даты закрытия доступа");
        }
        if (scheduledStart.equals(scheduledEnd)) {
            throw new IncorrectDateException("Дата и время не могут быть равны");
        }
        if (courseInstanceService.getCourseInstanceById(testDto.getCourseInstanceId()).getEndDate().isBefore(scheduledStart.toLocalDate())
                || courseInstanceService.getCourseInstanceById(testDto.getCourseInstanceId()).getEndDate().isBefore(scheduledEnd.toLocalDate())) {
            throw new IncorrectDateException("Дата начала тестирования не может быть позднее даты окончания курса");
        }
        test.setTitle(testDto.getTitle());
        test.setDescription(testDto.getDescription());
        test.setPassingScore(BigDecimal.valueOf(testDto.getPassingScore()));
        test.setScheduledStart(scheduledStart);
        test.setScheduledEnd(scheduledEnd);
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
                .startDate(test.getScheduledStart().toLocalDate())
                .endDate(test.getScheduledEnd().toLocalDate())
                .startTime(test.getScheduledStart().toLocalTime())
                .endTime(test.getScheduledEnd().toLocalTime())
                .courseInstanceId(test.getCourse().getId())
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
                .startDate(test.getScheduledStart().toLocalDate())
                .endDate(test.getScheduledEnd().toLocalDate())
                .startTime(test.getScheduledStart().toLocalTime())
                .endTime(test.getScheduledEnd().toLocalTime())
                .courseInstanceId(test.getCourse().getId())
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
        testRepository.deleteById(id);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.DELETE,
                TargetType.TEST,
                id
        );
    }

    private List<LocalDateTime> parseDateRange(TestDto testDto) {
        LocalDateTime start = testDto.getStartDate().atTime(testDto.getStartTime());
        LocalDateTime end = testDto.getEndDate().atTime(testDto.getEndTime());
        List<LocalDateTime> dates = new ArrayList<>();
        dates.add(start);
        dates.add(end);
        return dates;
    }
}
