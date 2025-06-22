package manasTrainingService.dto.lesson;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LessonEditDto {
    
    @NotBlank(message = "Название обязательно")
    private String title;

    private String description;

    @Min(value = 1, message = "Длительность должна быть не менее 1 минуты")
    private Integer durationMinutes;
}
