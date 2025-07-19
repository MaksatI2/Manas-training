package manasTrainingService.dto.statistics;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TestResultDTO {
    private String courseTitle;
    private String testTitle;
    private BigDecimal score;
    private Boolean isPassed;
    private LocalDateTime submittedAt;
    private String localisedTime;
}
