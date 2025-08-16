package manasTrainingService.dto.jitsi;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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

    private String joinedAtFormatted;
    private String leftAtFormatted;
    private String firstPingFormatted;
    private String lastPingFormatted;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");

    public void formatTimes() {
        if (joinedAt != null) {
            this.joinedAtFormatted = joinedAt.format(FORMATTER);
        }

        if (leftAt != null) {
            this.leftAtFormatted = leftAt.format(FORMATTER);
        }

        if (firstPing != null) {
            this.firstPingFormatted = firstPing.format(FORMATTER);
        }

        if (lastPing != null) {
            this.lastPingFormatted = lastPing.format(FORMATTER);
        }
    }
}