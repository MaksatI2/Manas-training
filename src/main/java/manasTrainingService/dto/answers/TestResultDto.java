package manasTrainingService.dto.answers;

import lombok.*;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.dto.tests.TestInstanceDto;

import java.util.List;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TestResultDto {
    private Integer id;
    private Integer totalPoints;
    private TestInstanceDto testInstance;
    private Integer correctAnswersCount;
    private Integer wrongAnswersCount;
    private Integer withoutAnswersCount;
    private Integer passingTime;
    private Integer questionsCount;
    private Boolean isPassed;
}
