package manasTrainingService.dto.edit;

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
public class CourseEditDto {

    @NotNull(message = "ID курса обязателен")
    private Integer id;

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
    private Integer duration;

    private Boolean individual;

    private Boolean active;

    @NotNull(message = "Категория обязательна")
    private Integer categoryId;
}
