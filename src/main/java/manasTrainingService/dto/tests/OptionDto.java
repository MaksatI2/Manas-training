package manasTrainingService.dto.tests;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OptionDto {
    private Integer id;
    private Integer questionId;
    @NotBlank(message = "Текс ответа не может быть пустым")
    private String optionText;
    private Boolean isCorrect;
}
