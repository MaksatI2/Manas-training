package manasTrainingService.service.course;

import manasTrainingService.dto.statistics.AttendanceStatsDTO;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.User;
import manasTrainingService.service.AttendanceService;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.impl.course.CourseInstanceStatisticsServiceImpl;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.util.StatusUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CourseInstanceStatisticsService Tests")
class CourseInstanceStatisticsServiceImplTest {

    @Mock
    private EnrollmentService enrollmentService;

    @Mock
    private AttendanceService attendanceService;

    @Mock
    private TestResultService testResultService;

    @InjectMocks
    private CourseInstanceStatisticsServiceImpl courseInstanceStatisticsService;

    private CourseInstance courseInstance;
    private Course course;
    private User student1;
    private User student2;
    private CourseEnrollment enrollment1;
    private CourseEnrollment enrollment2;

    @BeforeEach
    void setUp() {
        course = Course.builder()
                .id(1)
                .title("Java Programming")
                .code("JAVA-101")
                .durationHours(40)
                .build();

        courseInstance = CourseInstance.builder()
                .id(1)
                .course(course)
                .course(course)
                .build();

        student1 = User.builder()
                .id(1)
                .name("John")
                .lastName("Doe")
                .build();

        student2 = User.builder()
                .id(2)
                .name("Jane")
                .lastName("Smith")
                .build();

        enrollment1 = CourseEnrollment.builder()
                .id(1)
                .student(student1)
                .courseInstance(courseInstance)
                .status(Status.ACTIVE)
                .build();

        enrollment2 = CourseEnrollment.builder()
                .id(2)
                .student(student2)
                .courseInstance(courseInstance)
                .status(Status.COMPLETED)
                .build();
    }

    @Test
    @DisplayName("Should get attendance statistics for course instance")
    void shouldGetAttendanceStatisticsForCourseInstance() {
        List<CourseEnrollment> enrollments = Arrays.asList(enrollment1, enrollment2);

        when(enrollmentService.findAllEnrollmentsForCourseInstance(courseInstance.getId()))
                .thenReturn(enrollments);
        when(attendanceService.sumAbsentHoursByStudentAndCourseInstance(student1.getId(), courseInstance.getId()))
                .thenReturn(5);
        when(attendanceService.sumAbsentHoursByStudentAndCourseInstance(student2.getId(), courseInstance.getId()))
                .thenReturn(2);

        try (MockedStatic<StatusUtil> statusUtilMock = mockStatic(StatusUtil.class)) {
            statusUtilMock.when(() -> StatusUtil.localize(Status.ACTIVE)).thenReturn("Активный");
            statusUtilMock.when(() -> StatusUtil.localize(Status.COMPLETED)).thenReturn("Завершен");

            List<AttendanceStatsDTO> result = courseInstanceStatisticsService
                    .getAttendanceStatsByCourseInstance(courseInstance);

            assertThat(result).hasSize(2);

            AttendanceStatsDTO stats1 = result.get(0);
            assertThat(stats1.getCourseInstance()).isEqualTo(courseInstance);
            assertThat(stats1.getTotalHours()).isEqualTo(40);
            assertThat(stats1.getAbsentHours()).isEqualTo(5);
            assertThat(stats1.getStudent()).isEqualTo(student1);

            AttendanceStatsDTO stats2 = result.get(1);
            assertThat(stats2.getCourseInstance()).isEqualTo(courseInstance);
            assertThat(stats2.getTotalHours()).isEqualTo(40);
            assertThat(stats2.getAbsentHours()).isEqualTo(2);
            assertThat(stats2.getStudent()).isEqualTo(student2);

            verify(enrollmentService).findAllEnrollmentsForCourseInstance(courseInstance.getId());
            verify(attendanceService).sumAbsentHoursByStudentAndCourseInstance(student1.getId(), courseInstance.getId());
            verify(attendanceService).sumAbsentHoursByStudentAndCourseInstance(student2.getId(), courseInstance.getId());
        }
    }

    @Test
    @DisplayName("Should handle null absent hours correctly")
    void shouldHandleNullAbsentHoursCorrectly() {
        List<CourseEnrollment> enrollments = Arrays.asList(enrollment1);

        when(enrollmentService.findAllEnrollmentsForCourseInstance(courseInstance.getId()))
                .thenReturn(enrollments);
        when(attendanceService.sumAbsentHoursByStudentAndCourseInstance(student1.getId(), courseInstance.getId()))
                .thenReturn(null);

        try (MockedStatic<StatusUtil> statusUtilMock = mockStatic(StatusUtil.class)) {
            statusUtilMock.when(() -> StatusUtil.localize(Status.ACTIVE)).thenReturn("Активный");

            List<AttendanceStatsDTO> result = courseInstanceStatisticsService
                    .getAttendanceStatsByCourseInstance(courseInstance);

            assertThat(result).hasSize(1);
            AttendanceStatsDTO stats = result.get(0);
            assertThat(stats.getAbsentHours()).isEqualTo(0);

            verify(attendanceService).sumAbsentHoursByStudentAndCourseInstance(student1.getId(), courseInstance.getId());
        }
    }

    @Test
    @DisplayName("Should return empty list when no enrollments found")
    void shouldReturnEmptyListWhenNoEnrollmentsFound() {
        when(enrollmentService.findAllEnrollmentsForCourseInstance(courseInstance.getId()))
                .thenReturn(Arrays.asList());

        List<AttendanceStatsDTO> result = courseInstanceStatisticsService
                .getAttendanceStatsByCourseInstance(courseInstance);

        assertThat(result).isEmpty();
        verify(enrollmentService).findAllEnrollmentsForCourseInstance(courseInstance.getId());
        verifyNoInteractions(attendanceService);
    }

    @Test
    @DisplayName("Should handle multiple students with different statuses")
    void shouldHandleMultipleStudentsWithDifferentStatuses() {
        User student3 = User.builder()
                .id(3)
                .name("Bob")
                .lastName("Johnson")
                .build();

        CourseEnrollment enrollment3 = CourseEnrollment.builder()
                .id(3)
                .student(student3)
                .courseInstance(courseInstance)
                .status(Status.PENDING)
                .build();

        List<CourseEnrollment> enrollments = Arrays.asList(enrollment1, enrollment2, enrollment3);

        when(enrollmentService.findAllEnrollmentsForCourseInstance(courseInstance.getId()))
                .thenReturn(enrollments);
        when(attendanceService.sumAbsentHoursByStudentAndCourseInstance(student1.getId(), courseInstance.getId()))
                .thenReturn(10);
        when(attendanceService.sumAbsentHoursByStudentAndCourseInstance(student2.getId(), courseInstance.getId()))
                .thenReturn(0);
        when(attendanceService.sumAbsentHoursByStudentAndCourseInstance(student3.getId(), courseInstance.getId()))
                .thenReturn(15);

        try (MockedStatic<StatusUtil> statusUtilMock = mockStatic(StatusUtil.class)) {
            statusUtilMock.when(() -> StatusUtil.localize(Status.ACTIVE)).thenReturn("Активный");
            statusUtilMock.when(() -> StatusUtil.localize(Status.COMPLETED)).thenReturn("Завершен");
            statusUtilMock.when(() -> StatusUtil.localize(Status.PENDING)).thenReturn("Ожидание");

            List<AttendanceStatsDTO> result = courseInstanceStatisticsService
                    .getAttendanceStatsByCourseInstance(courseInstance);

            assertThat(result).hasSize(3);

            AttendanceStatsDTO stats1 = result.get(0);
            assertThat(stats1.getStudent().getId()).isEqualTo(1);
            assertThat(stats1.getAbsentHours()).isEqualTo(10);

            AttendanceStatsDTO stats2 = result.get(1);
            assertThat(stats2.getStudent().getId()).isEqualTo(2);
            assertThat(stats2.getAbsentHours()).isEqualTo(0);

            AttendanceStatsDTO stats3 = result.get(2);
            assertThat(stats3.getStudent().getId()).isEqualTo(3);
            assertThat(stats3.getAbsentHours()).isEqualTo(15);

            verify(enrollmentService).findAllEnrollmentsForCourseInstance(courseInstance.getId());
            verify(attendanceService).sumAbsentHoursByStudentAndCourseInstance(student1.getId(), courseInstance.getId());
            verify(attendanceService).sumAbsentHoursByStudentAndCourseInstance(student2.getId(), courseInstance.getId());
            verify(attendanceService).sumAbsentHoursByStudentAndCourseInstance(student3.getId(), courseInstance.getId());
        }
    }

    @Test
    @DisplayName("Should handle zero absent hours")
    void shouldHandleZeroAbsentHours() {
        List<CourseEnrollment> enrollments = Arrays.asList(enrollment1);

        when(enrollmentService.findAllEnrollmentsForCourseInstance(courseInstance.getId()))
                .thenReturn(enrollments);
        when(attendanceService.sumAbsentHoursByStudentAndCourseInstance(student1.getId(), courseInstance.getId()))
                .thenReturn(0);

        try (MockedStatic<StatusUtil> statusUtilMock = mockStatic(StatusUtil.class)) {
            statusUtilMock.when(() -> StatusUtil.localize(Status.ACTIVE)).thenReturn("Активный");

            List<AttendanceStatsDTO> result = courseInstanceStatisticsService
                    .getAttendanceStatsByCourseInstance(courseInstance);

            assertThat(result).hasSize(1);
            AttendanceStatsDTO stats = result.get(0);
            assertThat(stats.getAbsentHours()).isEqualTo(0);
            assertThat(stats.getTotalHours()).isEqualTo(40);
            assertThat(stats.getStudent()).isEqualTo(student1);

            verify(attendanceService).sumAbsentHoursByStudentAndCourseInstance(student1.getId(), courseInstance.getId());
        }
    }

    @Test
    @DisplayName("Should verify all DTO fields are populated correctly")
    void shouldVerifyAllDtoFieldsArePopulatedCorrectly() {
        List<CourseEnrollment> enrollments = Arrays.asList(enrollment1);

        when(enrollmentService.findAllEnrollmentsForCourseInstance(courseInstance.getId()))
                .thenReturn(enrollments);
        when(attendanceService.sumAbsentHoursByStudentAndCourseInstance(student1.getId(), courseInstance.getId()))
                .thenReturn(8);

        try (MockedStatic<StatusUtil> statusUtilMock = mockStatic(StatusUtil.class)) {
            statusUtilMock.when(() -> StatusUtil.localize(Status.ACTIVE)).thenReturn("Активный");

            List<AttendanceStatsDTO> result = courseInstanceStatisticsService
                    .getAttendanceStatsByCourseInstance(courseInstance);

            assertThat(result).hasSize(1);
            AttendanceStatsDTO stats = result.get(0);

            assertThat(stats.getCourseInstance()).isNotNull();
            assertThat(stats.getCourseInstance().getId()).isEqualTo(1);
            assertThat(stats.getTotalHours()).isEqualTo(40);
            assertThat(stats.getAbsentHours()).isEqualTo(8);
            assertThat(stats.getStudent()).isNotNull();
            assertThat(stats.getStudent().getId()).isEqualTo(1);
            assertThat(stats.getStudent().getName()).isEqualTo("John");

            statusUtilMock.verify(() -> StatusUtil.localize(Status.ACTIVE));
        }
    }

    @Test
    @DisplayName("Should call services with correct parameters")
    void shouldCallServicesWithCorrectParameters() {
        List<CourseEnrollment> enrollments = Arrays.asList(enrollment1, enrollment2);

        when(enrollmentService.findAllEnrollmentsForCourseInstance(courseInstance.getId()))
                .thenReturn(enrollments);
        when(attendanceService.sumAbsentHoursByStudentAndCourseInstance(anyInt(), anyInt()))
                .thenReturn(5);

        try (MockedStatic<StatusUtil> statusUtilMock = mockStatic(StatusUtil.class)) {
            statusUtilMock.when(() -> StatusUtil.localize(any(Status.class))).thenReturn("Локализованный статус");

            courseInstanceStatisticsService.getAttendanceStatsByCourseInstance(courseInstance);

            verify(enrollmentService).findAllEnrollmentsForCourseInstance(eq(1));
            verify(attendanceService).sumAbsentHoursByStudentAndCourseInstance(eq(1), eq(1));
            verify(attendanceService).sumAbsentHoursByStudentAndCourseInstance(eq(2), eq(1));
            statusUtilMock.verify(() -> StatusUtil.localize(Status.ACTIVE));
            statusUtilMock.verify(() -> StatusUtil.localize(Status.COMPLETED));
        }
    }
}