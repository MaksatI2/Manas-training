package manasTrainingService.dto.answers;

import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TestAnswerDto {
    private Integer id;
    private Integer testId;
    private LocalDateTime passingStart;
    private List<QuestionAnswerDto> questionAnswers = new ArrayList<>();
}
