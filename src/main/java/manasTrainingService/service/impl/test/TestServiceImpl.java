package manasTrainingService.service.impl.test;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.answers.QuestionAnswerDto;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.tests.QuestionDto;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.entity.Test;
import manasTrainingService.entity.TestResult;
import manasTrainingService.exceptions.nsee.IncorrectDateException;
import manasTrainingService.exceptions.nsee.TestNotFoundException;
import manasTrainingService.repositories.test.TestRepository;
import manasTrainingService.service.*;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.test.TestAnswerService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.test.TestService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
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

    @Override
    public void createTest(TestDto testDto){

        LocalDateTime scheduledStart = parseDateRange(testDto.getRange()).get(0);
        LocalDateTime scheduledEnd = parseDateRange(testDto.getRange()).get(1);

        if(LocalDateTime.now().isAfter(scheduledStart) && LocalDateTime.now().isAfter(scheduledEnd)){
            throw new IncorrectDateException("Дата не может быть в прошлом");
        }
        if (scheduledStart.isAfter(scheduledEnd)){
            throw new IncorrectDateException("Дата открытия доступа не может быть после даты закрытия доступа");
        }
        if (scheduledStart.equals(scheduledEnd)){
            throw new IncorrectDateException("Дата и время не могут быть равны");
        }
        Test test = new Test();
        test.setTitle(testDto.getTitle());
        test.setDescription(testDto.getDescription());
        test.setPassingScore(BigDecimal.valueOf(testDto.getPassingScore()));
        test.setScheduledStart(scheduledStart);
        test.setScheduledEnd(scheduledEnd);
        if(testDto.getIsActive() == null){
            test.setIsActive(false);
        }else{
            test.setIsActive(testDto.getIsActive());
        }
        test.setCourse(courseService.getCourseById(testDto.getCourseInstanceId()));

        Test savedTest = testRepository.saveAndFlush(test);
        questionService.saveQuestions(testDto.getQuestions(), savedTest);
    }

    @Override
    public void editTest(TestDto testDto){
        Test test = testRepository.findById(testDto.getId())
                .orElseThrow(() -> new TestNotFoundException("Тест не найден"));

        LocalDateTime scheduledStart = parseDateRange(testDto.getRange()).get(0);
        LocalDateTime scheduledEnd = parseDateRange(testDto.getRange()).get(1);

        if(LocalDateTime.now().isAfter(scheduledStart) && LocalDateTime.now().isAfter(scheduledEnd)){
            throw new IncorrectDateException("Дата не может быть в прошлом");
        }
        if (scheduledStart.isAfter(scheduledEnd)){
            throw new IncorrectDateException("Дата открытия доступа не может быть после даты закрытия доступа");
        }
        if (scheduledStart.equals(scheduledEnd)){
            throw new IncorrectDateException("Дата и время не могут быть равны");
        }
        test.setTitle(testDto.getTitle());
        test.setDescription(testDto.getDescription());
        test.setPassingScore(BigDecimal.valueOf(testDto.getPassingScore()));
        test.setScheduledStart(scheduledStart);
        test.setScheduledEnd(scheduledEnd);
        if(testDto.getIsActive() == null){
            test.setIsActive(false);
        }else{
            test.setIsActive(testDto.getIsActive());
        }
        testRepository.saveAndFlush(test);
        for (QuestionDto testQuestion : testDto.getQuestions()){
            questionService.editQuestions(testQuestion);
        }
    }

    @Override
    public TestDto getTestById(int id){
        Test test = testRepository.findById(id)
                .orElseThrow(() -> new TestNotFoundException("Тест не найден"));

        return TestDto.builder()
                .id(test.getId())
                .title(test.getTitle())
                .description(test.getDescription())
                .isActive(test.getIsActive())
                .range(convertToString(test.getScheduledStart(), test.getScheduledEnd()))
                .courseInstanceId(test.getCourse().getId())
                .passingScore(test.getPassingScore().intValue())
                .questions(questionService.getQuestionsByTestId(test.getId()))
                .build();
    }

    @Override
    public Test getTestEntityById(int id){
        return  testRepository.findById(id)
                .orElseThrow(() -> new TestNotFoundException("Тест не найден"));
    }

    @Override
    public void checkTestResunt(TestAnswerDto result){
        int resultScore = result.getQuestionAnswers()
                .stream()
                .filter(a -> optionService.getOptionById(a.getAnswerId()).getIsCorrect())
                .mapToInt(QuestionAnswerDto::getPoints)
                .sum();
        boolean isPassed = true;
        if(getTestById(result.getTestId()).getPassingScore() > resultScore){
            isPassed = false;
        }
        TestResult savedTestResult = testResultService.saveTestResult(result, resultScore, isPassed);
        testAnswerService.saveTestAnswers(result, savedTestResult);
    }

    private List<LocalDateTime> parseDateRange(String range){
        if(range.contains(" - ")){
            List<LocalDateTime> dates = new ArrayList<>();
            String[] parsedString = range.split(" - ");
            String parsedStart = parsedString[0];
            String parsedEnd = parsedString[1];

            String parsedStartDate = parsedStart.split(" ")[0];
            String parsedStartTime = parsedStart.split(" ")[1];

            String parsedEndDate = parsedEnd.split(" ")[0];
            String parsedEndTime = parsedEnd.split(" ")[1];

            dates.add(LocalDateTime.of(
                    LocalDate.now().getYear(),
                    Integer.parseInt(parsedStartDate.split("-")[1]),
                    Integer.parseInt(parsedStartDate.split("-")[2]),
                    Integer.parseInt(parsedStartTime.split(":")[0]),
                    Integer.parseInt(parsedStartTime.split(":")[1]),
                    0
            ));
            dates.add(LocalDateTime.of(
                    LocalDate.now().getYear(),
                    Integer.parseInt(parsedEndDate.split("-")[1]),
                    Integer.parseInt(parsedEndDate.split("-")[2]),
                    Integer.parseInt(parsedEndTime.split(":")[0]),
                    Integer.parseInt(parsedEndTime.split(":")[1]),
                    0
            ));
            return dates;
        }else {
            throw new IncorrectDateException("Неверный диапозон дат");
        }
    }

    private String convertToString(LocalDateTime startDate, LocalDateTime endDate){
        return startDate.toString() + " - " + endDate.toString();
    }
}
