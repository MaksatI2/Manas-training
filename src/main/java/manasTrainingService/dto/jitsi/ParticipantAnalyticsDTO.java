package manasTrainingService.dto.jitsi;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ParticipantAnalyticsDTO {
    private Integer participantId;
    private String participantName;
    private String userRole;
    private LocalDateTime joinedAt;
    private LocalDateTime leftAt;
    private Integer totalDurationMinutes;
    private Integer activePeriodMinutes;
    private Double participationPercentage;
    private Integer totalPings;
    private Integer activePings;
    private LocalDateTime firstPing;
    private LocalDateTime lastPing;
    private List<PingGapDTO> inactiveGaps;
    private Boolean wasFullyPresent;
}