package manasTrainingService.service.impl.quiz;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.quiz.LessonQuizQuestionDto;
import manasTrainingService.dto.tests.QuestionDto;
import manasTrainingService.entity.LessonQuiz;
import manasTrainingService.entity.LessonQuizQuestion;
import manasTrainingService.exceptions.nsee.LessonQuizQuestionNotFoundException;
import manasTrainingService.exceptions.nsee.TestQuestionNotFoundException;
import manasTrainingService.repositories.quiz.LessonQuizQuestionRepository;
import manasTrainingService.service.quiz.LessonQuizOptionService;
import manasTrainingService.service.quiz.LessonQuizQuestionService;
import manasTrainingService.service.quiz.LessonQuizService;
import manasTrainingService.service.test.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class LessonQuizQuestionServiceImpl implements LessonQuizQuestionService {


    private final LessonQuizQuestionRepository lessonQuizQuestionRepository;
    private final LessonQuizOptionService lessonQuizOptionService;
    private LessonQuizService lessonQuizService;

    @Autowired
    public void setLessonQuizService(@Lazy LessonQuizService lessonQuizService) {
        this.lessonQuizService = lessonQuizService;
    }

    @Override
    public void saveQuizQuestions(List<LessonQuizQuestionDto> questions, LessonQuiz lessonQuiz){
        for(LessonQuizQuestionDto lessonQuizQuestionDto : questions){
            LessonQuizQuestion lessonQuizQuestion = new LessonQuizQuestion();
            lessonQuizQuestion.setQuestion(lessonQuizQuestionDto.getQuestion());
            lessonQuizQuestion.setPoints(BigDecimal.valueOf(100/questions.size()));
            lessonQuizQuestion.setQuiz(lessonQuiz);
            LessonQuizQuestion savedQuizQuestion = lessonQuizQuestionRepository.saveAndFlush(lessonQuizQuestion);
            lessonQuizOptionService.saveQuizOptions(lessonQuizQuestionDto.getOptions(), savedQuizQuestion, lessonQuizQuestionDto.getCorrectOptionIndex());
        }
    }

    @Override
    public void editQuizQuestion(List<LessonQuizQuestionDto> questions){
        List<LessonQuizQuestionDto> deletedQuizQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() != null && q.getIsRemoved())
                .toList();
        List<LessonQuizQuestionDto> changedQuizQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() == null)
                .toList();

        if(!deletedQuizQuestions.isEmpty()){
            for (LessonQuizQuestionDto question : deletedQuizQuestions){
                lessonQuizQuestionRepository.deleteById(question.getId());
            }
        }
        for(LessonQuizQuestionDto question : changedQuizQuestions){
            if (question.getId() != null){
                LessonQuizQuestion lessonQuizQuestion = lessonQuizQuestionRepository.findById(question.getId())
                        .orElseThrow(() -> new LessonQuizQuestionNotFoundException("Вопрос не найден"));
                if(question.getIsRemoved() != null && question.getIsRemoved()){
                }
                lessonQuizQuestion.setQuestion(question.getQuestion());
                lessonQuizQuestion.setPoints(BigDecimal.valueOf(100/changedQuizQuestions.size()));
                lessonQuizQuestionRepository.saveAndFlush(lessonQuizQuestion);
                lessonQuizOptionService.editQuizOptions(question.getOptions(), question.getCorrectOptionIndex());
            }else {
                LessonQuizQuestion lessonQuizQuestion = new LessonQuizQuestion();
                lessonQuizQuestion.setQuestion(question.getQuestion());
                lessonQuizQuestion.setPoints(BigDecimal.valueOf(100/changedQuizQuestions.size()));
                lessonQuizQuestion.setQuiz(lessonQuizService.getQuizEntityById(question.getQuizId()));
                LessonQuizQuestion savedQuizQuestion = lessonQuizQuestionRepository.saveAndFlush(lessonQuizQuestion);
                lessonQuizOptionService.saveQuizOptions(question.getOptions(), savedQuizQuestion, question.getCorrectOptionIndex());
            }
        }
    }

    @Override
    public List<LessonQuizQuestionDto> getQuizQuestionsByQuizId(int quizId){
        List<LessonQuizQuestion> lessonQuizQuestions = lessonQuizQuestionRepository.findAllByQuizId(quizId);
        return lessonQuizQuestions.stream().map(l ->
                LessonQuizQuestionDto.builder()
                        .id(l.getId())
                        .question(l.getQuestion())
                        .quizId(l.getQuiz().getId())
                        .points(l.getPoints())
                        .options(lessonQuizOptionService.getQuizOptionsByQuestionId(l.getId()))
                        .build()).toList();
    }

    @Override
    public LessonQuizQuestion getQuizQuestinEntityById(int id){
        return lessonQuizQuestionRepository.findById(id)
                .orElseThrow(() -> new LessonQuizQuestionNotFoundException("Вопрос не найден"));
    }
}
