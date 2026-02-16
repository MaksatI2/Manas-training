package manasTrainingService.service.course;

import manasTrainingService.dto.ShortDto;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.teacher.CourseTeacherDTO;
import manasTrainingService.entity.*;
import manasTrainingService.repositories.course.CourseTeacherRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.impl.course.CourseTeacherServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CourseTeacherService Tests")
class CourseTeacherServiceImplTest {

    @Mock
    private CourseTeacherRepository repository;

    @Mock
    private CourseInstanceService courseInstanceService;

    @Mock
    private UserService userService;

    @Mock
    private CourseService courseService;

    @Mock
    private ActivityLogService activityLogService;

    @InjectMocks
    private CourseTeacherServiceImpl courseTeacherService;

    private User teacher;
    private Course course;
    private CourseInstanceDTO courseInstanceDTO;
    private CourseTeacher courseTeacher;
    private LocalDateTime now;

    @BeforeEach
    void setUp() {
        now = LocalDateTime.now();

        teacher = User.builder()
                .id(1)
                .name("John")
                .lastName("Doe")
                .build();

        course = Course.builder()
                .id(1)
                .title("Java Programming")
                .code("JAVA-101")
                .isActive(true)
                .build();

        courseInstanceDTO = CourseInstanceDTO.builder()
                .id(1)
                .courseId(1)
                .build();

        courseTeacher = CourseTeacher.builder()
                .id(1)
                .teacher(teacher)
                .course(course)
                .createdAt(now)
                .build();
    }

    @Test
    @DisplayName("Should get eligible teachers for course instance")
    void shouldGetEligibleTeachersForCourseInstance() {
        Integer courseInstanceId = 1;
        List<CourseTeacher> eligibleTeachers = Arrays.asList(courseTeacher);

        when(courseInstanceService.getCourseInstanceById(courseInstanceId))
                .thenReturn(courseInstanceDTO);
        when(repository.findEligibleTeachers(1, courseInstanceId))
                .thenReturn(eligibleTeachers);

        List<CourseTeacherDTO> result = courseTeacherService.getEligibleTeachersForCourseInstance(courseInstanceId);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(1);
        assertThat(result.get(0).getTeacherId()).isEqualTo(1);
        assertThat(result.get(0).getTeacherName()).isEqualTo("John Doe");
        assertThat(result.get(0).getCreatedAt()).isEqualTo(now);

        verify(courseInstanceService).getCourseInstanceById(courseInstanceId);
        verify(repository).findEligibleTeachers(1, courseInstanceId);
    }

    @Test
    @DisplayName("Should get courses by teacher ID")
    void shouldGetCoursesByTeacherId() {
        Integer teacherId = 1;
        List<CourseTeacher> courseTeachers = Arrays.asList(courseTeacher);

        when(repository.findAllByTeacherId(teacherId)).thenReturn(courseTeachers);

        List<CourseTeacherDTO> result = courseTeacherService.getCoursesByTeacherId(teacherId);

        assertThat(result).hasSize(1);
        CourseTeacherDTO dto = result.get(0);
        assertThat(dto.getId()).isEqualTo(1);
        assertThat(dto.getTeacherId()).isEqualTo(1);
        assertThat(dto.getTeacherName()).isEqualTo("John Doe");
        assertThat(dto.getCourseId()).isEqualTo(1);
        assertThat(dto.getCourseTitle()).isEqualTo("Java Programming");
        assertThat(dto.getCourseCode()).isEqualTo("JAVA-101");
        assertThat(dto.getIsActive()).isTrue();
        assertThat(dto.getAssignedAt()).isEqualTo(now);

        verify(repository).findAllByTeacherId(teacherId);
    }

    @Test
    @DisplayName("Should return empty list when teacher has no courses")
    void shouldReturnEmptyListWhenTeacherHasNoCourses() {
        Integer teacherId = 1;
        when(repository.findAllByTeacherId(teacherId)).thenReturn(Arrays.asList());

        List<CourseTeacherDTO> result = courseTeacherService.getCoursesByTeacherId(teacherId);

        assertThat(result).isEmpty();
        verify(repository).findAllByTeacherId(teacherId);
    }

    @Test
    @DisplayName("Should update teacher courses successfully")
    void shouldUpdateTeacherCoursesSuccessfully() {
        Integer teacherId = 1;
        List<Integer> courseIds = Arrays.asList(1, 2);
        List<CourseTeacher> existingCourseTeachers = Arrays.asList(courseTeacher);

        User authorizedUser = User.builder().id(10).build();
        Course course2 = Course.builder().id(2).build();

        when(repository.findAllByTeacherId(teacherId)).thenReturn(existingCourseTeachers);
        when(userService.getAuthorizedUser()).thenReturn(authorizedUser);
        when(userService.getUserById(teacherId)).thenReturn(teacher);
        when(courseService.getCourseById(1)).thenReturn(course);
        when(courseService.getCourseById(2)).thenReturn(course2);
        when(repository.save(any(CourseTeacher.class)))
                .thenReturn(CourseTeacher.builder().id(100).build())
                .thenReturn(CourseTeacher.builder().id(101).build());

        courseTeacherService.updateTeacherCourses(teacherId, courseIds);

        verify(repository).findAllByTeacherId(teacherId);
        verify(repository).deleteByTeacherId(teacherId);
        verify(repository, times(2)).save(any(CourseTeacher.class));
        verify(userService).getUserById(teacherId);
        verify(courseService).getCourseById(1);
        verify(courseService).getCourseById(2);

        verify(activityLogService).log(
                eq(authorizedUser),
                eq(ActionType.DELETE),
                eq(TargetType.COURSE_TEACHER),
                eq(1)
        );

        verify(activityLogService, times(2)).log(
                eq(authorizedUser),
                eq(ActionType.CREATE),
                eq(TargetType.COURSE_TEACHER),
                anyInt()
        );
    }

    @Test
    @DisplayName("Should handle empty course IDs list when updating teacher courses")
    void shouldHandleEmptyCourseIdsListWhenUpdatingTeacherCourses() {
        Integer teacherId = 1;
        List<Integer> emptyCourseIds = Arrays.asList();
        List<CourseTeacher> existingCourseTeachers = Arrays.asList(courseTeacher);

        User authorizedUser = User.builder().id(10).build();

        when(repository.findAllByTeacherId(teacherId)).thenReturn(existingCourseTeachers);
        when(userService.getAuthorizedUser()).thenReturn(authorizedUser);
        when(userService.getUserById(teacherId)).thenReturn(teacher);

        courseTeacherService.updateTeacherCourses(teacherId, emptyCourseIds);

        verify(repository).findAllByTeacherId(teacherId);
        verify(repository).deleteByTeacherId(teacherId);
        verify(repository, never()).save(any(CourseTeacher.class));

        verify(activityLogService).log(
                eq(authorizedUser),
                eq(ActionType.DELETE),
                eq(TargetType.COURSE_TEACHER),
                eq(1)
        );
    }

    @Test
    @DisplayName("Should get teachers by course ID")
    void shouldGetTeachersByCourseId() {
        Integer courseId = 1;
        List<CourseTeacher> courseTeachers = Arrays.asList(courseTeacher);

        when(repository.findByCourseId(courseId)).thenReturn(courseTeachers);

        List<ShortDto> result = courseTeacherService.getByCourseId(courseId);

        assertThat(result).hasSize(1);
        ShortDto dto = result.get(0);
        assertThat(dto.id()).isEqualTo(1);
        assertThat(dto.name()).isEqualTo("John");

        verify(repository).findByCourseId(courseId);
    }

    @Test
    @DisplayName("Should return empty list when course has no teachers")
    void shouldReturnEmptyListWhenCourseHasNoTeachers() {
        Integer courseId = 1;
        when(repository.findByCourseId(courseId)).thenReturn(Arrays.asList());

        List<ShortDto> result = courseTeacherService.getByCourseId(courseId);

        assertThat(result).isEmpty();
        verify(repository).findByCourseId(courseId);
    }
}