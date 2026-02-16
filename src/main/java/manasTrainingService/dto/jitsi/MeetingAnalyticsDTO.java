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
public class MeetingAnalyticsDTO {
    private Integer meetingId;
    private String lessonTitle;
    private String teacherName;
    private LocalDateTime startedAt;
    private LocalDateTime endedAt;
    private Integer totalDurationMinutes;
    private Integer totalParticipants;
    private Integer averageParticipationPercentage;
    private List<ParticipantAnalyticsDTO> participantAnalytics;

    private String startedAtFormatted;
    private String endedAtFormatted;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");

    public void formatTimes() {
        if (startedAt != null) {
            this.startedAtFormatted = startedAt.format(FORMATTER);
        }

        if (endedAt != null) {
            this.endedAtFormatted = endedAt.format(FORMATTER);
        }
    }
}