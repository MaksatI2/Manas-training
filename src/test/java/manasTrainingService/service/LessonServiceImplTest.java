package manasTrainingService.service;

import manasTrainingService.dto.instance.LessonCreateRequest;
import manasTrainingService.dto.lesson.LessonEditDto;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;
import manasTrainingService.exceptions.nsee.LessonNotFoundException;
import manasTrainingService.repositories.LessonRepository;
import manasTrainingService.service.impl.LessonServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.context.MessageSource;

import java.util.ArrayList;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class LessonServiceImplTest {

    @Mock
    private LessonRepository lessonRepository;

    @Mock
    private UserService userService;
    @Mock
    private ActivityLogService activityLogService;

    @Mock
    private MessageSource messageSource;

    @InjectMocks
    private LessonServiceImpl service;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);

        when(messageSource.getMessage(anyString(), any(), any()))
                .thenReturn("Урок не найден");
    }

    @Test
    void createLesson_shouldReturnCourseInstanceId_whenWithinDurationLimit() {
        CourseModule module = CourseModule.builder()
                .id(1)
                .durationHours(2)
                .build();
        module.setCourseInstance(
                manasTrainingService.entity.CourseInstance.builder().id(10).build()
        );

        LessonCreateRequest request = new LessonCreateRequest();
        request.setTitle("New Lesson");
        request.setDescription("Desc");

        when(lessonRepository.save(any(Lesson.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Integer result = service.createLesson(request, module);

        assertEquals(10, result);
        verify(lessonRepository).save(any(Lesson.class));
    }


    @Test
    void deleteById_shouldDeleteLesson_whenLessonExists() {
        Lesson lesson = Lesson.builder()
                .id(1)
                .build();
        CourseModule module = CourseModule.builder()
                .id(2)
                .lessons(new ArrayList<>())
                .build();
        lesson.setModule(module);
        module.getLessons().add(lesson);

        when(lessonRepository.findById(1)).thenReturn(Optional.of(lesson));

        service.deleteById(1);

        verify(lessonRepository).delete(lesson);
        assertFalse(module.getLessons().contains(lesson));
    }

    @Test
    void deleteById_shouldThrow_whenLessonNotFound() {
        when(lessonRepository.findById(1)).thenReturn(Optional.empty());

        assertThrows(LessonNotFoundException.class, () -> service.deleteById(1));
        verify(lessonRepository, never()).delete(any());
    }

    @Test
    void updateLesson_shouldUpdateAndSave() {
        Lesson lesson = Lesson.builder()
                .id(1)
                .title("Old Title")
                .description("Old Desc")
                .build();

        CourseModule module = CourseModule.builder()
                .id(1)
                .durationHours(2)
                .build();
        lesson.setModule(module);

        LessonEditDto dto = new LessonEditDto();
        dto.setTitle("New Title");
        dto.setDescription("New Desc");

        when(lessonRepository.findById(1)).thenReturn(Optional.of(lesson));
        when(lessonRepository.save(any(Lesson.class))).thenAnswer(invocation -> invocation.getArgument(0));

        service.updateLesson(1, dto);

        assertEquals("New Title", lesson.getTitle());
        assertEquals("New Desc", lesson.getDescription());
        verify(lessonRepository).save(lesson);
    }
}
