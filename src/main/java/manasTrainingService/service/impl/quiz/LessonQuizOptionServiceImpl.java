package manasTrainingService.service.impl.quiz;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.quiz.LessonQuizOptionDto;
import manasTrainingService.entity.LessonQuizOption;
import manasTrainingService.entity.LessonQuizQuestion;
import manasTrainingService.exceptions.nsee.LessonQuizOptionNotFoundException;
import manasTrainingService.repositories.quiz.LessonQuizOptionRepository;
import manasTrainingService.service.QuestionService;
import manasTrainingService.service.quiz.LessonQuizOptionService;
import manasTrainingService.service.quiz.LessonQuizQuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class LessonQuizOptionServiceImpl implements LessonQuizOptionService {

    private final LessonQuizOptionRepository lessonQuizOptionRepository;
    private LessonQuizQuestionService lessonQuizQuestionService;

    @Autowired
    public void setLessonQuizQuestionService(@Lazy LessonQuizQuestionService lessonQuizQuestionService) {
        this.lessonQuizQuestionService = lessonQuizQuestionService;
    }

    @Transactional
    @Override
    public void saveQuizOptions(List<LessonQuizOptionDto> options, LessonQuizQuestion lessonQuizQuestion, Integer correctOptionIndex){
        for(int i = 0; i<options.size(); i++){
            LessonQuizOption lessonQuizOption = new LessonQuizOption();
            lessonQuizOption.setQuestion(lessonQuizQuestion);
            lessonQuizOption.setOptionText(options.get(i).getOptionText());
            if(correctOptionIndex != null && i == correctOptionIndex){
                lessonQuizOption.setIsCorrect(true);
            }else{
                lessonQuizOption.setIsCorrect(false);
            }
            lessonQuizOptionRepository.saveAndFlush(lessonQuizOption);
        }
    }

    @Transactional
    @Override
    public void editQuizOptions(List<LessonQuizOptionDto> options, Integer correctOptionIndex){
        for(int i = 0; i<options.size(); i++) {
            if (options.get(i).getId() != null){
                if(options.get(i).getIsRemoved() != null && options.get(i).getIsRemoved()){
                    deleteOptionFromEdit(options.get(i));
                    continue;
                }
                LessonQuizOption lessonQuizOption = lessonQuizOptionRepository.findById(options.get(i).getId())
                        .orElseThrow(() -> new LessonQuizOptionNotFoundException("Ответ не найден"));
                lessonQuizOption.setOptionText(options.get(i).getOptionText());

                if(correctOptionIndex != null && i == correctOptionIndex){
                    lessonQuizOption.setIsCorrect(true);
                }else{
                    lessonQuizOption.setIsCorrect(false);
                }
                lessonQuizOptionRepository.saveAndFlush(lessonQuizOption);
            }else {
                LessonQuizOption lessonQuizOption = new LessonQuizOption();
                if(correctOptionIndex != null && i == correctOptionIndex){
                    lessonQuizOption.setIsCorrect(true);
                }else{
                    lessonQuizOption.setIsCorrect(false);
                }
                lessonQuizOption.setOptionText(options.get(i).getOptionText());
                lessonQuizOption.setQuestion(lessonQuizQuestionService.getQuizQuestinEntityById(options.get(i).getQuestionId()));
                lessonQuizOptionRepository.saveAndFlush(lessonQuizOption);
            }
        }
    }

    @Override
    public List<LessonQuizOptionDto> getQuizOptionsByQuestionId(int questionId){
        List<LessonQuizOption> options = lessonQuizOptionRepository.findAllByQuestionId(questionId);
        return options.stream().map(o ->
                LessonQuizOptionDto.builder()
                        .id(o.getId())
                        .optionText(o.getOptionText())
                        .isCorrect(o.getIsCorrect())
                        .questionId(o.getQuestion().getId())
                        .build()).toList();
    }

    @Override
    public LessonQuizOption getQuizOptionEntityById(int id){
        return lessonQuizOptionRepository.findById(id)
                .orElseThrow(() -> new LessonQuizOptionNotFoundException("Ответ не найден"));
    }

    private void deleteOptionFromEdit(LessonQuizOptionDto lessonQuizOptionDto){
        LessonQuizOption lessonQuizOption = lessonQuizOptionRepository.findById(lessonQuizOptionDto.getId())
                .orElseThrow(() -> new LessonQuizOptionNotFoundException("Ответ не найден"));
        lessonQuizOptionRepository.delete(lessonQuizOption);
    }
}
