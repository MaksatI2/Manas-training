package manasTrainingService.dto.tests;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TestDto {
    private Integer id;
    private Integer courseInstanceId;
    @NotBlank(message = "Название теста обязательно для заполнения")
    private String title;
    @NotBlank(message = "Описание обязательно для заполнения")
    private String description;
    @NotNull(message = "Проходной бал обязателно должен быть указан")
    @Min(value = 0, message = "Не может быть меньше нуля")
    @Max(value = 70, message = "Не может быть больше 70")
    private Integer passingScore;

    @NotBlank(message = "Деапозон дат обязателен к заполнению")
    private String range;

    private Boolean isActive;
    @Valid
    private List<QuestionDto> questions = new ArrayList<>();
}
