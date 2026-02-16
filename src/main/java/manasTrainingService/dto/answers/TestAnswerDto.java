package manasTrainingService.dto.answers;

import jakarta.validation.Valid;
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
    private Integer testInstanceId;
    @Valid
    private List<QuestionAnswerDto> questionAnswers = new ArrayList<>();
}
