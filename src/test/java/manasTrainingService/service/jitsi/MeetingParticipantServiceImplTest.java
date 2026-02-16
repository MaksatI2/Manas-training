package manasTrainingService.service.jitsi;

import manasTrainingService.dto.jitsi.JoinMeetingRequestDTO;
import manasTrainingService.dto.jitsi.MeetingParticipantDTO;
import manasTrainingService.entity.Meeting;
import manasTrainingService.entity.MeetingParticipant;
import manasTrainingService.entity.Schedule;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.jitsi.MeetingEndedException;
import manasTrainingService.exceptions.nsee.jitsi.MeetingNotFoundException;
import manasTrainingService.repositories.jitsi.MeetingParticipantRepository;
import manasTrainingService.repositories.jitsi.MeetingRepository;
import manasTrainingService.service.impl.jitsi.MeetingParticipantServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MeetingParticipantServiceImplTest {

    @Mock
    private MeetingParticipantRepository participantRepository;

    @Mock
    private MeetingRepository meetingRepository;

    @Mock
    private UserService userService;

    @InjectMocks
    private MeetingParticipantServiceImpl meetingParticipantService;

    private Meeting meeting;
    private User user;
    private Schedule schedule;

    @BeforeEach
    void setUp() {
        schedule = Schedule.builder()
                .id(1)
                .title("Test Schedule")
                .teacher(User.builder().id(1).build())
                .build();

        meeting = Meeting.builder()
                .id(1)
                .schedule(schedule)
                .startedAt(LocalDateTime.now().minusMinutes(30))
                .build();

        user = User.builder()
                .id(2)
                .name("Test")
                .lastName("User")
                .build();
    }

    @Test
    void joinMeeting_MeetingNotFound_ThrowsException() {
        JoinMeetingRequestDTO request = JoinMeetingRequestDTO.builder()
                .meetingId(1)
                .userId(2)
                .build();

        when(meetingRepository.findById(1)).thenReturn(Optional.empty());

        assertThrows(MeetingNotFoundException.class, () -> {
            meetingParticipantService.joinMeeting(request);
        });
    }

    @Test
    void joinMeeting_MeetingEnded_ThrowsException() {
        JoinMeetingRequestDTO request = JoinMeetingRequestDTO.builder()
                .meetingId(1)
                .userId(2)
                .build();

        meeting.setEndedAt(LocalDateTime.now());
        when(meetingRepository.findById(1)).thenReturn(Optional.of(meeting));

        assertThrows(MeetingEndedException.class, () -> {
            meetingParticipantService.joinMeeting(request);
        });
    }

    @Test
    void joinMeeting_UserAlreadyJoined_ReturnsExistingParticipant() {
        JoinMeetingRequestDTO request = JoinMeetingRequestDTO.builder()
                .meetingId(1)
                .userId(2)
                .build();

        MeetingParticipant existingParticipant = MeetingParticipant.builder()
                .id(1)
                .meeting(meeting)
                .user(user)
                .participantName("Test User")
                .build();

        when(meetingRepository.findById(1)).thenReturn(Optional.of(meeting));
        when(userService.getUserById(2)).thenReturn(user);
        when(participantRepository.findActiveParticipantByMeetingAndUser(1, 2))
                .thenReturn(Optional.of(existingParticipant));

        MeetingParticipantDTO result = meetingParticipantService.joinMeeting(request);

        assertNotNull(result);
        assertEquals(1, result.getId());
        verify(participantRepository, never()).save(any());
    }

    @Test
    void joinMeeting_NewUser_CreatesParticipant() {
        JoinMeetingRequestDTO request = JoinMeetingRequestDTO.builder()
                .meetingId(1)
                .userId(2)
                .participantName("Custom Name")
                .build();

        when(meetingRepository.findById(1)).thenReturn(Optional.of(meeting));
        when(userService.getUserById(2)).thenReturn(user);
        when(participantRepository.findActiveParticipantByMeetingAndUser(1, 2))
                .thenReturn(Optional.empty());
        when(participantRepository.save(any(MeetingParticipant.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        MeetingParticipantDTO result = meetingParticipantService.joinMeeting(request);

        assertNotNull(result);
        assertEquals("Test User", result.getParticipantName());
        assertFalse(result.getIsModerator());
    }

    @Test
    void joinMeeting_Teacher_BecomesModerator() {
        JoinMeetingRequestDTO request = JoinMeetingRequestDTO.builder()
                .meetingId(1)
                .userId(1)
                .build();

        User teacher = User.builder().id(1).name("Teacher").lastName("Name").build();
        when(meetingRepository.findById(1)).thenReturn(Optional.of(meeting));
        when(userService.getUserById(1)).thenReturn(teacher);
        when(participantRepository.findActiveParticipantByMeetingAndUser(1, 1))
                .thenReturn(Optional.empty());
        when(participantRepository.save(any(MeetingParticipant.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        MeetingParticipantDTO result = meetingParticipantService.joinMeeting(request);

        assertNotNull(result);
        assertTrue(result.getIsModerator());
    }

    @Test
    void leaveMeeting_ParticipantNotFound_ThrowsException() {
        when(participantRepository.findActiveParticipantByMeetingAndUser(1, 2))
                .thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, () -> {
            meetingParticipantService.leaveMeeting(1, 2);
        });
    }

    @Test
    void leaveMeeting_ValidParticipant_UpdatesLeaveTime() {
        MeetingParticipant participant = MeetingParticipant.builder()
                .id(1)
                .meeting(meeting)
                .user(user)
                .joinedAt(LocalDateTime.now().minusMinutes(30))
                .build();

        when(participantRepository.findActiveParticipantByMeetingAndUser(1, 2))
                .thenReturn(Optional.of(participant));
        when(participantRepository.save(any(MeetingParticipant.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        assertDoesNotThrow(() -> {
            meetingParticipantService.leaveMeeting(1, 2);
        });

        assertNotNull(participant.getLeftAt());
        assertTrue(participant.getDurationSeconds() > 0);
    }
}