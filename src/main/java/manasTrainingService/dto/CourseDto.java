package manasTrainingService.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseDto {

    private Integer id;

    @NotBlank(message = "{CourseDto.title.NotBlank}")
    @Size(max = 200, message = "{CourseDto.title.Size}")
    private String title;

    @NotBlank(message = "{CourseDto.code.NotBlank}")
    @Size(max = 20, message = "{CourseDto.code.Size}")
    private String code;

    @Size(max = 1000, message = "{CourseDto.description.Size}")
    private String description;

    @NotNull(message = "{CourseDto.duration.NotNull}")
    @Min(value = 1, message = "{CourseDto.duration.Min}")
    private Integer duration;

    private Boolean individual;

    private Boolean active;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private String formattedCreatedAt;
    private String formattedUpdatedAt;

    private CourseCategoryDto category;

    @NotNull(message = "{CourseDto.categoryId.NotNull}")
    private Integer categoryId;

    private String instanceTitle;

    private LocalDate instanceStartDate;

    private LocalDate instanceEndDate;
}
