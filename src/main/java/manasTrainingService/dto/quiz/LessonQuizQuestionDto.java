package manasTrainingService.dto.quiz;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class LessonQuizQuestionDto {
    private Integer id;
    private Integer quizId;
    @NotBlank(message = "Вопрос обязателен для заполнения")
    private String question;
    private BigDecimal points;
    @Valid
    private List<LessonQuizOptionDto> options;
    private Integer correctOptionIndex;
    private Boolean isRemoved;
}
