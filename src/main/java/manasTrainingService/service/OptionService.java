package manasTrainingService.service;

import manasTrainingService.dto.tests.OptionDto;
import manasTrainingService.entity.QuestionOption;
import manasTrainingService.entity.TestQuestion;

import java.util.List;

public interface OptionService {
    void saveQuestionOptions(List<OptionDto> options, TestQuestion testQuestion);

    void editOption(OptionDto option);

    List<OptionDto> getOptionsByQuestionId(int questionId);

    QuestionOption getOptionById(int id);
}
