package manasTrainingService;

import manasTrainingService.dto.CourseInstanceCreationDTO;
import manasTrainingService.dto.instance.CourseInstanceUpdateDTO;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.exceptions.nsee.course.CourseNotFoundException;
import manasTrainingService.repositories.course.CourseInstanceRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.impl.course.CourseInstanceServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import java.time.LocalDate;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class CourseInstanceServiceTest {

    @Mock
    private CourseInstanceRepository courseInstanceRepository;

    @Mock
    private CourseService courseService;

    @Mock
    private LessonService lessonService;

    @Mock
    private UserService userService;
    @Mock
    private ActivityLogService activityLogService;

    @InjectMocks
    private CourseInstanceServiceImpl service;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void createCourseInstance_shouldReturnId() {
        CourseInstanceCreationDTO dto = new CourseInstanceCreationDTO();
        dto.setCourseId(1);
        dto.setTitle("Test Course Instance");
        dto.setStartDate(LocalDate.of(2025, 6, 26));
        dto.setEndDate(LocalDate.of(2025, 7, 26));
        dto.setIsActive(true);

        Course course = Course.builder()
                .id(1)
                .durationHours(100)
                .build();

        when(courseService.getCourseById(1)).thenReturn(course);
        when(courseInstanceRepository.save(any(CourseInstance.class)))
                .thenAnswer(invocation -> {
                    CourseInstance ci = invocation.getArgument(0);
                    ci.setId(42);
                    return ci;
                });

        Integer resultId = service.createCourseInstance(dto);

        assertEquals(42, resultId);
        verify(courseInstanceRepository).save(any(CourseInstance.class));
    }

    @Test
    void updateCourseInstance_shouldUpdateFields() {
        Integer instanceId = 1;
        CourseInstance instance = CourseInstance.builder()
                .id(instanceId)
                .title("Old Title")
                .startDate(LocalDate.of(2025, 1, 1).atStartOfDay())
                .endDate(LocalDate.of(2025, 2, 1).atStartOfDay())
                .isActive(false)
                .build();

        CourseInstanceUpdateDTO updateDTO = CourseInstanceUpdateDTO.builder()
                .id(instanceId)
                .title("New Title")
                .startDate(LocalDate.of(2025, 6, 1))
                .endDate(LocalDate.of(2025, 6, 30))
                .isActive(true)
                .build();

        when(courseInstanceRepository.findById(instanceId)).thenReturn(Optional.of(instance));
        when(courseInstanceRepository.save(any(CourseInstance.class))).thenAnswer(i -> i.getArgument(0));

        service.updateCourseInstance(instanceId, updateDTO);

        assertEquals("New Title", instance.getTitle());
        assertEquals(LocalDate.of(2025, 6, 1).atStartOfDay(), instance.getStartDate());
        assertEquals(LocalDate.of(2025, 6, 30).atTime(23, 59), instance.getEndDate());
        assertTrue(instance.getIsActive());
        assertNotNull(instance.getUpdatedAt());

        verify(courseInstanceRepository).save(instance);
    }

    @Test
    void updateCourseInstance_shouldThrow_ifNotFound() {
        when(courseInstanceRepository.findById(anyInt())).thenReturn(Optional.empty());

        CourseInstanceUpdateDTO updateDTO = CourseInstanceUpdateDTO.builder()
                .id(1)
                .title("New Title")
                .startDate(LocalDate.now())
                .endDate(LocalDate.now())
                .isActive(true)
                .build();

        assertThrows(CourseNotFoundException.class, () -> service.updateCourseInstance(1, updateDTO));
    }

    @Test
    void deleteCourseInstance_shouldDelete_ifNoModules() {
        Integer instanceId = 1;
        CourseInstance instance = CourseInstance.builder()
                .id(instanceId)
                .modules(new java.util.ArrayList<>())
                .build();

        when(courseInstanceRepository.findById(instanceId)).thenReturn(Optional.of(instance));

        service.deleteCourseInstance(instanceId);

        verify(courseInstanceRepository).deleteById(instanceId);
    }

    @Test
    void deleteCourseInstance_shouldThrow_ifHasModules() {
        Integer instanceId = 1;
        CourseInstance instance = CourseInstance.builder()
                .id(instanceId)
                .modules(java.util.List.of(CourseModule.builder().id(1).build()))
                .build();

        when(courseInstanceRepository.findById(instanceId)).thenReturn(Optional.of(instance));

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            service.deleteCourseInstance(instanceId);
        });
        assertEquals("Невозможно удаление курса, у него есть модули", ex.getMessage());

        verify(courseInstanceRepository, never()).deleteById(anyInt());
    }

    @Test
    void deleteCourseInstance_shouldThrow_ifNotFound() {
        when(courseInstanceRepository.findById(anyInt())).thenReturn(Optional.empty());

        assertThrows(CourseNotFoundException.class, () -> service.deleteCourseInstance(1));
    }
}
