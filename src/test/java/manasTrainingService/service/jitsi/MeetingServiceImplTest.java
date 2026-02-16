package manasTrainingService.service.jitsi;

import manasTrainingService.dto.jitsi.EndMeetingRequestDTO;
import manasTrainingService.dto.jitsi.MeetingResponseDTO;
import manasTrainingService.dto.jitsi.StartMeetingRequestDTO;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.ScheduleNotFouneException;
import manasTrainingService.exceptions.nsee.jitsi.MeetingAccessDeniedException;
import manasTrainingService.exceptions.nsee.jitsi.MeetingAlreadyActiveException;
import manasTrainingService.exceptions.nsee.jitsi.MeetingEndedException;
import manasTrainingService.exceptions.nsee.jitsi.MeetingNotFoundException;
import manasTrainingService.repositories.ScheduleRepository;
import manasTrainingService.repositories.jitsi.MeetingParticipantRepository;
import manasTrainingService.repositories.jitsi.MeetingRepository;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.impl.jitsi.MeetingServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MeetingServiceImplTest {

    @Mock
    private MeetingRepository meetingRepository;

    @Mock
    private MeetingParticipantRepository meetingParticipantRepository;

    @Mock
    private ScheduleRepository scheduleRepository;

    @Mock
    private UserService userService;

    @Mock
    private EnrollmentService enrollmentService;

    @Mock
    private SimpMessagingTemplate messagingTemplate;

    @InjectMocks
    private MeetingServiceImpl meetingService;

    private Schedule schedule;
    private User teacher;
    private CourseInstance courseInstance;

    @BeforeEach
    void setUp() {
        teacher = User.builder()
                .id(1)
                .name("John")
                .lastName("Doe")
                .build();

        courseInstance = CourseInstance.builder()
                .id(1)
                .course(Course.builder().id(1).title("Test Course").build())
                .build();

        Lesson lesson = Lesson.builder()
                .id(1)
                .title("Test Lesson")
                .build();

        schedule = Schedule.builder()
                .id(1)
                .title("Test Lesson")
                .teacher(teacher)
                .courseInstance(courseInstance)
                .lesson(lesson)
                .lessonDate(LocalDate.now())
                .build();
    }

    @Test
    void startMeeting_ScheduleNotFound_ThrowsException() {
        StartMeetingRequestDTO request = StartMeetingRequestDTO.builder()
                .scheduleId(1)
                .teacherId(1)
                .build();

        when(scheduleRepository.findById(1)).thenReturn(Optional.empty());

        assertThrows(ScheduleNotFouneException.class, () -> {
            meetingService.startMeeting(request);
        });
    }

    @Test
    void startMeeting_NotTeacher_ThrowsException() {
        StartMeetingRequestDTO request = StartMeetingRequestDTO.builder()
                .scheduleId(1)
                .teacherId(2)
                .build();

        when(scheduleRepository.findById(1)).thenReturn(Optional.of(schedule));
        when(userService.getUserById(2)).thenReturn(User.builder().id(2).build());

        assertThrows(MeetingAccessDeniedException.class, () -> {
            meetingService.startMeeting(request);
        });
    }

    @Test
    void startMeeting_MeetingAlreadyActive_ThrowsException() {
        StartMeetingRequestDTO request = StartMeetingRequestDTO.builder()
                .scheduleId(1)
                .teacherId(1)
                .build();

        when(scheduleRepository.findById(1)).thenReturn(Optional.of(schedule));
        when(userService.getUserById(1)).thenReturn(teacher);
        when(meetingRepository.existsByScheduleIdAndEndedAtIsNull(1)).thenReturn(true);

        assertThrows(MeetingAlreadyActiveException.class, () -> {
            meetingService.startMeeting(request);
        });
    }

    @Test
    void startMeeting_ValidRequest_CreatesMeeting() {
        StartMeetingRequestDTO request = StartMeetingRequestDTO.builder()
                .scheduleId(1)
                .teacherId(1)
                .build();

        when(scheduleRepository.findById(1)).thenReturn(Optional.of(schedule));
        when(userService.getUserById(1)).thenReturn(teacher);
        when(meetingRepository.existsByScheduleIdAndEndedAtIsNull(1)).thenReturn(false);
        when(meetingRepository.save(any(Meeting.class))).thenAnswer(invocation -> {
            Meeting meeting = invocation.getArgument(0);
            meeting.setId(1);
            return meeting;
        });

        MeetingResponseDTO result = meetingService.startMeeting(request);

        assertNotNull(result);
        assertEquals("Test Lesson", result.getLessonTitle());
        assertEquals("John Doe", result.getTeacherName());
        assertEquals("ACTIVE", result.getStatus());
        verify(meetingParticipantRepository, times(1)).save(any());
    }

    @Test
    void endMeeting_MeetingNotFound_ThrowsException() {
        EndMeetingRequestDTO request = EndMeetingRequestDTO.builder()
                .meetingId(1)
                .teacherId(1)
                .build();

        when(meetingRepository.findById(1)).thenReturn(Optional.empty());

        assertThrows(MeetingNotFoundException.class, () -> {
            meetingService.endMeeting(request);
        });
    }

    @Test
    void endMeeting_NotTeacher_ThrowsException() {
        Meeting meeting = Meeting.builder()
                .id(1)
                .schedule(schedule)
                .build();

        EndMeetingRequestDTO request = EndMeetingRequestDTO.builder()
                .meetingId(1)
                .teacherId(2)
                .build();

        when(meetingRepository.findById(1)).thenReturn(Optional.of(meeting));

        assertThrows(MeetingAccessDeniedException.class, () -> {
            meetingService.endMeeting(request);
        });
    }

    @Test
    void endMeeting_AlreadyEnded_ThrowsException() {
        Meeting meeting = Meeting.builder()
                .id(1)
                .schedule(schedule)
                .endedAt(LocalDateTime.now())
                .build();

        EndMeetingRequestDTO request = EndMeetingRequestDTO.builder()
                .meetingId(1)
                .teacherId(1)
                .build();

        when(meetingRepository.findById(1)).thenReturn(Optional.of(meeting));

        assertThrows(MeetingEndedException.class, () -> {
            meetingService.endMeeting(request);
        });
    }

    @Test
    void endMeeting_ValidRequest_EndsMeeting() {
        Meeting meeting = Meeting.builder()
                .id(1)
                .schedule(schedule)
                .startedAt(LocalDateTime.now().minusHours(1))
                .build();

        EndMeetingRequestDTO request = EndMeetingRequestDTO.builder()
                .meetingId(1)
                .teacherId(1)
                .build();

        when(meetingRepository.findById(1)).thenReturn(Optional.of(meeting));
        when(meetingParticipantRepository.findActiveMeetingParticipants(1))
                .thenReturn(List.of());

        assertDoesNotThrow(() -> {
            meetingService.endMeeting(request);
        });

        assertNotNull(meeting.getEndedAt());
    }

    @Test
    void canUserAccessMeeting_Admin_ReturnsTrue() {
        Meeting meeting = Meeting.builder()
                .id(1)
                .schedule(schedule)
                .build();

        when(meetingRepository.findById(1)).thenReturn(Optional.of(meeting));

        boolean result = meetingService.canUserAccessMeeting(999, "ADMIN", 1);

        assertTrue(result);
    }

    @Test
    void canUserAccessMeeting_Teacher_ReturnsTrueForOwnMeeting() {
        Meeting meeting = Meeting.builder()
                .id(1)
                .schedule(schedule)
                .build();

        when(meetingRepository.findById(1)).thenReturn(Optional.of(meeting));

        boolean result = meetingService.canUserAccessMeeting(1, "TEACHER", 1);

        assertTrue(result);
    }

    @Test
    void canUserAccessMeeting_StudentEnrolled_ReturnsTrue() {
        Meeting meeting = Meeting.builder()
                .id(1)
                .schedule(schedule)
                .build();

        CourseEnrollment enrollment = CourseEnrollment.builder()
                .student(User.builder().id(2).build())
                .build();

        when(meetingRepository.findById(1)).thenReturn(Optional.of(meeting));
        when(enrollmentService.findAllEnrollmentsForCourseInstance(1))
                .thenReturn(List.of(enrollment));

        boolean result = meetingService.canUserAccessMeeting(2, "STUDENT", 1);

        assertTrue(result);
    }
}