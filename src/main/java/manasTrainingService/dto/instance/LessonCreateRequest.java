package manasTrainingService.dto.instance;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class LessonCreateRequest {

    @NotBlank(message = "Название урока обязательно")
    private String title;

    private String description;

    @NotNull(message = "Длительность обязательна")
    @Min(value = 0, message = "Длительность не может быть отрицательной")
    private Integer durationMinutes;
}
