package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.tests.OptionDto;
import manasTrainingService.dto.tests.QuestionDto;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.TargetType;
import manasTrainingService.entity.Test;
import manasTrainingService.entity.TestQuestion;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.TestQuestionNotFoundException;
import manasTrainingService.repositories.test.TestQuestionRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.OptionService;
import manasTrainingService.service.QuestionService;
import manasTrainingService.service.test.TestService;
import manasTrainingService.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class QuestionServiceImpl implements QuestionService {
    private final TestQuestionRepository testQuestionRepository;
    private final OptionService optionService;
    private TestService testService;
    private final ActivityLogService activityLogService;
    private final UserService userService;
    private final MessageSource messageSource;

    @Autowired
    public void setTestService(@Lazy TestService testService) {
        this.testService = testService;
    }

    @Override
    public void editQuestions(List<QuestionDto> questions) {
        List<QuestionDto> deletedTestQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() != null && q.getIsRemoved())
                .toList();
        List<QuestionDto> changedQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() == null)
                .toList();

        if (!deletedTestQuestions.isEmpty()){
            deleteQuestionsFromTest(deletedTestQuestions);
        }

        editQuestionFromTest(changedQuestions);
    }

    @Override
    public List<QuestionDto> getQuestionsByTestId(int testId) {
        List<TestQuestion> questions = testQuestionRepository.findAllByTestId(testId);
        return questions.stream()
                .map(q -> QuestionDto.builder()
                        .id(q.getId())
                        .testId(q.getTest().getId())
                        .question(q.getQuestion())
                        .isRequired(q.getIsRequired())
                        .options(q.getOptions().stream()
                                .map(o -> OptionDto.builder()
                                        .id(o.getId())
                                        .questionId(o.getQuestion().getId())
                                        .isCorrect(o.getIsCorrect())
                                        .optionText(o.getOptionText())
                                .build()).toList())
                        .build()).toList();
    }

    public List<QuestionDto> getQuestionsForPassingByTestId(Integer testId) {
        List<TestQuestion> questions = testQuestionRepository.findAllByTestIdAndIsRequiredTrue(testId);
        if (questions.size() <= 20) {
            return questions.stream().map(q ->
                    QuestionDto.builder()
                            .id(q.getId())
                            .question(q.getQuestion())
                            .isRequired(q.getIsRequired())
                            .testId(q.getTest().getId())
                            .question(q.getQuestion())
                            .options(q.getOptions().stream()
                                    .map(o -> OptionDto.builder()
                                            .id(o.getId())
                                            .questionId(o.getQuestion().getId())
                                            .isCorrect(o.getIsCorrect())
                                            .optionText(o.getOptionText())
                                            .build()).toList())
                            .build()).toList();
        } else {
            Collections.shuffle(questions);
            List<TestQuestion> randomQuestions = questions.stream()
                    .limit(20)
                    .toList();
            return randomQuestions.stream().map(q ->
                    QuestionDto.builder()
                            .id(q.getId())
                            .question(q.getQuestion())
                            .isRequired(q.getIsRequired())
                            .testId(q.getTest().getId())
                            .question(q.getQuestion())
                            .options(q.getOptions().stream()
                                    .map(o -> OptionDto.builder()
                                            .id(o.getId())
                                            .questionId(o.getQuestion().getId())
                                            .isCorrect(o.getIsCorrect())
                                            .optionText(o.getOptionText())
                                            .build()).toList())
                            .build()).toList();
        }
    }

    @Override
    public void saveQuestions(List<QuestionDto> questions, Test test) {
        createQuestionsForTest(questions, test);
    }

    private void createQuestionsForTest(List<QuestionDto> questions, Test test) {
        User user = userService.getAuthorizedUser();
        questions = questions.stream()
                .peek(q -> {
                    if (q.getIsRequired() == null) {
                        q.setIsRequired(false);
                    }
                }).toList();
        int basePoints = 100 / questions.stream().filter(q -> q.getIsRequired()).toList().size();
        int remainder = 100 % questions.stream().filter(q -> q.getIsRequired()).toList().size();
        for (int i = 0; i < questions.size(); i++) {
            TestQuestion testQuestion = new TestQuestion();
            testQuestion.setQuestion(questions.get(i).getQuestion());
            testQuestion.setIsRequired(questions.get(i).getIsRequired());
            testQuestion.setTest(test);
            TestQuestion savedTestQuestion = testQuestionRepository.saveAndFlush(testQuestion);
            activityLogService.log(
                    user,
                    ActionType.CREATE,
                    TargetType.TEST_QUESTION,
                    savedTestQuestion.getId()
            );
            optionService.saveQuestionOptions(questions.get(i).getOptions(), savedTestQuestion, questions.get(i).getCorrectOptionIndex());
        }
    }

    @Override
    public TestQuestion getQuestionById(int id) {
        return testQuestionRepository.findById(id)
                .orElseThrow(() -> new TestQuestionNotFoundException(
                        messageSource.getMessage("test.question.not.found", null, LocaleContextHolder.getLocale())
                ));    }

    private void deleteQuestionsFromTest(List<QuestionDto> questions) {
        User user = userService.getAuthorizedUser();
        for (QuestionDto questionDto : questions) {
            TestQuestion testQuestion = testQuestionRepository.findById(questionDto.getId())
                    .orElseThrow(() -> new TestQuestionNotFoundException(
                            messageSource.getMessage("test.question.not.found", null, LocaleContextHolder.getLocale())
                    ));            testQuestionRepository.delete(testQuestion);
            activityLogService.log(
                    user,
                    ActionType.DELETE,
                    TargetType.TEST_QUESTION,
                    testQuestion.getId()
            );
        }
    }

    private void editQuestionFromTest(List<QuestionDto> questions) {
        User user = userService.getAuthorizedUser();
        List<QuestionDto> requiredQuestions = questions.stream()
                .peek(q -> {
                    if (q.getIsRequired() == null) {
                        q.setIsRequired(false);
                    }
                })
                .filter(QuestionDto::getIsRequired)
                .toList();

        int requiredCount = requiredQuestions.size();
        int basePoints = 100 / requiredCount;
        int remainder = 100 % requiredCount;

        int requiredIndex = 0;
        for (QuestionDto q : questions) {
            TestQuestion testQuestion;

            if (q.getId() != null) {
                testQuestion = testQuestionRepository.findById(q.getId())
                        .orElseThrow(() -> new TestQuestionNotFoundException(
                                messageSource.getMessage("test.question.not.found", null, LocaleContextHolder.getLocale())
                        ));
            } else {
                testQuestion = new TestQuestion();
                testQuestion.setTest(testService.getTestEntityById(q.getTestId()));
            }

            testQuestion.setQuestion(q.getQuestion());
            testQuestion.setIsRequired(q.getIsRequired());

            TestQuestion savedQuestion = testQuestionRepository.saveAndFlush(testQuestion);

            if (q.getId() != null) {
                optionService.editOption(q.getOptions(), q.getCorrectOptionIndex());
            } else {
                optionService.saveQuestionOptions(q.getOptions(), savedQuestion, q.getCorrectOptionIndex());
            }

            activityLogService.log(
                    user,
                    ActionType.UPDATE,
                    TargetType.TEST_QUESTION,
                    testQuestion.getId()
            );
        }
    }

    @Override
    public List<QuestionDto> getQuestionsByAnswerQuestionId(TestAnswerDto testAnswerDto){
        List<TestQuestion> questions = testQuestionRepository.findAllByTestId(testAnswerDto.getTestId());
        return questions.stream()
                .filter(q -> testAnswerDto.getQuestionAnswers().stream().map(qa -> qa.getQuestionId()).toList().contains(q.getId()))
                .map(q -> QuestionDto.builder()
                        .id(q.getId())
                        .isRequired(q.getIsRequired())
                        .question(q.getQuestion())
                        .testId(q.getTest().getId())
                        .options(q.getOptions()
                                .stream()
                                .map(o -> OptionDto.builder()
                                        .id(o.getId())
                                        .optionText(o.getOptionText())
                                        .isCorrect(o.getIsCorrect())
                                        .questionId(o.getQuestion().getId())
                                        .build()).toList())
                        .build()).toList();
    }
}
