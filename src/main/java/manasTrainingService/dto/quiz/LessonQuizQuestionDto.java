package manasTrainingService.dto.quiz;

import jakarta.validation.Valid;
import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
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
    private String question;
    private BigDecimal points;
    @Valid
    private List<LessonQuizOptionDto> options;
    @NotNull(message = "Укажите какой вариант ответа является верным")
    private Integer correctOptionIndex;
    private Boolean isRemoved;

    @AssertTrue(message = "Вопрос обязателен для заполнения")
    public boolean isValidTextIfNotRemoved() {
        return Boolean.TRUE.equals(isRemoved) || (question != null && !question.trim().isEmpty());
    }
}
