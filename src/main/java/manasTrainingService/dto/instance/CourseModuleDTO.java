package manasTrainingService.dto.instance;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseModuleDTO {
    private Integer id;

    @NotNull(message = "{courseModule.courseInstanceId.notNull}")
    private Integer courseInstanceId;
    private CourseInstanceDTO courseInstance;

    @NotBlank(message = "{courseModule.title.notBlank}")
    private String title;

    private String description;

    @NotNull(message = "{courseModule.duration.notNull}")
    @Min(value = 1, message = "{courseModule.duration.min}")
    private Integer durationHours;

    @NotNull(message = "{courseModule.orderIndex.notNull}")
    @Min(value = 1, message = "{courseModule.orderIndex.min}")
    private Integer orderIndex;

    private List<LessonDTO> lessons;
}
