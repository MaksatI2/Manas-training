package manasTrainingService.dto.quiz.answers;

import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class QuizQuestionAnswerDto {
    Integer id;
    Integer questionId;
    @NotNull(message = "{quizQuestionAnswerDto.answer.notNull}")
    Integer answerId;
    private BigDecimal points;
}
