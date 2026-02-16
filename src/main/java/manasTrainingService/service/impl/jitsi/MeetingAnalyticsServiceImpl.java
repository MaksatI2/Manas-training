package manasTrainingService.service.impl.jitsi;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.dto.jitsi.MeetingAnalyticsDTO;
import manasTrainingService.dto.jitsi.ParticipantAnalyticsDTO;
import manasTrainingService.dto.jitsi.PingGapDTO;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.jitsi.MeetingNotFoundException;
import manasTrainingService.repositories.jitsi.MeetingParticipantRepository;
import manasTrainingService.repositories.jitsi.MeetingRepository;
import manasTrainingService.repositories.jitsi.ParticipantPingRepository;
import manasTrainingService.service.jitsi.MeetingAnalyticsService;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class MeetingAnalyticsServiceImpl implements MeetingAnalyticsService {

    private final MeetingRepository meetingRepository;
    private final MeetingParticipantRepository participantRepository;
    private final ParticipantPingRepository pingRepository;

    private static final int PING_INTERVAL_MINUTES = 10;
    private static final int MAX_GAP_TOLERANCE_MINUTES = 15;

    @Override
    public MeetingAnalyticsDTO getMeetingAnalytics(Integer meetingId) {
        Meeting meeting = meetingRepository.findById(meetingId)
                .orElseThrow(() -> new MeetingNotFoundException("Встреча не найдена"));

        return buildMeetingAnalytics(meeting);
    }

    @Override
    public MeetingAnalyticsDTO getScheduleAnalytics(Integer scheduleId) {
        Meeting meeting = meetingRepository.findByScheduleId(scheduleId)
                .orElseThrow(() -> new MeetingNotFoundException("Встреча для данного расписания не найдена"));

        return buildMeetingAnalytics(meeting);
    }

    private MeetingAnalyticsDTO buildMeetingAnalytics(Meeting meeting) {
        List<MeetingParticipant> participants = participantRepository
                .findAllByMeetingId(meeting.getId());

        LocalDateTime meetingStart = meeting.getStartedAt();
        LocalDateTime meetingEnd = meeting.getEndedAt() != null ? meeting.getEndedAt() : LocalDateTime.now();
        int totalDurationMinutes = (int) Duration.between(meetingStart, meetingEnd).toMinutes();

        List<ParticipantAnalyticsDTO> participantAnalytics = participants.stream()
                .map(participant -> buildParticipantAnalytics(participant, meetingStart, meetingEnd))
                .collect(Collectors.toList());

        double averageParticipation = participantAnalytics.stream()
                .mapToDouble(ParticipantAnalyticsDTO::getParticipationPercentage)
                .average()
                .orElse(0.0);

        MeetingAnalyticsDTO analyticsDTO = MeetingAnalyticsDTO.builder()
                .meetingId(meeting.getId())
                .lessonTitle(meeting.getSchedule().getTitle())
                .teacherName(meeting.getSchedule().getTeacher().getName() + " " +
                             meeting.getSchedule().getTeacher().getLastName())
                .startedAt(meetingStart)
                .endedAt(meetingEnd)
                .totalDurationMinutes(totalDurationMinutes)
                .totalParticipants(participants.size())
                .averageParticipationPercentage((int) Math.round(averageParticipation))
                .participantAnalytics(participantAnalytics)
                .build();

        analyticsDTO.formatTimes();

        return analyticsDTO;
    }

    private ParticipantAnalyticsDTO buildParticipantAnalytics(MeetingParticipant participant,
                                                              LocalDateTime meetingStart,
                                                              LocalDateTime meetingEnd) {
        List<ParticipantPing> pings = pingRepository
                .findByMeetingParticipantIdOrderByPingTimeDesc(participant.getId());

        String userRole = "GUEST";
        if (participant.getUser() != null) {
            if (participant.getIsModerator()) {
                userRole = "TEACHER";
            } else {
                userRole = "STUDENT";
            }
        }

        LocalDateTime actualJoinTime = participant.getJoinedAt();
        LocalDateTime actualLeaveTime = participant.getLeftAt() != null ?
                participant.getLeftAt() : meetingEnd;

        int totalDurationMinutes = (int) Duration.between(actualJoinTime, actualLeaveTime).toMinutes();

        PingAnalysis pingAnalysis = analyzePings(pings, actualJoinTime, actualLeaveTime);

        double participationPercentage = calculateParticipationPercentage(
                pingAnalysis, actualJoinTime, actualLeaveTime, meetingStart, meetingEnd);

        ParticipantAnalyticsDTO participantDTO = ParticipantAnalyticsDTO.builder()
                .participantId(participant.getId())
                .participantName(participant.getParticipantName())
                .userRole(userRole)
                .joinedAt(actualJoinTime)
                .leftAt(actualLeaveTime)
                .totalDurationMinutes(totalDurationMinutes)
                .activePeriodMinutes(pingAnalysis.activePeriodMinutes)
                .participationPercentage(participationPercentage)
                .totalPings(pings.size())
                .activePings(pingAnalysis.activePings)
                .firstPing(pingAnalysis.firstPing)
                .lastPing(pingAnalysis.lastPing)
                .inactiveGaps(pingAnalysis.inactiveGaps)
                .wasFullyPresent(pingAnalysis.wasFullyPresent)
                .build();

        participantDTO.formatTimes();

        return participantDTO;
    }

    private PingAnalysis analyzePings(List<ParticipantPing> pings,
                                      LocalDateTime joinTime,
                                      LocalDateTime leaveTime) {
        if (pings.isEmpty()) {
            return PingAnalysis.builder()
                    .activePings(0)
                    .activePeriodMinutes(0)
                    .wasFullyPresent(false)
                    .inactiveGaps(Collections.emptyList())
                    .build();
        }

        pings.sort(Comparator.comparing(ParticipantPing::getPingTime));

        List<ParticipantPing> activePings = pings.stream()
                .filter(ParticipantPing::getIsActive)
                .collect(Collectors.toList());

        LocalDateTime firstPing = pings.get(0).getPingTime();
        LocalDateTime lastPing = pings.get(pings.size() - 1).getPingTime();

        List<PingGapDTO> inactiveGaps = findInactiveGaps(pings, joinTime, leaveTime);

        int activePeriodMinutes = calculateActivePeriodMinutes(activePings, joinTime, leaveTime);

        boolean wasFullyPresent = isFullyPresent(pings, joinTime, leaveTime);

        return PingAnalysis.builder()
                .activePings(activePings.size())
                .activePeriodMinutes(activePeriodMinutes)
                .firstPing(firstPing)
                .lastPing(lastPing)
                .wasFullyPresent(wasFullyPresent)
                .inactiveGaps(inactiveGaps)
                .build();
    }

    private List<PingGapDTO> findInactiveGaps(List<ParticipantPing> pings,
                                              LocalDateTime joinTime,
                                              LocalDateTime leaveTime) {
        List<PingGapDTO> gaps = new ArrayList<>();

        if (pings.isEmpty()) {
            return gaps;
        }

        LocalDateTime previousTime = joinTime;

        for (ParticipantPing ping : pings) {
            long gapMinutes = Duration.between(previousTime, ping.getPingTime()).toMinutes();

            if (gapMinutes > MAX_GAP_TOLERANCE_MINUTES) {
                PingGapDTO gap = PingGapDTO.builder()
                        .gapStartTime(previousTime)
                        .gapEndTime(ping.getPingTime())
                        .gapDurationMinutes((int) gapMinutes)
                        .reason(!ping.getIsActive() ? "INACTIVE" : "NO_PING")
                        .build();
                gap.formatTimes();
                gaps.add(gap);
            }

            previousTime = ping.getPingTime();
        }

        LocalDateTime lastPingTime = pings.get(pings.size() - 1).getPingTime();
        long finalGapMinutes = Duration.between(lastPingTime, leaveTime).toMinutes();

        if (finalGapMinutes > MAX_GAP_TOLERANCE_MINUTES) {
            PingGapDTO finalGap = PingGapDTO.builder()
                    .gapStartTime(lastPingTime)
                    .gapEndTime(leaveTime)
                    .gapDurationMinutes((int) finalGapMinutes)
                    .reason("NO_FINAL_PING")
                    .build();
            finalGap.formatTimes();
            gaps.add(finalGap);
        }

        return gaps;
    }

    private int calculateActivePeriodMinutes(List<ParticipantPing> activePings,
                                             LocalDateTime joinTime,
                                             LocalDateTime leaveTime) {
        if (activePings.isEmpty()) {
            return 0;
        }

        LocalDateTime firstActivePing = activePings.get(0).getPingTime();
        LocalDateTime lastActivePing = activePings.get(activePings.size() - 1).getPingTime();

        int basePeriod = (int) Duration.between(firstActivePing, lastActivePing).toMinutes();
        return Math.max(basePeriod, PING_INTERVAL_MINUTES);
    }

    private boolean isFullyPresent(List<ParticipantPing> pings,
                                   LocalDateTime joinTime,
                                   LocalDateTime leaveTime) {
        long totalSessionMinutes = Duration.between(joinTime, leaveTime).toMinutes();

        int expectedPings = (int) (totalSessionMinutes / PING_INTERVAL_MINUTES);

        long activePings = pings.stream().filter(ParticipantPing::getIsActive).count();

        return activePings >= (expectedPings * 0.8);
    }

    private double calculateParticipationPercentage(PingAnalysis analysis,
                                                    LocalDateTime joinTime,
                                                    LocalDateTime leaveTime,
                                                    LocalDateTime meetingStart,
                                                    LocalDateTime meetingEnd) {
        long totalMeetingMinutes = Duration.between(meetingStart, meetingEnd).toMinutes();

        if (totalMeetingMinutes == 0) {
            return 0.0;
        }

        long sessionMinutes = Duration.between(joinTime, leaveTime).toMinutes();

        double baseParticipation = (double) sessionMinutes / totalMeetingMinutes * 100;

        if (analysis.activePings > 0) {
            long expectedPings = sessionMinutes / PING_INTERVAL_MINUTES;
            double pingEfficiency = expectedPings > 0 ?
                    (double) analysis.activePings / expectedPings : 1.0;

            baseParticipation *= Math.min(pingEfficiency, 1.0);
        } else {
            baseParticipation *= 0.5;
        }

        return Math.min(Math.max(baseParticipation, 0.0), 100.0);
    }

    @lombok.Builder
    private static class PingAnalysis {
        int activePings;
        int activePeriodMinutes;
        LocalDateTime firstPing;
        LocalDateTime lastPing;
        boolean wasFullyPresent;
        List<PingGapDTO> inactiveGaps;
    }
}