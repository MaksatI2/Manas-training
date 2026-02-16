package manasTrainingService.dto.create;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import manasTrainingService.validation.UniqueCourseCreate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@UniqueCourseCreate
public class CreateCourseDto {

    @NotBlank(message = "{createCourse.title.notblank}")
    @Size(max = 200, message = "{createCourse.title.size}")
    private String title;

    @NotBlank(message = "{createCourse.code.notblank}")
    @Size(max = 20, message = "{createCourse.code.size}")
    private String code;

    @Size(max = 1000, message = "{createCourse.description.size}")
    private String description;

    @NotNull(message = "{createCourse.duration.notnull}")
    @Min(value = 1, message = "{createCourse.duration.min}")
    @Max(value = 10000, message = "{createCourse.duration.max}")
    private Integer duration;

    @Builder.Default
    private Boolean active = true;

    @NotNull(message = "{createCourse.categoryId.notnull}")
    private Integer categoryId;
}
