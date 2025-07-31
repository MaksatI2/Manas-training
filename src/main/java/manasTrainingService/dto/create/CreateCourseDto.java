package manasTrainingService.dto.create;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateCourseDto {

    @NotBlank(message = "Название обязательно")
    @Size(max = 200, message = "Максимум 200 символов")
    private String title;

    @NotBlank(message = "Код курса обязателен")
    @Size(max = 20, message = "Максимум 20 символов")
    private String code;

    @Size(max = 1000, message = "Максимум 1000 символов")
    private String description;

    @NotNull(message = "Продолжительность обязательна")
    @Min(value = 1, message = "Должно быть положительным числом")
    @Max(value = 10000, message = "Слишком большая продолжительность, максимальное значение 10000")
    private Integer duration;

    @Builder.Default
    private Boolean individual = false;

    @Builder.Default
    private Boolean active = true;

    @NotNull(message = "Категория обязательна")
    private Integer categoryId;
}
