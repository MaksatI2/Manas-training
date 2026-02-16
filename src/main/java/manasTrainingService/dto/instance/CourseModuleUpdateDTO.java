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

    @NotBlank(message = "{courseModuleUpdate.title.notBlank}")
    @Size(max = 200, message = "{courseModuleUpdate.title.size}")
    private String title;

    @NotNull(message = "{courseModuleUpdate.duration.notNull}")
    @Min(value = 1, message = "{courseModuleUpdate.duration.min}")
    private Integer durationHours;

    private String description;
}
