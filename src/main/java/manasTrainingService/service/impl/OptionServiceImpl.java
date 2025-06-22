package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.tests.OptionDto;
import manasTrainingService.entity.QuestionOption;
import manasTrainingService.entity.TestQuestion;
import manasTrainingService.exceptions.nsee.QuestionOptionNotFoundException;
import manasTrainingService.repositories.QuestionOptionRepository;
import manasTrainingService.service.OptionService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OptionServiceImpl implements OptionService {
    private final QuestionOptionRepository questionOptionRepository;

    @Override
    public void saveQuestionOptions(List<OptionDto> options, TestQuestion testQuestion){
        for (OptionDto optionDto : options){
            QuestionOption questionOption = new QuestionOption();
            questionOption.setQuestion(testQuestion);
            questionOption.setOptionText(optionDto.getOptionText());
            if(optionDto.getIsCorrect() == null){
                questionOption.setIsCorrect(false);
            }else{
                questionOption.setIsCorrect(optionDto.getIsCorrect());
            }
            questionOptionRepository.saveAndFlush(questionOption);
        }
    }

    @Override
    public void editOption(OptionDto option){
        QuestionOption questionOption = questionOptionRepository.findById(option.getId())
                        .orElseThrow(() -> new QuestionOptionNotFoundException("Вариант ответа не найден"));
        questionOption.setOptionText(option.getOptionText());
        if(option.getIsCorrect() == null){
            questionOption.setIsCorrect(false);
        }else{
            questionOption.setIsCorrect(option.getIsCorrect());
        }
        questionOptionRepository.saveAndFlush(questionOption);
    }

    @Override
    public List<OptionDto> getOptionsByQuestionId(int questionId){
        List<QuestionOption> options = questionOptionRepository.findAllByQuestionId(questionId);
        return options.stream().map(o ->
            OptionDto.builder()
                    .id(o.getId())
                    .optionText(o.getOptionText())
                    .isCorrect(o.getIsCorrect())
                    .questionId(o.getQuestion().getId())
                    .build()).toList();
    }

    @Override
    public QuestionOption getOptionById(int id){
        return questionOptionRepository.findById(id)
                .orElseThrow(() -> new QuestionOptionNotFoundException("Вариант ответа не найден"));
    }
}
