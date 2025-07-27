package manasTrainingService.dto.answers;

import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class QuestionAnswerDto {
    private Integer id;
    private Integer questionId;
    @NotNull(message = "Ответ обязателен")
    private Integer answerId;
    private BigDecimal points;
}
