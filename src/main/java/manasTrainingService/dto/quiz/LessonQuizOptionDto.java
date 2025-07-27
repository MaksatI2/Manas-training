package manasTrainingService.dto.quiz;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class LessonQuizOptionDto {
    private Integer id;
    private Integer questionId;
    private String optionText;
    private Boolean isCorrect;
    private Boolean isRemoved;


    @AssertTrue(message = "Ответ обязательно должен быть заполнен")
    public boolean isValidTextIfNotRemoved() {
        return Boolean.TRUE.equals(isRemoved) || (optionText != null && !optionText.trim().isEmpty());
    }

}
