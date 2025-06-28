package manasTrainingService.dto.answers;

import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TestResultDto {
    private Integer totalPoints;
    private Integer correctAnswersCount;
    private Integer wrongAnswersCount;
    private Integer withoutAnswersCount;
    private Integer passingTime;
    private Integer questionsCount;
    private Boolean isPassed;
}
