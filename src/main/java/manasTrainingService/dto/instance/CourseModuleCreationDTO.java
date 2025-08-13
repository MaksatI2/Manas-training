package manasTrainingService.dto.instance;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CourseModuleCreationDTO {
    @NotBlank(message = "{courseModule.title.notBlank}")
    @Size(max = 200, message = "{courseModule.title.size}")
    private String title;

    @NotNull(message = "{courseModule.duration.notNull}")
    @Min(value = 1, message = "{courseModule.duration.min}")
    private Integer durationHours;

    private String description;
}
