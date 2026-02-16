package manasTrainingService.dto.instance;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import manasTrainingService.validation.EndDateAfterStartDate;
import manasTrainingService.validation.UniqueCourseInstanceTitleUpdate;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EndDateAfterStartDate
@UniqueCourseInstanceTitleUpdate
public class CourseInstanceUpdateDTO {
    private Integer id;

    @NotBlank(message = "{courseInstance.title.notBlank}")
    @Size(max = 50, message = "{courseInstance.title.size}")
    private String title;

    @NotNull(message = "{courseInstance.startDate.notNull}")
    private LocalDate startDate;

    @NotNull(message = "{courseInstance.endDate.notNull}")
    private LocalDate endDate;

    @NotNull
    private Boolean isActive;
}
