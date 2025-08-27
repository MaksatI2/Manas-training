package manasTrainingService.service.quiz;

import manasTrainingService.dto.quiz.LessonQuizOptionDto;
import manasTrainingService.entity.LessonQuizOption;
import manasTrainingService.entity.LessonQuizQuestion;
import manasTrainingService.exceptions.nsee.LessonQuizOptionNotFoundException;
import manasTrainingService.repositories.quiz.LessonQuizOptionRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.impl.quiz.LessonQuizOptionServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.MessageSource;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class LessonQuizOptionServiceImplTest {

    @Mock
    private LessonQuizOptionRepository lessonQuizOptionRepository;

    @Mock
    private LessonQuizQuestionService lessonQuizQuestionService;

    @Mock
    private ActivityLogService activityLogService;

    @Mock
    private UserService userService;

    @Mock
    private MessageSource messageSource;

    @InjectMocks
    private LessonQuizOptionServiceImpl lessonQuizOptionService;

    private LessonQuizQuestion question;
    private LessonQuizOptionDto optionDto1;
    private LessonQuizOptionDto optionDto2;

    @BeforeEach
    void setUp() {
        question = new LessonQuizQuestion();
        question.setId(1);

        optionDto1 = LessonQuizOptionDto.builder()
                .id(1)
                .optionText("Option 1")
                .isCorrect(true)
                .questionId(1)
                .build();

        optionDto2 = LessonQuizOptionDto.builder()
                .id(2)
                .optionText("Option 2")
                .isCorrect(false)
                .questionId(1)
                .build();
    }

    @Test
    void saveQuizOptions_WithCorrectOptionIndex_ShouldSaveOptions() {
        List<LessonQuizOptionDto> options = List.of(optionDto1, optionDto2);
        LessonQuizOption savedOption1 = new LessonQuizOption();
        savedOption1.setId(1);
        savedOption1.setIsCorrect(true);

        LessonQuizOption savedOption2 = new LessonQuizOption();
        savedOption2.setId(2);
        savedOption2.setIsCorrect(false);

        when(lessonQuizOptionRepository.saveAndFlush(any(LessonQuizOption.class)))
                .thenReturn(savedOption1, savedOption2);

        lessonQuizOptionService.saveQuizOptions(options, question, 0);

        verify(lessonQuizOptionRepository, times(2)).saveAndFlush(any(LessonQuizOption.class));
        verify(activityLogService, times(2)).log(any(), any(), any(), anyInt());
    }

    @Test
    void editQuizOptions_WithExistingOption_ShouldUpdateOption() {
        List<LessonQuizOptionDto> options = List.of(optionDto1);
        LessonQuizOption existingOption = new LessonQuizOption();
        existingOption.setId(1);

        when(lessonQuizOptionRepository.findById(1)).thenReturn(Optional.of(existingOption));
        when(lessonQuizOptionRepository.saveAndFlush(any(LessonQuizOption.class))).thenReturn(existingOption);

        lessonQuizOptionService.editQuizOptions(options, 0);

        verify(lessonQuizOptionRepository).findById(1);
        verify(lessonQuizOptionRepository).saveAndFlush(existingOption);
        assertTrue(existingOption.getIsCorrect());
    }

    @Test
    void editQuizOptions_WithRemovedOption_ShouldDeleteOption() {
        optionDto1.setIsRemoved(true);
        List<LessonQuizOptionDto> options = List.of(optionDto1);
        LessonQuizOption existingOption = new LessonQuizOption();
        existingOption.setId(1);

        when(lessonQuizOptionRepository.findById(1)).thenReturn(Optional.of(existingOption));

        lessonQuizOptionService.editQuizOptions(options, 0);

        verify(lessonQuizOptionRepository).delete(existingOption);
        verify(activityLogService).log(any(), any(), any(), eq(1));
    }

    @Test
    void getQuizOptionsByQuestionId_ShouldReturnOptions() {
        LessonQuizOption option1 = new LessonQuizOption();
        option1.setId(1);
        option1.setOptionText("Option 1");
        option1.setIsCorrect(true);
        option1.setQuestion(question);

        LessonQuizOption option2 = new LessonQuizOption();
        option2.setId(2);
        option2.setOptionText("Option 2");
        option2.setIsCorrect(false);
        option2.setQuestion(question);

        when(lessonQuizOptionRepository.findAllByQuestionId(1)).thenReturn(List.of(option1, option2));

        List<LessonQuizOptionDto> result = lessonQuizOptionService.getQuizOptionsByQuestionId(1);

        assertEquals(2, result.size());
        assertEquals("Option 1", result.get(0).getOptionText());
        assertTrue(result.get(0).getIsCorrect());
    }

    @Test
    void getQuizOptionEntityById_WhenOptionExists_ShouldReturnOption() {
        LessonQuizOption option = new LessonQuizOption();
        option.setId(1);
        when(lessonQuizOptionRepository.findById(1)).thenReturn(Optional.of(option));

        LessonQuizOption result = lessonQuizOptionService.getQuizOptionEntityById(1);

        assertNotNull(result);
        assertEquals(1, result.getId());
    }

    @Test
    void getQuizOptionEntityById_WhenOptionNotFound_ShouldThrowException() {
        when(lessonQuizOptionRepository.findById(1)).thenReturn(Optional.empty());
        when(messageSource.getMessage(eq("lesson.quiz.option.not.found"), any(), any()))
                .thenReturn("Option not found");

        assertThrows(LessonQuizOptionNotFoundException.class, () -> {
            lessonQuizOptionService.getQuizOptionEntityById(1);
        });
    }
}
