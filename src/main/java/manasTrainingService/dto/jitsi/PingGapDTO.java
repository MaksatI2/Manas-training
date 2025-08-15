package manasTrainingService.dto.jitsi;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PingGapDTO {
    private LocalDateTime gapStartTime;
    private LocalDateTime gapEndTime;
    private Integer gapDurationMinutes;
    private String reason;
}