package manasTrainingService.service.impl.quiz;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.quiz.LessonQuizQuestionDto;
import manasTrainingService.dto.tests.QuestionDto;
import manasTrainingService.entity.LessonQuiz;
import manasTrainingService.entity.LessonQuizQuestion;
import manasTrainingService.entity.TestQuestion;
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
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collections;
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

    @Transactional
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

    @Transactional
    @Override
    public void editQuizQuestion(List<LessonQuizQuestionDto> questions){
        List<LessonQuizQuestionDto> deletedQuizQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() != null && q.getIsRemoved())
                .toList();
        List<LessonQuizQuestionDto> changedQuizQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() == null)
                .toList();

        if(!deletedQuizQuestions.isEmpty()){
            deleteQuestionsFromEdit(deletedQuizQuestions);
        }

        editQuestionsFromEdit(changedQuizQuestions);
    }

    @Override
    public List<LessonQuizQuestionDto> getQuizQuestionsByQuizId(int quizId){
        List<LessonQuizQuestion> lessonQuizQuestions = lessonQuizQuestionRepository.findAllByQuizId(quizId);
        if (lessonQuizQuestions.size() <= 20) {
            return lessonQuizQuestions.stream().map(l ->
                    LessonQuizQuestionDto.builder()
                            .id(l.getId())
                            .question(l.getQuestion())
                            .quizId(l.getQuiz().getId())
                            .points(l.getPoints())
                            .options(lessonQuizOptionService.getQuizOptionsByQuestionId(l.getId()))
                            .build()).toList();
        } else {
            Collections.shuffle(lessonQuizQuestions);
            List<LessonQuizQuestion> randomQuestions = lessonQuizQuestions.stream()
                    .limit(20)
                    .toList();
            return randomQuestions.stream().map(l ->
                    LessonQuizQuestionDto.builder()
                            .id(l.getId())
                            .question(l.getQuestion())
                            .quizId(l.getQuiz().getId())
                            .points(l.getPoints())
                            .options(lessonQuizOptionService.getQuizOptionsByQuestionId(l.getId()))
                            .build()).toList();
        }
    }

    @Override
    public LessonQuizQuestion getQuizQuestinEntityById(int id){
        return lessonQuizQuestionRepository.findById(id)
                .orElseThrow(() -> new LessonQuizQuestionNotFoundException("Вопрос не найден"));
    }

    private void deleteQuestionsFromEdit(List<LessonQuizQuestionDto> lessonQuizQuestions){
        for (LessonQuizQuestionDto question : lessonQuizQuestions){
            LessonQuizQuestion lessonQuizQuestion = lessonQuizQuestionRepository.findById(question.getId())
                    .orElseThrow(() -> new LessonQuizQuestionNotFoundException("Вопрос не найден"));
            lessonQuizQuestionRepository.delete(lessonQuizQuestion);
        }
    }

    private void editQuestionsFromEdit(List<LessonQuizQuestionDto> questions){
        for(LessonQuizQuestionDto question : questions){
            if (question.getId() != null){
                LessonQuizQuestion lessonQuizQuestion = lessonQuizQuestionRepository.findById(question.getId())
                        .orElseThrow(() -> new LessonQuizQuestionNotFoundException("Вопрос не найден"));
                lessonQuizQuestion.setQuestion(question.getQuestion());
                lessonQuizQuestion.setPoints(BigDecimal.valueOf(100/questions.size()));
                lessonQuizQuestionRepository.saveAndFlush(lessonQuizQuestion);
                lessonQuizOptionService.editQuizOptions(question.getOptions(), question.getCorrectOptionIndex());
            }else {
                LessonQuizQuestion lessonQuizQuestion = new LessonQuizQuestion();
                lessonQuizQuestion.setQuestion(question.getQuestion());
                lessonQuizQuestion.setPoints(BigDecimal.valueOf(100/questions.size()));
                lessonQuizQuestion.setQuiz(lessonQuizService.getQuizEntityById(question.getQuizId()));
                LessonQuizQuestion savedQuizQuestion = lessonQuizQuestionRepository.saveAndFlush(lessonQuizQuestion);
                lessonQuizOptionService.saveQuizOptions(question.getOptions(), savedQuizQuestion, question.getCorrectOptionIndex());
            }
        }
    }
}
