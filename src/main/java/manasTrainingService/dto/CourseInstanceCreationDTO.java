package manasTrainingService.dto;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import manasTrainingService.validation.EndDateAfterStartDate;
import manasTrainingService.validation.UniqueCourseInstanceTitleCreate;

import java.time.LocalDate;


@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EndDateAfterStartDate
@UniqueCourseInstanceTitleCreate
public class CourseInstanceCreationDTO {
    private Integer id;

    @NotNull(message = "Курс должен быть выбран")
    private Integer courseId;

    @NotBlank(message = "Название необходимо")
    @Size(max = 50, message = "Максимальная длина названия — 50 символов")
    private String title;

    @NotNull(message = "Дата начала курса необходима")
    @Future(message = "Дата начала курса должна быть в будущем")
    private LocalDate startDate;
    @NotNull(message = "Дата конца курса необходима")
    @Future(message = "Дата конца курса должна быть в будущем")

    private LocalDate endDate;

    private Boolean isActive = true;
}