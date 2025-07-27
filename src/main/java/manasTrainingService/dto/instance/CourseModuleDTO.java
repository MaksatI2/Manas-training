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

    @NotNull
    private Integer courseInstanceId;
    private CourseInstanceDTO courseInstance;

    @NotBlank(message = "Название модуля необходимо")
    private String title;

    private String description;

    @NotNull(message = "Длительность модуля необходима")
    @Min(value = 1, message = "Длительность должна быть больше 0")
    private Integer durationHours;

    @NotNull(message = "Порядок модуля необходим")
    @Min(value = 1, message = "Порядок должен быть больше 0")
    private Integer orderIndex;

    private List<LessonDTO> lessons;
}