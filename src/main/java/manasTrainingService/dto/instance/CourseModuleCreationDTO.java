package manasTrainingService.dto.instance;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CourseModuleCreationDTO {
    @NotBlank(message = "Название модуля обязательно")
    @Size(max = 200, message = "Название не должно превышать 200 символов")
    private String title;

    @NotNull(message = "Продолжительность обязательна")
    @Min(value = 1, message = "Продолжительность должна быть больше 0")
    private Integer durationHours;

    private String description;

}