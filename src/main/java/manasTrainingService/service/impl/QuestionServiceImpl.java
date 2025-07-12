package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.tests.OptionDto;
import manasTrainingService.dto.tests.QuestionDto;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.TargetType;
import manasTrainingService.entity.Test;
import manasTrainingService.entity.TestQuestion;
import manasTrainingService.exceptions.nsee.TestQuestionNotFoundException;
import manasTrainingService.repositories.test.TestQuestionRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.OptionService;
import manasTrainingService.service.QuestionService;
import manasTrainingService.service.test.TestService;
import manasTrainingService.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuestionServiceImpl implements QuestionService {
    private final TestQuestionRepository testQuestionRepository;
    private final OptionService optionService;
    private TestService testService;
    private final ActivityLogService activityLogService;
    private final UserService userService;

    @Autowired
    public void setTestService(@Lazy TestService testService) {
        this.testService = testService;
    }

    @Override
    public void saveQuestions(List<QuestionDto> questions, Test test){
        List<QuestionDto> requiredQuestions = questions.stream()
                .filter(q -> q.getIsRequired())
                .toList();
        List<QuestionDto> bonusQuestions = questions.stream()
                .filter(q -> !q.getIsRequired())
                .toList();

        for (QuestionDto questionDto : bonusQuestions){
            TestQuestion testQuestion = new TestQuestion();
            testQuestion.setQuestion(questionDto.getQuestion());
            testQuestion.setPoints(BigDecimal.valueOf(10));
            testQuestion.setIsRequired(false);
            testQuestion.setTest(test);
            TestQuestion savedTestQuestion = testQuestionRepository.saveAndFlush(testQuestion);
            optionService.saveQuestionOptions(questionDto.getOptions(), savedTestQuestion, questionDto.getCorrectOptionIndex());
            activityLogService.log(
                    userService.getAuthorizedUser(),
                    ActionType.CREATE,
                    TargetType.TEST_QUESTION,
                    savedTestQuestion.getId()
            );
        }

        for(QuestionDto questionDto : requiredQuestions){
            TestQuestion testQuestion = new TestQuestion();
            testQuestion.setQuestion(questionDto.getQuestion());
            testQuestion.setPoints(BigDecimal.valueOf(100/requiredQuestions.size()));
            testQuestion.setIsRequired(questionDto.getIsRequired());
            testQuestion.setTest(test);
            TestQuestion savedTestQuestion = testQuestionRepository.saveAndFlush(testQuestion);
            optionService.saveQuestionOptions(questionDto.getOptions(), savedTestQuestion, questionDto.getCorrectOptionIndex());
            activityLogService.log(
                    userService.getAuthorizedUser(),
                    ActionType.CREATE,
                    TargetType.TEST_QUESTION,
                    savedTestQuestion.getId()
            );
        }
    }

    @Override
    public void editQuestions(List<QuestionDto> questions){
        List<QuestionDto> deletedTestQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() != null && q.getIsRemoved())
                .toList();
        List<QuestionDto> changedRequiredTestQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() == null && q.getIsRequired())
                .toList();
        List<QuestionDto> changedBonusTestQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() == null && !q.getIsRequired())
                .toList();

        if (!deletedTestQuestions.isEmpty()){
            for (QuestionDto questionDto : deletedTestQuestions){
                testQuestionRepository.deleteById(questionDto.getId());
                activityLogService.log(
                        userService.getAuthorizedUser(),
                        ActionType.DELETE,
                        TargetType.TEST_QUESTION,
                        questionDto.getId()
                );
            }
        }

        for (QuestionDto questionDto : changedRequiredTestQuestions){
            if (questionDto.getId() != null){
                TestQuestion testQuestion = testQuestionRepository.findById(questionDto.getId())
                        .orElseThrow(() -> new TestQuestionNotFoundException("Вопрос не найден"));
                testQuestion.setQuestion(questionDto.getQuestion());
                testQuestion.setPoints(BigDecimal.valueOf(100/changedRequiredTestQuestions.size()));
                testQuestion.setIsRequired(questionDto.getIsRequired());
                testQuestionRepository.saveAndFlush(testQuestion);
                optionService.editOption(questionDto.getOptions(), questionDto.getCorrectOptionIndex());
                activityLogService.log(
                        userService.getAuthorizedUser(),
                        ActionType.UPDATE,
                        TargetType.TEST_QUESTION,
                        testQuestion.getId()
                );
            }else {
                TestQuestion testQuestion = new TestQuestion();
                testQuestion.setQuestion(questionDto.getQuestion());
                testQuestion.setPoints(BigDecimal.valueOf(100/changedRequiredTestQuestions.size()));
                testQuestion.setTest(testService.getTestEntityById(questionDto.getTestId()));
                testQuestion.setIsRequired(questionDto.getIsRequired());
                TestQuestion savedQuestion = testQuestionRepository.saveAndFlush(testQuestion);
                optionService.saveQuestionOptions(questionDto.getOptions(), savedQuestion, questionDto.getCorrectOptionIndex());
                activityLogService.log(
                        userService.getAuthorizedUser(),
                        ActionType.CREATE,
                        TargetType.TEST_QUESTION,
                        savedQuestion.getId()
                );
            }
        }

        for (QuestionDto questionDto : changedBonusTestQuestions){
            if (questionDto.getId() != null){
                TestQuestion testQuestion = testQuestionRepository.findById(questionDto.getId())
                        .orElseThrow(() -> new TestQuestionNotFoundException("Вопрос не найден"));


                testQuestion.setQuestion(questionDto.getQuestion());
                testQuestion.setPoints(BigDecimal.valueOf(10));
                testQuestion.setIsRequired(false);
                testQuestionRepository.saveAndFlush(testQuestion);
                optionService.editOption(questionDto.getOptions(), questionDto.getCorrectOptionIndex());
                activityLogService.log(
                        userService.getAuthorizedUser(),
                        ActionType.UPDATE,
                        TargetType.TEST_QUESTION,
                        testQuestion.getId()
                );
            } else {
                TestQuestion testQuestion = new TestQuestion();
                testQuestion.setQuestion(questionDto.getQuestion());
                testQuestion.setPoints(BigDecimal.valueOf(10));
                testQuestion.setTest(testService.getTestEntityById(questionDto.getTestId()));
                testQuestion.setIsRequired(false);
                TestQuestion savedQuestion = testQuestionRepository.saveAndFlush(testQuestion);
                optionService.saveQuestionOptions(questionDto.getOptions(), savedQuestion, questionDto.getCorrectOptionIndex());
                activityLogService.log(
                        userService.getAuthorizedUser(),
                        ActionType.CREATE,
                        TargetType.TEST_QUESTION,
                        savedQuestion.getId()
                );
            }
        }
    }

    @Override
    public List<QuestionDto> getQuestionsByTestId(int testId){
        List<TestQuestion> questions = testQuestionRepository.findAllByTestId(testId);
        return questions.stream().map(q ->
            QuestionDto.builder()
                    .id(q.getId())
                    .question(q.getQuestion())
                    .isRequired(q.getIsRequired())
                    .testId(q.getTest().getId())
                    .points(q.getPoints())
                    .question(q.getQuestion())
                    .options(optionService.getOptionsByQuestionId(q.getId()))
                    .build()).toList();
    }

    @Override
    public TestQuestion getQuestionById(int id){
        return testQuestionRepository.findById(id)
                .orElseThrow(() -> new TestQuestionNotFoundException("Вопрос не найден"));
    }
}
