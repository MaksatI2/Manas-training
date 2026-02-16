package manasTrainingService.dto.jitsi;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PingGapDTO {
    private LocalDateTime gapStartTime;
    private LocalDateTime gapEndTime;
    private Integer gapDurationMinutes;
    private String reason;

    private String gapStartTimeFormatted;
    private String gapEndTimeFormatted;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");

    public void formatTimes() {
        if (gapStartTime != null) {
            this.gapStartTimeFormatted = gapStartTime.format(FORMATTER);
        }

        if (gapEndTime != null) {
            this.gapEndTimeFormatted = gapEndTime.format(FORMATTER);
        }
    }
}