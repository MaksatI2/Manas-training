package manasTrainingService.dto.statistics;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder

public class TestResultDTO {
    private String courseTitle;
    private String testTitle;
    private BigDecimal score;
    private Boolean isPassed;
    private LocalDateTime submittedAt;
    private String localisedTime;
    private String studentName;
}
