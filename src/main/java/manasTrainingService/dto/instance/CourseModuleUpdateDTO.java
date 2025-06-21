package manasTrainingService.dto.instance;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CourseModuleUpdateDTO {
    @NotBlank(message = "Название модуля обязательно")
    @Size(max = 200, message = "Название не должно превышать 200 символов")
    private String title;

    @NotNull(message = "Продолжительность обязательна")
    @Min(value = 1, message = "Продолжительность должна быть больше 0")
    private Integer durationHours;

    private String description;
}
