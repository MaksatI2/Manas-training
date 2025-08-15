package manasTrainingService.service.impl.jitsi;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.entity.MeetingParticipant;
import manasTrainingService.entity.ParticipantPing;
import manasTrainingService.repositories.jitsi.MeetingParticipantRepository;
import manasTrainingService.repositories.jitsi.ParticipantPingRepository;
import manasTrainingService.service.jitsi.ParticipantPingService;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ParticipantPingServiceImpl implements ParticipantPingService {

    private final ParticipantPingRepository pingRepository;
    private final MeetingParticipantRepository participantRepository;

    @Transactional
    @Override
    public void recordPing(Integer participantId, Boolean isActive, String connectionStatus) {
        MeetingParticipant participant = participantRepository.findById(participantId)
                .orElseThrow(() -> new IllegalArgumentException("Участник не найден"));

        ParticipantPing ping = ParticipantPing.builder()
                .meetingParticipant(participant)
                .pingTime(LocalDateTime.now())
                .isActive(isActive)
                .connectionStatus(connectionStatus)
                .build();

        pingRepository.save(ping);

        log.debug("Ping recorded: participantId={}, isActive={}, status={}",
                participantId, isActive, connectionStatus);
    }

    @Transactional
    @Override
    public void recordPingByParticipantId(String participantId, Integer meetingId,
                                          Boolean isActive, String connectionStatus) {
        MeetingParticipant participant = participantRepository
                .findActiveParticipantByMeetingAndParticipantId(meetingId, participantId)
                .orElse(null);

        if (participant != null) {
            recordPing(participant.getId(), isActive, connectionStatus);
        } else {
            log.warn("Participant not found for ping: participantId={}, meetingId={}",
                    participantId, meetingId);
        }
    }

    @Async
    @Transactional(readOnly = true)
    public void pingActiveParticipants() {
        List<MeetingParticipant> activeParticipants = participantRepository
                .findAllActiveParticipants();

        log.info("Starting ping check for {} active participants", activeParticipants.size());

        List<ParticipantPing> pings = activeParticipants.stream()
                .map(p -> ParticipantPing.builder()
                        .meetingParticipant(p)
                        .pingTime(LocalDateTime.now())
                        .isActive(true)
                        .connectionStatus("AUTO_PING")
                        .build())
                .toList();

        saveAllInNewTransaction(pings);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void saveAllInNewTransaction(List<ParticipantPing> pings) {
        pingRepository.saveAll(pings);
    }

    @Override
    public List<ParticipantPing> getPingHistory(Integer participantId) {
        return pingRepository.findByMeetingParticipantIdOrderByPingTimeDesc(participantId);
    }

    @Override
    public List<ParticipantPing> getMeetingPings(Integer meetingId, LocalDateTime fromTime) {
        return pingRepository.findPingsByMeetingAndTime(meetingId, fromTime);
    }
}