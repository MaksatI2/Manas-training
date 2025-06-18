package manasTrainingService.dto.instance;


import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LessonDTO {
    private Integer id;

    @NotNull
    private Integer moduleId;

    @NotBlank(message = "Название урока необходимо")
    private String title;

    private String description;

    @NotNull(message = "Длительность урока необходима")
    @Min(value = 1, message = "Длительность должна быть больше 0")
    private Integer durationMinutes;
}