package manasTrainingService.service.jitsi;

import manasTrainingService.entity.ParticipantPing;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

public interface ParticipantPingService {
    @Transactional
    void recordPing(Integer participantId, Boolean isActive, String connectionStatus);

    @Transactional
    void recordPingByParticipantId(String participantId, Integer meetingId,
                                   Boolean isActive, String connectionStatus);

    @Scheduled(fixedRate = 600000)
    @Async
    @Transactional(readOnly = true)
    void pingActiveParticipants();

    List<ParticipantPing> getPingHistory(Integer participantId);

    List<ParticipantPing> getMeetingPings(Integer meetingId, LocalDateTime fromTime);
}
