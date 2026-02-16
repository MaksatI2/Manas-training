package manasTrainingService.service.jitsi;

import manasTrainingService.entity.MeetingParticipant;
import manasTrainingService.entity.ParticipantPing;
import manasTrainingService.repositories.jitsi.MeetingParticipantRepository;
import manasTrainingService.repositories.jitsi.ParticipantPingRepository;
import manasTrainingService.service.impl.jitsi.ParticipantPingServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ParticipantPingServiceImplTest {

    @Mock
    private ParticipantPingRepository pingRepository;

    @Mock
    private MeetingParticipantRepository participantRepository;

    @InjectMocks
    private ParticipantPingServiceImpl participantPingService;

    private MeetingParticipant participant;
    private LocalDateTime testTime;

    @BeforeEach
    void setUp() {
        participant = MeetingParticipant.builder()
                .id(1)
                .participantName("Test Participant")
                .build();

        testTime = LocalDateTime.now().minusHours(1);
    }

    @Test
    void recordPing_ParticipantNotFound_ThrowsException() {
        when(participantRepository.findById(1)).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, () -> {
            participantPingService.recordPing(1, true, "CONNECTED");
        });
    }

    @Test
    void recordPing_ValidParticipant_CreatesPing() {
        when(participantRepository.findById(1)).thenReturn(Optional.of(participant));
        when(pingRepository.save(any(ParticipantPing.class))).thenAnswer(invocation -> {
            ParticipantPing ping = invocation.getArgument(0);
            ping.setId(1);
            return ping;
        });

        assertDoesNotThrow(() -> {
            participantPingService.recordPing(1, true, "CONNECTED");
        });

        verify(pingRepository, times(1)).save(any(ParticipantPing.class));
    }

    @Test
    void recordPingByParticipantId_ParticipantNotFound_LogsWarning() {
        when(participantRepository.findActiveParticipantByMeetingAndParticipantId(1, "test-id"))
                .thenReturn(Optional.empty());

        participantPingService.recordPingByParticipantId("test-id", 1, true, "CONNECTED");

        verify(pingRepository, never()).save(any());
        verify(participantRepository, never()).findById(anyInt());
    }

    @Test
    void recordPingByParticipantId_ParticipantFound_RecordsPing() {
        when(participantRepository.findActiveParticipantByMeetingAndParticipantId(anyInt(), anyString()))
                .thenReturn(Optional.of(participant));
        when(participantRepository.findById(participant.getId()))
                .thenReturn(Optional.of(participant));
        when(pingRepository.save(any(ParticipantPing.class))).thenReturn(new ParticipantPing());

        participantPingService.recordPingByParticipantId("test-id", 1, true, "CONNECTED");

        verify(pingRepository, times(1)).save(any(ParticipantPing.class));
    }

    @Test
    void getPingHistory_ReturnsPings() {
        List<ParticipantPing> expectedPings = List.of(
                ParticipantPing.builder().id(1).build(),
                ParticipantPing.builder().id(2).build()
        );

        when(pingRepository.findByMeetingParticipantIdOrderByPingTimeDesc(1))
                .thenReturn(expectedPings);

        List<ParticipantPing> result = participantPingService.getPingHistory(1);

        assertEquals(2, result.size());
        verify(pingRepository, times(1)).findByMeetingParticipantIdOrderByPingTimeDesc(1);
    }

    @Test
    void getMeetingPings_ReturnsPings() {
        List<ParticipantPing> expectedPings = List.of(
                ParticipantPing.builder().id(1).build()
        );

        when(pingRepository.findPingsByMeetingAndTime(eq(1), any(LocalDateTime.class)))
                .thenReturn(expectedPings);

        List<ParticipantPing> result = participantPingService.getMeetingPings(1, testTime);

        assertEquals(1, result.size());
        verify(pingRepository, times(1)).findPingsByMeetingAndTime(eq(1), any(LocalDateTime.class));
    }

    @Test
    void pingActiveParticipants_NoActiveParticipants_DoesNothing() {
        when(participantRepository.findAllActiveParticipants()).thenReturn(Collections.emptyList());

        participantPingService.pingActiveParticipants();

        verify(participantRepository, times(1)).findAllActiveParticipants();
    }

    @Test
    void pingActiveParticipants_WithActiveParticipants_CreatesPings() {
        List<MeetingParticipant> activeParticipants = List.of(
                MeetingParticipant.builder().id(1).build(),
                MeetingParticipant.builder().id(2).build()
        );

        when(participantRepository.findAllActiveParticipants()).thenReturn(activeParticipants);
        when(pingRepository.saveAll(any())).thenReturn(List.of());

        participantPingService.pingActiveParticipants();

        verify(pingRepository, times(1)).saveAll(any());
        verify(participantRepository, times(1)).findAllActiveParticipants();
    }

    @Test
    void saveAllInNewTransaction_SavesPings() {
        List<ParticipantPing> pings = List.of(
                ParticipantPing.builder().id(1).build(),
                ParticipantPing.builder().id(2).build()
        );

        when(pingRepository.saveAll(pings)).thenReturn(pings);

        participantPingService.saveAllInNewTransaction(pings);

        verify(pingRepository, times(1)).saveAll(pings);
    }
}