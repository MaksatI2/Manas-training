package manasTrainingService;

import manasTrainingService.dto.instance.LessonCreateRequest;
import manasTrainingService.dto.lesson.LessonEditDto;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;
import manasTrainingService.exceptions.nsee.LessonNotFoundException;
import manasTrainingService.repositories.LessonRepository;
import manasTrainingService.service.impl.LessonServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;

import java.util.ArrayList;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class LessonServiceImplTest {

    @Mock
    private LessonRepository lessonRepository;

    @InjectMocks
    private LessonServiceImpl service;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
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
        request.setDurationMinutes(60);

        when(lessonRepository.getTotalUsedMinutes(module.getId())).thenReturn(30);
        when(lessonRepository.save(any(Lesson.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Integer result = service.createLesson(request, module);

        assertEquals(10, result);
        verify(lessonRepository).save(any(Lesson.class));
    }

    @Test
    void createLesson_shouldThrowException_whenDurationExceedsLimit() {
        CourseModule module = CourseModule.builder()
                .id(1)
                .durationHours(1)
                .build();

        LessonCreateRequest request = new LessonCreateRequest();
        request.setDurationMinutes(40);

        when(lessonRepository.getTotalUsedMinutes(module.getId())).thenReturn(30);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            service.createLesson(request, module);
        });

        assertTrue(ex.getMessage().contains("Превышено допустимое время модуля"));
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
    void updateLesson_shouldUpdateAndSave_whenWithinLimit() {
        Lesson lesson = Lesson.builder()
                .id(1)
                .durationMinutes(30)
                .title("Old Title")
                .description("Old Desc")
                .build();

        CourseModule module = CourseModule.builder()
                .id(1)
                .durationHours(2)
                .build();
        lesson.setModule(module);

        LessonEditDto dto = new LessonEditDto();
        dto.setDurationMinutes(40);
        dto.setTitle("New Title");
        dto.setDescription("New Desc");

        when(lessonRepository.findById(1)).thenReturn(Optional.of(lesson));
        when(lessonRepository.getTotalUsedMinutes(module.getId())).thenReturn(50);
        when(lessonRepository.save(any(Lesson.class))).thenAnswer(invocation -> invocation.getArgument(0));

        service.updateLesson(1, dto);

        assertEquals("New Title", lesson.getTitle());
        assertEquals("New Desc", lesson.getDescription());
        assertEquals(40, lesson.getDurationMinutes());
        verify(lessonRepository).save(lesson);
    }

    @Test
    void updateLesson_shouldThrowException_whenExceedsDurationLimit() {
        Lesson lesson = Lesson.builder()
                .id(1)
                .durationMinutes(30)
                .build();

        CourseModule module = CourseModule.builder()
                .id(1)
                .durationHours(1)
                .build();
        lesson.setModule(module);

        LessonEditDto dto = new LessonEditDto();
        dto.setDurationMinutes(51);

        when(lessonRepository.findById(1)).thenReturn(Optional.of(lesson));
        when(lessonRepository.getTotalUsedMinutes(module.getId())).thenReturn(40);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            service.updateLesson(1, dto);
        });

        assertTrue(ex.getMessage().contains("Превышено допустимое время модуля"));
        verify(lessonRepository, never()).save(any());
    }
}
