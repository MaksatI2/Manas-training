package manasTrainingService.service.impl.test;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.answers.QuestionAnswerDto;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.entity.TestAnswer;
import manasTrainingService.entity.TestResult;
import manasTrainingService.repositories.test.TestAnswerRepository;
import manasTrainingService.service.OptionService;
import manasTrainingService.service.QuestionService;
import manasTrainingService.service.test.TestAnswerService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

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

    @Override
    public List<QuestionAnswerDto> getAnswersByAttemtId(int attemptId){
        List<TestAnswer> testAnswers = testAnswerRepository.findAllByAttempt_Id(attemptId);
        return testAnswers.stream().map(t ->
            QuestionAnswerDto.builder()
                    .questionId(t.getQuestion().getId())
                    .answerId(t.getSelectedOption().getId())
                    .points(t.getPointsEarned())
                    .build()).toList();
    }
}
