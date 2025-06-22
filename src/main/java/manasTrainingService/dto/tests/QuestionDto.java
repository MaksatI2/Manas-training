package manasTrainingService.dto.tests;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

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
    @NotBlank(message = "Содержание вопроса должно быть заполнено")
    private String question;
    @NotNull(message = "Количество баллов за правильный ответ должны быть указаны")
    @Min(value = 0, message = "Не может быть меньше нуля")
    @Max(value = 70, message = "Не может быть больше 70")
    private Integer points;
    private Boolean isRequired;
    @Valid
    private List<OptionDto> options = new ArrayList<>();
}
