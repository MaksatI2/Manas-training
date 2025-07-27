package manasTrainingService.dto.tests;

import jakarta.validation.constraints.AssertTrue;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OptionDto {
    private Integer id;
    private Integer questionId;
    private String optionText;
    private Boolean isCorrect;
    private Boolean isRemoved;

    @AssertTrue(message = "Вариант ответа обязателен для заполнения")
    public boolean isValidTextIfNotRemoved() {
        return Boolean.TRUE.equals(isRemoved) || (optionText != null && !optionText.trim().isEmpty());
    }
}
