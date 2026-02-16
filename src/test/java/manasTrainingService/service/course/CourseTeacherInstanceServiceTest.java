package manasTrainingService.service.course;

import manasTrainingService.entity.CourseInstanceTeacher;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.user.UserNotFoundException;
import manasTrainingService.repositories.course.CourseInstanceTeacherRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.NotificationService;
import manasTrainingService.service.impl.course.CourseTeacherInstanceServiceImpl;
import manasTrainingService.service.test.TestService;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.context.MessageSource;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class CourseTeacherInstanceServiceTest {

    private CourseInstanceTeacherRepository repository;
    private CourseInstanceService courseInstanceService;
    private UserService userService;
    private TestService testService;
    private ActivityLogService activityLogService;
    private NotificationService notificationService;
    private MessageSource messageSource;

    private CourseTeacherInstanceServiceImpl service;

    @BeforeEach
    void setUp() {
        repository = Mockito.mock(CourseInstanceTeacherRepository.class);
        courseInstanceService = Mockito.mock(CourseInstanceService.class);
        userService = Mockito.mock(UserService.class);
        activityLogService = Mockito.mock(ActivityLogService.class);
        notificationService = Mockito.mock(NotificationService.class);
        messageSource = Mockito.mock(MessageSource.class);

        service = new CourseTeacherInstanceServiceImpl(
                repository,
                courseInstanceService,
                userService,
                activityLogService,
                notificationService,
                messageSource
        );
    }

    @Test
    void addTeachers_withExistingTeacher_expect_IllegalArgumentException() {
        Integer courseInstanceId = 1;
        Integer teacherId = 2;
        String expectedMessage = "Учитель уже был назначен на этот курс";

        // Mock the repository to return true (teacher already exists)
        when(repository.existsByCourseInstanceIdAndTeacherId(courseInstanceId, teacherId)).thenReturn(true);

        // Mock the messageSource to return the expected message
        when(messageSource.getMessage(eq("teacher.already.assigned"), isNull(), any()))
                .thenReturn(expectedMessage);

        IllegalArgumentException thrown = assertThrows(IllegalArgumentException.class, () -> {
            service.addTeachers(courseInstanceId, Collections.singletonList(teacherId));
        });

        assertEquals(expectedMessage, thrown.getMessage());
        verify(repository, never()).save(any());
    }

    @Test
    void deleteTeacher_withNonExistingTeacher_expect_UserNotFoundException() {
        Integer courseInstanceId = 1;
        Integer teacherId = 2;

        when(repository.findByCourseInstanceIdAndTeacherId(courseInstanceId, teacherId)).thenReturn(Optional.empty());

        UserNotFoundException thrown = assertThrows(UserNotFoundException.class, () -> {
            service.deleteTeacher(courseInstanceId, teacherId);
        });

        assertEquals("Назначение учителя не было найдено", thrown.getMessage());
    }

    @Test
    void getTeachersByCourseInstanceId_withOneTeacher_expectReturnDTOList() {
        Integer courseInstanceId = 1;

        User teacher = User.builder().id(2).name("John").lastName("Doe").build();
        CourseInstanceTeacher entity = CourseInstanceTeacher.builder()
                .id(3)
                .teacher(teacher)
                .isPrimary(true)
                .build();

        when(repository.findByCourseInstanceId(courseInstanceId))
                .thenReturn(Collections.singletonList(entity));

        List<?> result = service.getTeachersByCourseInstanceId(courseInstanceId);

        assertEquals(1, result.size());
    }
}