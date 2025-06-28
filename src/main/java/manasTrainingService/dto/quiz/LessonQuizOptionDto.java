package manasTrainingService.dto.quiz;

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
    @NotBlank(message = "Ответ обязательно должен быть заполнен")
    private String optionText;
    private Boolean isCorrect;
    private Boolean isRemoved;
}
