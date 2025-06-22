package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.answers.QuestionAnswerDto;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.entity.TestAnswer;
import manasTrainingService.entity.TestResult;
import manasTrainingService.repositories.TestAnswerRepository;
import manasTrainingService.service.OptionService;
import manasTrainingService.service.QuestionService;
import manasTrainingService.service.TestAnswerService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
public class TestAnswerServiceImpl implements TestAnswerService {
    private final TestAnswerRepository testAnswerRepository;
    private final QuestionService questionService;
    private final OptionService optionService;

    @Override
    public void saveTestAnswers(TestAnswerDto result, TestResult savedTestResult){
        for (QuestionAnswerDto questionAnswer : result.getQuestionAnswers()){
            TestAnswer testAnswer = new TestAnswer();
            testAnswer.setQuestion(questionService.getQuestionById(questionAnswer.getQuestionId()));
            testAnswer.setSelectedOption(optionService.getOptionById(questionAnswer.getAnswerId()));
            testAnswer.setIsCorrect(optionService.getOptionById(questionAnswer.getAnswerId()).getIsCorrect());
            if (optionService.getOptionById(questionAnswer.getAnswerId()).getIsCorrect()){
                testAnswer.setPointsEarned(questionService.getQuestionById(questionAnswer.getQuestionId()).getPoints());
            }else{
                testAnswer.setPointsEarned(BigDecimal.ZERO);
            }
            testAnswer.setAttempt(savedTestResult);
            testAnswerRepository.saveAndFlush(testAnswer);
        }
    }
}
