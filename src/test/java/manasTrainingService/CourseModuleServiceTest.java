package manasTrainingService;

import manasTrainingService.dto.instance.*;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.ModuleNotFoundException;
import manasTrainingService.repositories.course.CourseModuleRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.impl.course.CourseModuleServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.context.MessageSource;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class CourseModuleServiceTest {

    private CourseModuleRepository courseModuleRepository;
    private CourseInstanceService courseInstanceService;
    private ActivityLogService activityLogService;
    private UserService userService;
    private MessageSource messageSource;

    private CourseModuleServiceImpl service;

    @BeforeEach
    void setUp() {
        courseModuleRepository = mock(CourseModuleRepository.class);
        courseInstanceService = mock(CourseInstanceService.class);
        activityLogService = mock(ActivityLogService.class);
        userService = mock(UserService.class);
        messageSource = mock(MessageSource.class);
        service = new CourseModuleServiceImpl(courseModuleRepository, courseInstanceService, activityLogService, userService, messageSource);
    }

    @Test
    void createCourseModules_shouldSaveNewModules() {
        Integer courseInstanceId = 1;

        CourseInstance courseInstance = CourseInstance.builder()
                .id(courseInstanceId)
                .modules(new ArrayList<>())
                .course(Course.builder().durationHours(100).build())
                .build();

        List<CourseModuleCreationDTO> dtos = Arrays.asList(
                CourseModuleCreationDTO.builder().title("Модуль 1").durationHours(10).description("Описание").build(),
                CourseModuleCreationDTO.builder().title("Модуль 2").durationHours(20).description("Описание").build()
        );

        when(courseInstanceService.getCourseInstanceModelById(courseInstanceId)).thenReturn(courseInstance);

        service.createCourseModules(courseInstanceId, dtos);

        ArgumentCaptor<List<CourseModule>> captor = ArgumentCaptor.forClass(List.class);
        verify(courseModuleRepository).saveAll(captor.capture());

        List<CourseModule> savedModules = captor.getValue();
        assertEquals(2, savedModules.size());

        assertEquals("Модуль 1", savedModules.get(0).getTitle());
        assertEquals(10, savedModules.get(0).getDurationHours());
        assertEquals(courseInstance, savedModules.get(0).getCourseInstance());

        assertEquals("Модуль 2", savedModules.get(1).getTitle());
        assertEquals(20, savedModules.get(1).getDurationHours());
    }

    @Test
    void createCourseModules_shouldThrowIfTotalDurationExceeds() {
        Integer courseInstanceId = 1;

        CourseInstance courseInstance = CourseInstance.builder()
                .id(courseInstanceId)
                .modules(Arrays.asList(
                        CourseModule.builder().durationHours(90).orderIndex(0).build()
                ))
                .course(Course.builder().durationHours(100).build())
                .build();

        List<CourseModuleCreationDTO> dtos = Collections.singletonList(
                CourseModuleCreationDTO.builder().title("Слишком много").durationHours(20).build()
        );

        when(courseInstanceService.getCourseInstanceModelById(courseInstanceId)).thenReturn(courseInstance);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () -> {
            service.createCourseModules(courseInstanceId, dtos);
        });

        assertTrue(ex.getMessage().contains("Общее количество часов модулей"));
    }

    @Test
    void deleteCourseModule_shouldDeleteIfExists() {
        Integer moduleId = 5;
        when(courseModuleRepository.existsById(moduleId)).thenReturn(true);

        service.deleteCourseModule(moduleId);

        verify(courseModuleRepository).deleteById(moduleId);
    }

    @Test
    void deleteCourseModule_shouldThrowIfNotExists() {
        Integer moduleId = 5;
        when(courseModuleRepository.existsById(moduleId)).thenReturn(false);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            service.deleteCourseModule(moduleId);
        });

        assertTrue(ex.getMessage().contains("Модуль не был найден"));
        verify(courseModuleRepository, never()).deleteById(any());
    }

    @Test
    void getCourseModuleById_shouldReturnModuleOrThrow() {
        Integer moduleId = 3;
        CourseModule module = CourseModule.builder().id(moduleId).build();

        when(courseModuleRepository.findById(moduleId)).thenReturn(Optional.of(module));
        assertEquals(module, service.getCourseModuleById(moduleId));

        when(courseModuleRepository.findById(moduleId)).thenReturn(Optional.empty());
        assertThrows(ModuleNotFoundException.class, () -> service.getCourseModuleById(moduleId));
    }

    @Test
    void deleteByIdIfNoLessons_shouldDeleteOrThrow() {
        Integer moduleId = 1;

        CourseModule moduleWithLessons = CourseModule.builder()
                .id(moduleId)
                .lessons(Collections.singletonList(new Lesson()))
                .build();

        CourseModule moduleWithoutLessons = CourseModule.builder()
                .id(moduleId)
                .lessons(Collections.emptyList())
                .build();

        when(courseModuleRepository.findById(moduleId)).thenReturn(Optional.of(moduleWithLessons));
        assertThrows(IllegalStateException.class, () -> service.deleteByIdIfNoLessons(moduleId));
        verify(courseModuleRepository, never()).deleteById(any());

        when(courseModuleRepository.findById(moduleId)).thenReturn(Optional.of(moduleWithoutLessons));
        service.deleteByIdIfNoLessons(moduleId);
        verify(courseModuleRepository).deleteById(moduleId);
    }

    @Test
    void getModuleForUpdate_shouldReturnDTO() {
        Integer moduleId = 1;
        CourseModule module = CourseModule.builder()
                .title("Название")
                .durationHours(4)
                .description("Описание")
                .build();

        when(courseModuleRepository.findById(moduleId)).thenReturn(Optional.of(module));

        CourseModuleUpdateDTO dto = service.getModuleForUpdate(moduleId);

        assertEquals("Название", dto.getTitle());
        assertEquals(4, dto.getDurationHours());
        assertEquals("Описание", dto.getDescription());
    }

    @Test
    void updateModule_shouldUpdateCorrectly() {
        Integer moduleId = 1;

        Schedule schedule1 = Schedule.builder().durationHours(1).build();
        Schedule schedule2 = Schedule.builder().durationHours(2).build();

        Lesson lesson1 = Lesson.builder().schedules(List.of(schedule1)).build();
        Lesson lesson2 = Lesson.builder().schedules(List.of(schedule2)).build();

        CourseInstance courseInstance = CourseInstance.builder()
                .course(Course.builder().durationHours(100).build())
                .modules(new ArrayList<>())
                .build();

        CourseModule module = CourseModule.builder()
                .id(moduleId)
                .courseInstance(courseInstance)
                .lessons(List.of(lesson1, lesson2))
                .durationHours(3)
                .build();

        courseInstance.getModules().add(module);

        CourseModuleUpdateDTO updateDTO = new CourseModuleUpdateDTO();
        updateDTO.setTitle("Обновленное название");
        updateDTO.setDurationHours(1);
        updateDTO.setDescription("Обновленное описание");

        when(courseModuleRepository.findById(moduleId)).thenReturn(Optional.of(module));
        when(courseModuleRepository.save(any(CourseModule.class))).thenAnswer(invocation -> invocation.getArgument(0));


        IllegalStateException ex = assertThrows(IllegalStateException.class, () -> {
            service.updateModule(moduleId, updateDTO);
        });

        assertTrue(ex.getMessage().contains("меньше общей длительности всех расписаний"));

        updateDTO.setDurationHours(3);

        CourseModule otherModule = CourseModule.builder().id(2).durationHours(98).build();
        courseInstance.getModules().add(otherModule);

        IllegalStateException ex2 = assertThrows(IllegalStateException.class, () -> {
            service.updateModule(moduleId, updateDTO);
        });
        assertTrue(ex2.getMessage().contains("Общее количество часов модулей"));

        otherModule.setDurationHours(90);
        updateDTO.setDurationHours(3);

        service.updateModule(moduleId, updateDTO);

        ArgumentCaptor<CourseModule> captor = ArgumentCaptor.forClass(CourseModule.class);
        verify(courseModuleRepository).save(captor.capture());

        CourseModule saved = captor.getValue();
        assertEquals("Обновленное название", saved.getTitle());
        assertEquals(3, saved.getDurationHours());
        assertEquals("Обновленное описание", saved.getDescription());
    }


    @Test
    void updateModule_shouldThrowWhenDurationLessThanScheduleTotal() {
        Integer moduleId = 1;

        Lesson lesson1 = Lesson.builder().schedules(List.of(
                Schedule.builder().durationHours(2).build()
        )).build();

        Lesson lesson2 = Lesson.builder().schedules(List.of(
                Schedule.builder().durationHours(1).build()
        )).build();

        CourseModule module = CourseModule.builder()
                .id(moduleId)
                .durationHours(5)
                .lessons(List.of(lesson1, lesson2))
                .courseInstance(CourseInstance.builder()
                        .modules(Collections.emptyList())
                        .course(Course.builder().durationHours(10).build())
                        .build())
                .build();

        when(courseModuleRepository.findById(moduleId)).thenReturn(Optional.of(module));

        CourseModuleUpdateDTO updateDTO = new CourseModuleUpdateDTO();
        updateDTO.setDurationHours(2);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () -> {
            service.updateModule(moduleId, updateDTO);
        });

        assertTrue(ex.getMessage().contains("так как она меньше общей длительности всех расписаний"));
    }



}
