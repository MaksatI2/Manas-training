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

    @NotBlank(message = "Название необходимо")
    @Size(max = 50, message = "Максимальная длина названия — 50 символов")
    private String title;

    @NotNull(message = "Дата начала курса необходима")
    private LocalDate startDate;

    @NotNull(message = "Дата конца курса необходима")
    private LocalDate endDate;

    @NotNull
    private Boolean isActive;
}
