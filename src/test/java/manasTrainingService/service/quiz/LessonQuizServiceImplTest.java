package manasTrainingService.service.quiz;

import manasTrainingService.dto.quiz.LessonQuizDto;
import manasTrainingService.dto.quiz.LessonQuizQuestionDto;
import manasTrainingService.dto.quiz.answers.QuizAnswerDto;
import manasTrainingService.dto.quiz.answers.QuizResultDto;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;
import manasTrainingService.entity.LessonQuiz;
import manasTrainingService.exceptions.nsee.LessonQuizNotFoundException;
import manasTrainingService.repositories.quiz.LessonQuizRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.impl.quiz.LessonQuizServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.MessageSource;

import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class LessonQuizServiceImplTest {

    @Mock
    private LessonService lessonService;

    @Mock
    private LessonQuizRepository lessonQuizRepository;

    @Mock
    private LessonQuizQuestionService lessonQuizQuestionService;

    @Mock
    private LessonQuizOptionService lessonQuizOptionService;

    @Mock
    private ActivityLogService activityLogService;

    @Mock
    private UserService userService;

    @Mock
    private MessageSource messageSource;

    @InjectMocks
    private LessonQuizServiceImpl lessonQuizService;

    private LessonQuizDto quizDto;
    private LessonQuiz quiz;
    private Lesson lesson;
    private CourseModule module;
    private CourseInstance courseInstance;

    @BeforeEach
    void setUp() {
        courseInstance = new CourseInstance();
        courseInstance.setId(1);
        courseInstance.setTitle("Test Course");

        module = new CourseModule();
        module.setId(1);
        module.setTitle("Test Module");
        module.setCourseInstance(courseInstance);

        lesson = new Lesson();
        lesson.setId(1);
        lesson.setTitle("Test Lesson");
        lesson.setDescription("Test Lesson Description");
        lesson.setModule(module);

        quiz = new LessonQuiz();
        quiz.setId(1);
        quiz.setTitle("Test Quiz");
        quiz.setDescription("Test Description");
        quiz.setIsActive(true);
        quiz.setLesson(lesson);

        LessonQuizQuestionDto questionDto = LessonQuizQuestionDto.builder()
                .id(1)
                .question("Test Question")
                .quizId(1)
                .build();

        quizDto = LessonQuizDto.builder()
                .id(1)
                .title("Test Quiz")
                .description("Test Description")
                .isActive(true)
                .lessonId(1)
                .questions(List.of(questionDto))
                .build();
    }

    @Test
    void createQuiz_ShouldSaveQuizAndQuestions() {
        when(lessonService.getLessonModelById(1)).thenReturn(lesson);
        when(lessonQuizRepository.saveAndFlush(any(LessonQuiz.class))).thenReturn(quiz);

        // Act
        lessonQuizService.createQuiz(quizDto);

        // Assert
        verify(lessonQuizRepository).saveAndFlush(any(LessonQuiz.class));
        verify(lessonQuizQuestionService).saveQuizQuestions(any(), any());
        verify(activityLogService).log(any(), any(), any(), eq(1));
    }

    @Test
    void editQuiz_WhenQuizExists_ShouldUpdateQuiz() {
        // Arrange
        when(lessonQuizRepository.findById(1)).thenReturn(Optional.of(quiz));
        when(lessonQuizRepository.saveAndFlush(any(LessonQuiz.class))).thenReturn(quiz);

        // Act
        lessonQuizService.editQuiz(quizDto);

        // Assert
        verify(lessonQuizRepository).findById(1);
        verify(lessonQuizRepository).saveAndFlush(quiz);
        verify(lessonQuizQuestionService).editQuizQuestion(any(), any());
        verify(activityLogService).log(any(), any(), any(), eq(1));
    }

    @Test
    void getQuizById_WhenQuizExists_ShouldReturnQuiz() {
        // Arrange
        when(lessonQuizRepository.findById(1)).thenReturn(Optional.of(quiz));
        when(lessonQuizQuestionService.getQuizQuestionsByQuizId(1)).thenReturn(List.of());

        // Act
        LessonQuizDto result = lessonQuizService.getQuizById(1);

        // Assert
        assertNotNull(result);
        assertEquals("Test Quiz", result.getTitle());
    }

    @Test
    void getQuizById_WhenQuizNotFound_ShouldThrowException() {
        // Arrange
        when(lessonQuizRepository.findById(1)).thenReturn(Optional.empty());
        when(messageSource.getMessage(eq("lesson.quiz.not.found"), any(), any()))
                .thenReturn("Quiz not found");

        // Act & Assert
        assertThrows(LessonQuizNotFoundException.class, () -> {
            lessonQuizService.getQuizById(1);
        });
    }

    @Test
    void getQuizByLessonId_WhenQuizExists_ShouldReturnQuiz() {
        // Arrange
        when(lessonQuizRepository.findByLessonId(1)).thenReturn(Optional.of(quiz));
        when(lessonQuizQuestionService.getQuizQuestionsByQuizId(1)).thenReturn(List.of());

        // Act
        LessonQuizDto result = lessonQuizService.getQuizByLessonId(1);

        // Assert
        assertNotNull(result);
        assertEquals("Test Quiz", result.getTitle());
    }

    @Test
    void getQuizByLessonId_WhenQuizNotExists_ShouldReturnNull() {
        // Arrange
        when(lessonQuizRepository.findByLessonId(1)).thenReturn(Optional.empty());

        // Act
        LessonQuizDto result = lessonQuizService.getQuizByLessonId(1);

        // Assert
        assertNull(result);
    }

    @Test
    void checkQuizResults_ShouldCalculateCorrectResults() {
        // Arrange
        QuizAnswerDto quizAnswerDto = new QuizAnswerDto();
        quizAnswerDto.setQuizId(1);
        quizAnswerDto.setPassingStart(LocalTime.now().minusMinutes(10));
        quizAnswerDto.setQuestionAnswers(List.of()); // Initialize empty list

        when(lessonQuizRepository.findById(1)).thenReturn(Optional.of(quiz));

        // Act
        QuizResultDto result = lessonQuizService.checkQuizResults(quizAnswerDto);

        // Assert
        assertNotNull(result);
        assertEquals(0, result.getCorrectAnswersCount());
        assertEquals(0, result.getWrongAnswersCount());
        assertEquals(0, result.getWithoutAnswersCount());
        assertEquals(0, result.getQuestionsCount());
    }

    @Test
    void activateQuiz_ShouldSetActiveTrue() {
        // Arrange
        when(lessonQuizRepository.findById(1)).thenReturn(Optional.of(quiz));
        when(lessonQuizRepository.saveAndFlush(any(LessonQuiz.class))).thenReturn(quiz);

        // Act
        lessonQuizService.activateQuiz(1);

        // Assert
        assertTrue(quiz.getIsActive());
        verify(lessonQuizRepository).saveAndFlush(quiz);
    }

    @Test
    void deactivateQuiz_ShouldSetActiveFalse() {
        // Arrange
        when(lessonQuizRepository.findById(1)).thenReturn(Optional.of(quiz));
        when(lessonQuizRepository.saveAndFlush(any(LessonQuiz.class))).thenReturn(quiz);

        // Act
        lessonQuizService.deactivateQuiz(1);

        // Assert
        assertFalse(quiz.getIsActive());
        verify(lessonQuizRepository).saveAndFlush(quiz);
    }

    @Test
    void deleteQuiz_ShouldRemoveQuizFromLessonAndDelete() {
        // Arrange
        when(lessonQuizRepository.findById(1)).thenReturn(Optional.of(quiz));

        // Act
        lessonQuizService.deleteQuiz(1);

        // Assert
        verify(lessonQuizRepository).delete(quiz);
        assertNull(lesson.getLessonQuiz());
    }
}