package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.tests.OptionDto;
import manasTrainingService.dto.tests.QuestionDto;
import manasTrainingService.entity.Test;
import manasTrainingService.entity.TestQuestion;
import manasTrainingService.exceptions.nsee.TestQuestionNotFoundException;
import manasTrainingService.repositories.test.TestQuestionRepository;
import manasTrainingService.service.OptionService;
import manasTrainingService.service.QuestionService;
import manasTrainingService.service.test.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuestionServiceImpl implements QuestionService {
    private final TestQuestionRepository testQuestionRepository;
    private final OptionService optionService;
    private TestService testService;

    @Autowired
    public void setTestService(@Lazy TestService testService) {
        this.testService = testService;
    }

    @Override
    public void saveQuestions(List<QuestionDto> questions, Test test) {
        List<QuestionDto> requiredQuestions = questions.stream()
                .filter(q -> q.getIsRequired())
                .toList();
        List<QuestionDto> bonusQuestions = questions.stream()
                .filter(q -> !q.getIsRequired())
                .toList();

        createQuestionsForTest(requiredQuestions, true, test);
        createQuestionsForTest(bonusQuestions, false, test);
    }

    @Override
    public void editQuestions(List<QuestionDto> questions) {
        List<QuestionDto> deletedTestQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() != null && q.getIsRemoved())
                .toList();
        List<QuestionDto> changedRequiredTestQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() == null && q.getIsRequired())
                .toList();
        List<QuestionDto> changedBonusTestQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() == null && !q.getIsRequired())
                .toList();

        if (!deletedTestQuestions.isEmpty()) {
            deleteQuestionsFromTest(deletedTestQuestions);
        }

        editQuestionFromTest(changedRequiredTestQuestions, true);

        editQuestionFromTest(changedBonusTestQuestions, false);
    }

    @Override
    public List<QuestionDto> getQuestionsByTestId(int testId) {
        List<TestQuestion> questions = testQuestionRepository.findAllByTestId(testId);
        if (questions.size() <= 20) {
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
                            .points(q.getPoints())
                            .question(q.getQuestion())
                            .options(optionService.getOptionsByQuestionId(q.getId()))
                            .build()).toList();
        }
    }

    @Override
    public TestQuestion getQuestionById(int id) {
        return testQuestionRepository.findById(id)
                .orElseThrow(() -> new TestQuestionNotFoundException("Вопрос не найден"));
    }

    private void deleteQuestionsFromTest(List<QuestionDto> questions) {
        for (QuestionDto questionDto : questions) {
            TestQuestion testQuestion = testQuestionRepository.findById(questionDto.getId())
                    .orElseThrow(() -> new TestQuestionNotFoundException("Вопрос не найден"));
            testQuestionRepository.delete(testQuestion);
        }
    }

    private void editQuestionFromTest(List<QuestionDto> questions, boolean isRequired) {
        for (QuestionDto questionDto : questions) {
            if (questionDto.getId() != null) {
                TestQuestion testQuestion = testQuestionRepository.findById(questionDto.getId())
                        .orElseThrow(() -> new TestQuestionNotFoundException("Вопрос не найден"));
                testQuestion.setQuestion(questionDto.getQuestion());
                if (isRequired) {
                    testQuestion.setPoints(BigDecimal.valueOf(100 / questions.size()));
                } else {
                    testQuestion.setPoints(BigDecimal.valueOf(10));
                }
                testQuestion.setIsRequired(questionDto.getIsRequired());
                testQuestionRepository.saveAndFlush(testQuestion);
                optionService.editOption(questionDto.getOptions(), questionDto.getCorrectOptionIndex());
            } else {
                TestQuestion testQuestion = new TestQuestion();
                testQuestion.setQuestion(questionDto.getQuestion());
                if (isRequired) {
                    testQuestion.setPoints(BigDecimal.valueOf(100 / questions.size()));
                } else {
                    testQuestion.setPoints(BigDecimal.valueOf(10));
                }
                testQuestion.setTest(testService.getTestEntityById(questionDto.getTestId()));
                testQuestion.setIsRequired(questionDto.getIsRequired());
                TestQuestion savedQuestion = testQuestionRepository.saveAndFlush(testQuestion);
                optionService.saveQuestionOptions(questionDto.getOptions(), savedQuestion, questionDto.getCorrectOptionIndex());
            }
        }
    }

    private void createQuestionsForTest(List<QuestionDto> questions, boolean isRequired, Test test) {
        for (QuestionDto questionDto : questions) {
            TestQuestion testQuestion = new TestQuestion();
            testQuestion.setQuestion(questionDto.getQuestion());
            if (isRequired) {
                testQuestion.setPoints(BigDecimal.valueOf(100 / questions.size()));
            } else {
                testQuestion.setPoints(BigDecimal.valueOf(10));
            }
            testQuestion.setIsRequired(false);
            testQuestion.setTest(test);
            TestQuestion savedTestQuestion = testQuestionRepository.saveAndFlush(testQuestion);
            optionService.saveQuestionOptions(questionDto.getOptions(), savedTestQuestion, questionDto.getCorrectOptionIndex());
        }
    }
}
