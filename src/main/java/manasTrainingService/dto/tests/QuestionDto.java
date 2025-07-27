package manasTrainingService.dto.tests;

import jakarta.validation.Valid;
import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class QuestionDto {
    private Integer id;
    private Integer testId;
    private String question;
    private BigDecimal points;
    private Boolean isRequired;
    @Valid
    private List<OptionDto> options = new ArrayList<>();
    @NotNull(message = "Укажите какой вариант ответа является верным")
    private Integer correctOptionIndex;
    private Boolean isRemoved;

    @AssertTrue(message = "Вопрос обязателен для заполнения")
    public boolean isValidTextIfNotRemoved() {
        return Boolean.TRUE.equals(isRemoved) || (question != null && !question.trim().isEmpty());
    }
}
