package manasTrainingService.dto.edit;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import manasTrainingService.validation.UniqueCourseUpdate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@UniqueCourseUpdate
public class CourseEditDto {

    @NotNull(message = "{courseEdit.id.notnull}")
    private Integer id;

    @NotBlank(message = "{courseEdit.title.notblank}")
    @Size(max = 200, message = "{courseEdit.title.size}")
    private String title;

    @NotBlank(message = "{courseEdit.code.notblank}")
    @Size(max = 20, message = "{courseEdit.code.size}")
    private String code;

    @Size(max = 1000, message = "{courseEdit.description.size}")
    private String description;

    @NotNull(message = "{courseEdit.duration.notnull}")
    @Min(value = 1, message = "{courseEdit.duration.min}")
    @Max(value = 10000, message = "{courseEdit.duration.max}")
    private Integer duration;

    private Boolean active;

    @NotNull(message = "{courseEdit.categoryId.notnull}")
    private Integer categoryId;
}
