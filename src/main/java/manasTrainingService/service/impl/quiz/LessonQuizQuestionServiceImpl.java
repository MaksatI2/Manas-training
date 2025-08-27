package manasTrainingService.service.impl.quiz;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.quiz.LessonQuizOptionDto;
import manasTrainingService.dto.quiz.LessonQuizQuestionDto;
import manasTrainingService.dto.quiz.answers.QuizAnswerDto;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.LessonQuiz;
import manasTrainingService.entity.LessonQuizQuestion;
import manasTrainingService.entity.TargetType;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.LessonQuizQuestionNotFoundException;
import manasTrainingService.repositories.quiz.LessonQuizQuestionRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.quiz.LessonQuizOptionService;
import manasTrainingService.service.quiz.LessonQuizQuestionService;
import manasTrainingService.service.quiz.LessonQuizService;
import manasTrainingService.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.i18n.LocaleContextHolder;
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
    private final ActivityLogService activityLogService;
    private final UserService userService;
    private final MessageSource messageSource;

    @Autowired
    public void setLessonQuizService(@Lazy LessonQuizService lessonQuizService) {
        this.lessonQuizService = lessonQuizService;
    }

    @Transactional
    @Override
    public void saveQuizQuestions(List<LessonQuizQuestionDto> questions, LessonQuiz lessonQuiz){

        int requiredCount = questions.size();
        int basePoints = 100 / requiredCount;
        int remainder = 100 % requiredCount;


        for(int i = 0; i < questions.size(); i++){
            LessonQuizQuestion lessonQuizQuestion = new LessonQuizQuestion();
            lessonQuizQuestion.setQuestion(questions.get(i).getQuestion());
            lessonQuizQuestion.setPoints(BigDecimal.valueOf(basePoints + (i < remainder ? 1 : 0)));
            lessonQuizQuestion.setQuiz(lessonQuiz);
            LessonQuizQuestion savedQuizQuestion = lessonQuizQuestionRepository.saveAndFlush(lessonQuizQuestion);
            lessonQuizOptionService.saveQuizOptions(questions.get(i).getOptions(), savedQuizQuestion, questions.get(i).getCorrectOptionIndex());
        }
    }

    @Transactional
    @Override
    public void editQuizQuestion(List<LessonQuizQuestionDto> questions, LessonQuiz quiz){
        List<LessonQuizQuestionDto> deletedQuizQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() != null && q.getIsRemoved())
                .toList();
        List<LessonQuizQuestionDto> changedQuizQuestions = questions.stream()
                .filter(q -> q.getIsRemoved() == null)
                .toList();

        if(!deletedQuizQuestions.isEmpty()){
            deleteQuestionsFromEdit(deletedQuizQuestions);
        }

        editQuestionsFromEdit(changedQuizQuestions, quiz);
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
    public List<LessonQuizQuestionDto> getQuizQuestionsByQuizIdForPassing(int quizId){
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
                .orElseThrow(() -> new LessonQuizQuestionNotFoundException(
                        messageSource.getMessage(
                                "lesson.quiz.question.not.found",
                                null,
                                LocaleContextHolder.getLocale()
                        )
                ));
    }

    private void deleteQuestionsFromEdit(List<LessonQuizQuestionDto> lessonQuizQuestions){
        User user = userService.getAuthorizedUser();
        for (LessonQuizQuestionDto question : lessonQuizQuestions){
            LessonQuizQuestion lessonQuizQuestion = lessonQuizQuestionRepository.findById(question.getId())
                    .orElseThrow(() -> new LessonQuizQuestionNotFoundException(
                            messageSource.getMessage(
                                    "lesson.quiz.question.not.found",
                                    null,
                                    LocaleContextHolder.getLocale()
                            )
                    ));
            activityLogService.log(
                    user,
                    ActionType.DELETE,
                    TargetType.LESSON_QUIZ_QUESTION,
                    question.getId()
            );
            lessonQuizQuestionRepository.delete(lessonQuizQuestion);
        }
    }

    private void editQuestionsFromEdit(List<LessonQuizQuestionDto> questions, LessonQuiz quiz){
        User user = userService.getAuthorizedUser();

        if (questions.isEmpty()) {
            return;
        }

        int requiredCount = questions.size();
        int basePoints = 100 / requiredCount;
        int remainder = 100 % requiredCount;

        for(int i = 0; i < questions.size(); i++){
            if (questions.get(i).getId() != null){
                LessonQuizQuestion lessonQuizQuestion = lessonQuizQuestionRepository.findById(questions.get(i).getId())
                        .orElseThrow(() -> new LessonQuizQuestionNotFoundException(
                                messageSource.getMessage(
                                        "lesson.quiz.question.not.found",
                                        null,
                                        LocaleContextHolder.getLocale()
                                )
                        ));
                lessonQuizQuestion.setQuestion(questions.get(i).getQuestion());
                lessonQuizQuestion.setPoints(BigDecimal.valueOf(basePoints + (i < remainder ? 1 : 0)));
                LessonQuizQuestion updated = lessonQuizQuestionRepository.saveAndFlush(lessonQuizQuestion);
                lessonQuizOptionService.editQuizOptions(questions.get(i).getOptions(), questions.get(i).getCorrectOptionIndex());
                activityLogService.log(
                        user,
                        ActionType.UPDATE,
                        TargetType.LESSON_QUIZ_QUESTION,
                        updated.getId()
                );
            }else {
                LessonQuizQuestion lessonQuizQuestion = new LessonQuizQuestion();
                lessonQuizQuestion.setQuestion(questions.get(i).getQuestion());
                lessonQuizQuestion.setPoints(BigDecimal.valueOf(basePoints + (i < remainder ? 1 : 0)));
                lessonQuizQuestion.setQuiz(quiz);
                LessonQuizQuestion savedQuizQuestion = lessonQuizQuestionRepository.saveAndFlush(lessonQuizQuestion);
                lessonQuizOptionService.saveQuizOptions(questions.get(i).getOptions(), savedQuizQuestion, questions.get(i).getCorrectOptionIndex());
                activityLogService.log(
                        user,
                        ActionType.CREATE,
                        TargetType.LESSON_QUIZ_QUESTION,
                        savedQuizQuestion.getId()
                );
            }
        }
    }

    @Override
    public List<LessonQuizQuestionDto> getLessonQuizQuestionsByAnswersId(QuizAnswerDto quizAnswerDto){
        List<LessonQuizQuestion> questions = lessonQuizQuestionRepository.findAllByQuizId(quizAnswerDto.getQuizId());
        return questions.stream()
                .filter(q -> quizAnswerDto.getQuestionAnswers()
                        .stream()
                        .map(qa -> qa.getQuestionId()).toList().contains(q.getId()))
                        .map(q -> LessonQuizQuestionDto.builder()
                                .id(q.getId())
                                .question(q.getQuestion())
                                .quizId(q.getQuiz().getId())
                                .options(q.getOptions().stream()
                                        .map(o -> LessonQuizOptionDto.builder()
                                                .id(o.getId())
                                                .questionId(o.getQuestion().getId())
                                                .optionText(o.getOptionText())
                                                .isCorrect(o.getIsCorrect())
                                                .build())
                                        .toList())
                                .build())
                        .toList();
    }
}
