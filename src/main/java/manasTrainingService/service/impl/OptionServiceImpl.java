package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.tests.OptionDto;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.QuestionOption;
import manasTrainingService.entity.TargetType;
import manasTrainingService.entity.TestQuestion;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.QuestionOptionNotFoundException;
import manasTrainingService.repositories.QuestionOptionRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.OptionService;
import manasTrainingService.service.QuestionService;
import manasTrainingService.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OptionServiceImpl implements OptionService {
    private final QuestionOptionRepository questionOptionRepository;
    private QuestionService questionService;
    private final ActivityLogService activityLogService;
    private final UserService userService;
    private final MessageSource messageSource;

    @Autowired
    public void setQuestionService(@Lazy QuestionService questionService) {
        this.questionService = questionService;
    }

    @Override
    public void saveQuestionOptions(List<OptionDto> options, TestQuestion testQuestion, Integer correctOptionIndex){
        User user = userService.getAuthorizedUser();
        for(int i = 0; i<options.size(); i++){
            QuestionOption questionOption = new QuestionOption();
            questionOption.setQuestion(testQuestion);
            questionOption.setOptionText(options.get(i).getOptionText());
            if(correctOptionIndex != null && i == correctOptionIndex){
                questionOption.setIsCorrect(true);
            }else{
                questionOption.setIsCorrect(false);
            }
            QuestionOption saved = questionOptionRepository.saveAndFlush(questionOption);

            activityLogService.log(
                    user,
                    ActionType.CREATE,
                    TargetType.QUESTION_OPTION,
                    saved.getId()
            );
        }
    }

    @Override
    public void editOption(List<OptionDto> options, Integer correctOptionIndex){
        for(int i = 0; i<options.size(); i++) {
            OptionDto dto = options.get(i);

            if (options.get(i).getId() != null){
                QuestionOption questionOption = questionOptionRepository.findById(options.get(i).getId())
                        .orElseThrow(() -> new QuestionOptionNotFoundException(
                                messageSource.getMessage("question.option.not.found", null, LocaleContextHolder.getLocale())
                        ));                if(options.get(i).getIsRemoved() != null && options.get(i).getIsRemoved()){
                    questionOptionRepository.deleteById(options.get(i).getId());
                    activityLogService.log(
                            userService.getAuthorizedUser(),
                            ActionType.DELETE,
                            TargetType.QUESTION_OPTION,
                            dto.getId()
                    );
                    continue;
                }
                questionOption.setOptionText(options.get(i).getOptionText());
                if(correctOptionIndex != null && i == correctOptionIndex){
                    questionOption.setIsCorrect(true);
                }else{
                    questionOption.setIsCorrect(false);
                }
                QuestionOption updated = questionOptionRepository.saveAndFlush(questionOption);

                activityLogService.log(
                        userService.getAuthorizedUser(),
                        ActionType.UPDATE,
                        TargetType.QUESTION_OPTION,
                        updated.getId()
                );

            }else {
                QuestionOption questionOption = new QuestionOption();
                if(correctOptionIndex != null && i == correctOptionIndex){
                    questionOption.setIsCorrect(true);
                }else{
                    questionOption.setIsCorrect(false);
                }
                questionOption.setOptionText(options.get(i).getOptionText());
                questionOption.setQuestion(questionService.getQuestionById(options.get(i).getQuestionId()));
                QuestionOption saved = questionOptionRepository.saveAndFlush(questionOption);

                activityLogService.log(
                        userService.getAuthorizedUser(),
                        ActionType.CREATE,
                        TargetType.QUESTION_OPTION,
                        saved.getId()
                );
            }
        }
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
                .orElseThrow(() -> new QuestionOptionNotFoundException(
                        messageSource.getMessage("question.option.not.found", null, LocaleContextHolder.getLocale())
                ));    }
}
