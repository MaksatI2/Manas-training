package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.tests.OptionDto;
import manasTrainingService.dto.tests.QuestionDto;
import manasTrainingService.entity.Test;
import manasTrainingService.entity.TestQuestion;
import manasTrainingService.exceptions.nsee.TestQuestionNotFoundException;
import manasTrainingService.repositories.TestQuestionRepository;
import manasTrainingService.service.OptionService;
import manasTrainingService.service.QuestionService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class QuestionServiceImpl implements QuestionService {
    private final TestQuestionRepository testQuestionRepository;
    private final OptionService optionService;

    @Override
    public void saveQuestions(List<QuestionDto> questions, Test test){
        for(QuestionDto questionDto : questions){
            TestQuestion testQuestion = new TestQuestion();
            testQuestion.setQuestion(questionDto.getQuestion());
            testQuestion.setPoints(BigDecimal.valueOf(questionDto.getPoints()));
            if(questionDto.getIsRequired() == null){
                testQuestion.setIsRequired(false);
            }else{
                testQuestion.setIsRequired(questionDto.getIsRequired());
            }
            testQuestion.setTest(test);
            TestQuestion savedTestQuestion = testQuestionRepository.saveAndFlush(testQuestion);
            optionService.saveQuestionOptions(questionDto.getOptions(), savedTestQuestion);
        }
    }

    @Override
    public void editQuestions(QuestionDto questionDto){
        TestQuestion testQuestion = testQuestionRepository.findById(questionDto.getId())
                .orElseThrow(() -> new TestQuestionNotFoundException("Вопрос не найден"));
        testQuestion.setQuestion(questionDto.getQuestion());
        testQuestion.setPoints(BigDecimal.valueOf(questionDto.getPoints()));
        if(questionDto.getIsRequired() == null){
            testQuestion.setIsRequired(false);
        }else{
            testQuestion.setIsRequired(questionDto.getIsRequired());
        }
        testQuestionRepository.saveAndFlush(testQuestion);
        for (OptionDto questionOption : questionDto.getOptions()){
            optionService.editOption(questionOption);
        }
    }

    @Override
    public List<QuestionDto> getQuestionsByTestId(int testId){
        List<TestQuestion> questions = testQuestionRepository.findAllByTestId(testId);
        return questions.stream().map(q ->
            QuestionDto.builder()
                    .id(q.getId())
                    .question(q.getQuestion())
                    .points(q.getPoints().intValue())
                    .isRequired(q.getIsRequired())
                    .testId(q.getTest().getId())
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
