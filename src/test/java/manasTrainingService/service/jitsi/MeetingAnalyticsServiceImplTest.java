package manasTrainingService.service.jitsi;

import manasTrainingService.dto.jitsi.MeetingAnalyticsDTO;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.jitsi.MeetingNotFoundException;
import manasTrainingService.repositories.jitsi.MeetingParticipantRepository;
import manasTrainingService.repositories.jitsi.MeetingRepository;
import manasTrainingService.repositories.jitsi.ParticipantPingRepository;
import manasTrainingService.service.impl.jitsi.MeetingAnalyticsServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MeetingAnalyticsServiceImplTest {

    @Mock
    private MeetingRepository meetingRepository;

    @Mock
    private MeetingParticipantRepository participantRepository;

    @Mock
    private ParticipantPingRepository pingRepository;

    @InjectMocks
    private MeetingAnalyticsServiceImpl meetingAnalyticsService;

    private Meeting meeting;
    private Schedule schedule;
    private User teacher;
    private List<MeetingParticipant> participants;

    @BeforeEach
    void setUp() {
        teacher = User.builder()
                .id(1)
                .name("John")
                .lastName("Doe")
                .build();

        schedule = Schedule.builder()
                .id(1)
                .title("Test Lesson")
                .teacher(teacher)
                .build();

        meeting = Meeting.builder()
                .id(1)
                .schedule(schedule)
                .startedAt(LocalDateTime.now().minusHours(1))
                .endedAt(LocalDateTime.now())
                .build();

        participants = Arrays.asList(
                MeetingParticipant.builder()
                        .id(1)
                        .meeting(meeting)
                        .user(User.builder().id(2).name("Student").lastName("One").build())
                        .participantName("Student One")
                        .joinedAt(LocalDateTime.now().minusHours(1))
                        .isModerator(false)
                        .build(),
                MeetingParticipant.builder()
                        .id(2)
                        .meeting(meeting)
                        .user(teacher)
                        .participantName("John Doe")
                        .joinedAt(LocalDateTime.now().minusHours(1))
                        .isModerator(true)
                        .build()
        );
    }

    @Test
    void getMeetingAnalytics_MeetingNotFound_ThrowsException() {
        when(meetingRepository.findById(anyInt())).thenReturn(Optional.empty());

        assertThrows(MeetingNotFoundException.class, () -> {
            meetingAnalyticsService.getMeetingAnalytics(1);
        });
    }

    @Test
    void getMeetingAnalytics_ValidMeeting_ReturnsAnalytics() {
        when(meetingRepository.findById(1)).thenReturn(Optional.of(meeting));
        when(participantRepository.findAllByMeetingId(1)).thenReturn(participants);
        when(pingRepository.findByMeetingParticipantIdOrderByPingTimeDesc(anyInt()))
                .thenReturn(Collections.emptyList());

        MeetingAnalyticsDTO result = meetingAnalyticsService.getMeetingAnalytics(1);

        assertNotNull(result);
        assertEquals(1, result.getMeetingId());
        assertEquals("Test Lesson", result.getLessonTitle());
        assertEquals("John Doe", result.getTeacherName());
        assertEquals(2, result.getTotalParticipants());
        assertEquals(2, result.getParticipantAnalytics().size());
    }

    @Test
    void getScheduleAnalytics_MeetingNotFound_ThrowsException() {
        when(meetingRepository.findByScheduleId(anyInt())).thenReturn(Optional.empty());

        assertThrows(MeetingNotFoundException.class, () -> {
            meetingAnalyticsService.getScheduleAnalytics(1);
        });
    }

    @Test
    void getScheduleAnalytics_ValidSchedule_ReturnsAnalytics() {
        when(meetingRepository.findByScheduleId(1)).thenReturn(Optional.of(meeting));
        when(participantRepository.findAllByMeetingId(1)).thenReturn(participants);
        when(pingRepository.findByMeetingParticipantIdOrderByPingTimeDesc(anyInt()))
                .thenReturn(Collections.emptyList());

        MeetingAnalyticsDTO result = meetingAnalyticsService.getScheduleAnalytics(1);

        assertNotNull(result);
        assertEquals(1, result.getMeetingId());
        assertEquals("Test Lesson", result.getLessonTitle());
    }

}