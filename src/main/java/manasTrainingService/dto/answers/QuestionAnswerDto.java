package manasTrainingService.dto.answers;

import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class QuestionAnswerDto {
    Integer id;
    Integer questionId;
    Integer answerId;
    Integer points;
}
