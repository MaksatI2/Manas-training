package manasTrainingService.service.impl.quiz;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.dto.quiz.LessonQuizDto;
import manasTrainingService.dto.quiz.answers.QuizAnswerDto;
import manasTrainingService.dto.quiz.answers.QuizResultDto;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.Lesson;
import manasTrainingService.entity.LessonQuiz;
import manasTrainingService.entity.TargetType;
import manasTrainingService.exceptions.nsee.LessonQuizNotFoundException;
import manasTrainingService.repositories.quiz.LessonQuizOptionRepository;
import manasTrainingService.repositories.quiz.LessonQuizRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.quiz.LessonQuizOptionService;
import manasTrainingService.service.quiz.LessonQuizQuestionService;
import manasTrainingService.service.quiz.LessonQuizService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;

@Service
@RequiredArgsConstructor
public class LessonQuizServiceImpl implements LessonQuizService {

    private final LessonService lessonService;
    private final LessonQuizRepository lessonQuizRepository;
    private final LessonQuizQuestionService lessonQuizQuestionService;
    private final LessonQuizOptionService lessonQuizOptionService;
    private final ActivityLogService activityLogService;
    private final UserService userService;
    private final LessonQuizOptionRepository lessonQuizOptionRepository;

    @Transactional
    @Override
    public void createQuiz(LessonQuizDto lessonQuizDto){

        LessonQuiz lessonQuiz = new LessonQuiz();
        lessonQuiz.setTitle(lessonQuizDto.getTitle());
        lessonQuiz.setDescription(lessonQuizDto.getDescription());
        lessonQuiz.setQuestionTimeLimit(lessonQuizDto.getQuestionTimeLimit());
        lessonQuiz.setLesson(lessonService.getLessonModelById(lessonQuizDto.getLessonId()));
        if(lessonQuizDto.getIsActive() == null){
            lessonQuiz.setIsActive(false);
        }else{
            lessonQuiz.setIsActive(lessonQuizDto.getIsActive());
        }

        LessonQuiz saved = lessonQuizRepository.saveAndFlush(lessonQuiz);
        lessonQuizQuestionService.saveQuizQuestions(lessonQuizDto.getQuestions(), saved);

        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.CREATE,
                TargetType.LESSON_QUIZ,
                saved.getId()
        );
    }

    @Transactional
    @Override
    public void editQuiz(LessonQuizDto lessonQuizDto){
        LessonQuiz lessonQuiz = lessonQuizRepository.findById(lessonQuizDto.getId())
                .orElseThrow(() -> new LessonQuizNotFoundException("Тест не найден"));

        lessonQuiz.setTitle(lessonQuizDto.getTitle());
        lessonQuiz.setDescription(lessonQuizDto.getDescription());
        lessonQuiz.setQuestionTimeLimit(lessonQuizDto.getQuestionTimeLimit());
        if(lessonQuizDto.getIsActive() == null){
            lessonQuiz.setIsActive(false);
        }else{
            lessonQuiz.setIsActive(lessonQuizDto.getIsActive());
        }
        LessonQuiz updated = lessonQuizRepository.saveAndFlush(lessonQuiz);

        lessonQuizQuestionService.editQuizQuestion(lessonQuizDto.getQuestions(), updated);

        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.LESSON_QUIZ,
                updated.getId()
        );
    }

    @Override
    public LessonQuizDto getQuizById(int id){
        LessonQuiz lessonQuiz = lessonQuizRepository.findById(id)
                .orElseThrow(() -> new LessonQuizNotFoundException("Тест не найден"));

        return LessonQuizDto.builder()
                .id(lessonQuiz.getId())
                .title(lessonQuiz.getTitle())
                .description(lessonQuiz.getDescription())
                .isActive(lessonQuiz.getIsActive())
                .lessonId(lessonQuiz.getLesson().getId())
                .lesson(LessonDTO.builder()
                        .id(lessonQuiz.getLesson().getId())
                        .title(lessonQuiz.getLesson().getTitle())
                        .description(lessonQuiz.getLesson().getDescription())
                        .courseModule(CourseModuleDTO.builder()
                                .id(lessonQuiz.getLesson().getModule().getId())
                                .title(lessonQuiz.getLesson().getModule().getTitle())
                                .courseInstance(CourseInstanceDTO.builder()
                                        .id(lessonQuiz.getLesson().getModule().getCourseInstance().getId())
                                        .title(lessonQuiz.getLesson().getModule().getCourseInstance().getTitle())
                                        .build())
                                .build())
                        .build())
                .questionTimeLimit(lessonQuiz.getQuestionTimeLimit())
                .questions(lessonQuizQuestionService.getQuizQuestionsByQuizId(lessonQuiz.getId()))
                .build();
    }

    @Override
    public LessonQuizDto getQuizByIdForPassing(int id){
        LessonQuiz lessonQuiz = lessonQuizRepository.findById(id)
                .orElseThrow(() -> new LessonQuizNotFoundException("Тест не найден"));

        return LessonQuizDto.builder()
                .id(lessonQuiz.getId())
                .title(lessonQuiz.getTitle())
                .description(lessonQuiz.getDescription())
                .isActive(lessonQuiz.getIsActive())
                .lessonId(lessonQuiz.getLesson().getId())
                .lesson(LessonDTO.builder()
                        .id(lessonQuiz.getLesson().getId())
                        .title(lessonQuiz.getLesson().getTitle())
                        .description(lessonQuiz.getLesson().getDescription())
                        .courseModule(CourseModuleDTO.builder()
                                .id(lessonQuiz.getLesson().getModule().getId())
                                .title(lessonQuiz.getLesson().getModule().getTitle())
                                .courseInstance(CourseInstanceDTO.builder()
                                        .id(lessonQuiz.getLesson().getModule().getCourseInstance().getId())
                                        .title(lessonQuiz.getLesson().getModule().getCourseInstance().getTitle())
                                        .build())
                                .build())
                        .build())
                .questionTimeLimit(lessonQuiz.getQuestionTimeLimit())
                .questions(lessonQuizQuestionService.getQuizQuestionsByQuizIdForPassing(lessonQuiz.getId()))
                .build();
    }

    @Override
    public LessonQuizDto getQuizByLessonId(int lessonId){
        LessonQuiz lessonQuiz = lessonQuizRepository.findByLessonId(lessonId)
                .orElse(null);
        if(lessonQuiz == null){
            return null;
        }
        return LessonQuizDto.builder()
                .id(lessonQuiz.getId())
                .title(lessonQuiz.getTitle())
                .description(lessonQuiz.getDescription())
                .isActive(lessonQuiz.getIsActive())
                .lessonId(lessonQuiz.getLesson().getId())
                .questionTimeLimit(lessonQuiz.getQuestionTimeLimit())
                .questions(lessonQuizQuestionService.getQuizQuestionsByQuizId(lessonQuiz.getId()))
                .build();
    }

    @Override
    public LessonQuiz getQuizEntityByLessonId(int id){
        return lessonQuizRepository.findByLessonId(id)
                .orElseThrow(() -> new LessonQuizNotFoundException("Тест не найден"));
    }

    @Override
    public LessonQuiz getQuizEntityById(int id){
        return  lessonQuizRepository.findById(id)
                .orElseThrow(() -> new LessonQuizNotFoundException("Тест не найден"));
    }

    @Override
    public QuizResultDto checkQuizResults(QuizAnswerDto quizAnswerDto){
        LocalTime endTime = LocalTime.now();
        LessonQuiz lessonQuiz = lessonQuizRepository.findById(quizAnswerDto.getQuizId())
                .orElseThrow(() -> new LessonQuizNotFoundException("Тест не найден"));
        return QuizResultDto.builder()
                .correctAnswersCount((int) quizAnswerDto.getQuestionAnswers()
                        .stream()
                        .filter(a -> a.getAnswerId() != null)
                        .filter(a -> lessonQuizOptionService.getQuizOptionEntityById(a.getAnswerId()).getIsCorrect())
                        .count())
                .wrongAnswersCount((int) quizAnswerDto.getQuestionAnswers()
                        .stream()
                        .filter(a -> a.getAnswerId() != null)
                        .filter(a -> !lessonQuizOptionService.getQuizOptionEntityById(a.getAnswerId()).getIsCorrect())
                        .count())
                .totalPoints(quizAnswerDto.getQuestionAnswers()
                        .stream()
                        .filter(a -> a.getAnswerId() != null)
                        .filter(a -> lessonQuizOptionService.getQuizOptionEntityById(a.getAnswerId()).getIsCorrect())
                        .mapToInt(a -> lessonQuizQuestionService.getQuizQuestinEntityById(a.getQuestionId()).getPoints().intValue())
                        .sum())
                .withoutAnswersCount((int) quizAnswerDto.getQuestionAnswers()
                        .stream()
                        .filter(a -> a.getAnswerId() == null)
                        .count())
                .questionsCount(quizAnswerDto.getQuestionAnswers().size())
                .passingTime(endTime.minusMinutes(quizAnswerDto.getPassingStart().getMinute()).getMinute())
                .quiz(LessonQuizDto.builder()
                        .id(lessonQuiz.getId())
                        .title(lessonQuiz.getTitle())
                        .lesson(LessonDTO.builder()
                                .id(lessonQuiz.getLesson().getId())
                                .title(lessonQuiz.getLesson().getTitle())
                                .courseModule(CourseModuleDTO.builder()
                                        .id(lessonQuiz.getLesson().getModule().getId())
                                        .title(lessonQuiz.getLesson().getModule().getTitle())
                                        .courseInstance(CourseInstanceDTO.builder()
                                                .id(lessonQuiz.getLesson().getModule().getCourseInstance().getId())
                                                .title(lessonQuiz.getLesson().getModule().getCourseInstance().getTitle())
                                                .build())
                                        .build())
                                .build())
                        .build())
                .build();
    }

    @Override
    public void deleteQuiz(int id){
        LessonQuiz lessonQuiz = lessonQuizRepository.findById(id)
                .orElseThrow(() -> new LessonQuizNotFoundException("Тест не найден"));
        Lesson lesson = lessonQuiz.getLesson();
        lesson.setLessonQuiz(null);
        lessonQuizRepository.delete(lessonQuiz);
    }

    @Override
    public void deactivateQuiz(int id){
        LessonQuiz lessonQuiz = lessonQuizRepository.findById(id)
                .orElseThrow(() -> new LessonQuizNotFoundException("Тест не найден"));
        lessonQuiz.setIsActive(false);
        lessonQuizRepository.saveAndFlush(lessonQuiz);
    }

    @Override
    public void activateQuiz(int id){
        LessonQuiz lessonQuiz = lessonQuizRepository.findById(id)
                .orElseThrow(() -> new LessonQuizNotFoundException("Тест не найден"));
        lessonQuiz.setIsActive(true);
        lessonQuizRepository.saveAndFlush(lessonQuiz);
    }
}
