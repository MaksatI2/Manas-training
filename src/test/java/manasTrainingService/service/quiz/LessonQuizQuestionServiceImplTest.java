package manasTrainingService.service.quiz;

import manasTrainingService.dto.quiz.LessonQuizOptionDto;
import manasTrainingService.dto.quiz.LessonQuizQuestionDto;
import manasTrainingService.entity.LessonQuiz;
import manasTrainingService.entity.LessonQuizQuestion;
import manasTrainingService.exceptions.nsee.LessonQuizQuestionNotFoundException;
import manasTrainingService.repositories.quiz.LessonQuizQuestionRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.impl.quiz.LessonQuizQuestionServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.MessageSource;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class LessonQuizQuestionServiceImplTest {

    @Mock
    private LessonQuizQuestionRepository lessonQuizQuestionRepository;

    @Mock
    private LessonQuizOptionService lessonQuizOptionService;

    @Mock
    private LessonQuizService lessonQuizService;

    @Mock
    private ActivityLogService activityLogService;

    @Mock
    private UserService userService;

    @Mock
    private MessageSource messageSource;

    @InjectMocks
    private LessonQuizQuestionServiceImpl lessonQuizQuestionService;

    private LessonQuiz quiz;
    private LessonQuizQuestionDto questionDto1;
    private LessonQuizQuestionDto questionDto2;

    @BeforeEach
    void setUp() {
        quiz = new LessonQuiz();
        quiz.setId(1);

        LessonQuizOptionDto optionDto = LessonQuizOptionDto.builder()
                .id(1)
                .optionText("Option 1")
                .isCorrect(true)
                .questionId(1)
                .build();

        questionDto1 = LessonQuizQuestionDto.builder()
                .id(1)
                .question("Question 1")
                .quizId(1)
                .correctOptionIndex(0)
                .options(List.of(optionDto))
                .build();

        questionDto2 = LessonQuizQuestionDto.builder()
                .id(2)
                .question("Question 2")
                .quizId(1)
                .correctOptionIndex(0)
                .options(List.of(optionDto))
                .build();
    }

    @Test
    void saveQuizQuestions_ShouldSaveQuestionsWithPoints() {
        List<LessonQuizQuestionDto> questions = List.of(questionDto1, questionDto2);
        LessonQuizQuestion savedQuestion = new LessonQuizQuestion();
        savedQuestion.setId(1);

        when(lessonQuizQuestionRepository.saveAndFlush(any(LessonQuizQuestion.class)))
                .thenReturn(savedQuestion);

        lessonQuizQuestionService.saveQuizQuestions(questions, quiz);

        verify(lessonQuizQuestionRepository, times(2)).saveAndFlush(any(LessonQuizQuestion.class));
        verify(lessonQuizOptionService, times(2)).saveQuizOptions(any(), any(), anyInt());
    }

    @Test
    void getQuizQuestionsByQuizId_ShouldReturnQuestions() {
        LessonQuizQuestion question = new LessonQuizQuestion();
        question.setId(1);
        question.setQuestion("Test Question");
        question.setPoints(BigDecimal.valueOf(50));
        question.setQuiz(quiz);

        when(lessonQuizQuestionRepository.findAllByQuizId(1)).thenReturn(List.of(question));
        when(lessonQuizOptionService.getQuizOptionsByQuestionId(1)).thenReturn(List.of());

        List<LessonQuizQuestionDto> result = lessonQuizQuestionService.getQuizQuestionsByQuizId(1);

        assertEquals(1, result.size());
        assertEquals("Test Question", result.get(0).getQuestion());
    }

    @Test
    void getQuizQuestionsByQuizIdForPassing_LessThan20Questions_ShouldReturnAll() {
        LessonQuizQuestion question = new LessonQuizQuestion();
        question.setId(1);
        question.setQuestion("Test Question");
        question.setPoints(BigDecimal.valueOf(50));
        question.setQuiz(quiz);

        when(lessonQuizQuestionRepository.findAllByQuizId(1)).thenReturn(List.of(question));
        when(lessonQuizOptionService.getQuizOptionsByQuestionId(1)).thenReturn(List.of());

        List<LessonQuizQuestionDto> result = lessonQuizQuestionService.getQuizQuestionsByQuizIdForPassing(1);

        assertEquals(1, result.size());
    }

    @Test
    void getQuizQuestinEntityById_WhenQuestionExists_ShouldReturnQuestion() {
        LessonQuizQuestion question = new LessonQuizQuestion();
        question.setId(1);
        when(lessonQuizQuestionRepository.findById(1)).thenReturn(Optional.of(question));

        LessonQuizQuestion result = lessonQuizQuestionService.getQuizQuestinEntityById(1);

        assertNotNull(result);
        assertEquals(1, result.getId());
    }

    @Test
    void getQuizQuestinEntityById_WhenQuestionNotFound_ShouldThrowException() {
        when(lessonQuizQuestionRepository.findById(1)).thenReturn(Optional.empty());
        when(messageSource.getMessage(eq("lesson.quiz.question.not.found"), any(), any()))
                .thenReturn("Question not found");

        assertThrows(LessonQuizQuestionNotFoundException.class, () -> {
            lessonQuizQuestionService.getQuizQuestinEntityById(1);
        });
    }

    @Test
    void editQuizQuestion_WithEmptyQuestionsList_ShouldNotThrowException() {
        List<LessonQuizQuestionDto> questions = List.of();

        assertDoesNotThrow(() -> {
            lessonQuizQuestionService.editQuizQuestion(questions, quiz);
        });
    }

    @Test
    void editQuizQuestion_WithDeletedAllQuestions_ShouldHandleGracefully() {
        questionDto1.setIsRemoved(true);
        questionDto2.setIsRemoved(true);
        List<LessonQuizQuestionDto> questions = List.of(questionDto1, questionDto2);

        LessonQuizQuestion existingQuestion1 = new LessonQuizQuestion();
        existingQuestion1.setId(1);
        LessonQuizQuestion existingQuestion2 = new LessonQuizQuestion();
        existingQuestion2.setId(2);

        when(lessonQuizQuestionRepository.findById(1)).thenReturn(Optional.of(existingQuestion1));
        when(lessonQuizQuestionRepository.findById(2)).thenReturn(Optional.of(existingQuestion2));

        lessonQuizQuestionService.editQuizQuestion(questions, quiz);

        verify(lessonQuizQuestionRepository, times(2)).delete(any(LessonQuizQuestion.class));
        verify(activityLogService, times(2)).log(any(), any(), any(), anyInt());
        verify(lessonQuizQuestionRepository, never()).saveAndFlush(any(LessonQuizQuestion.class));
    }
}
