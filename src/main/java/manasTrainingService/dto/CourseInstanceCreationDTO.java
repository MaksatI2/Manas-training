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

    @NotNull(message = "{CourseInstanceCreationDTO.courseId.NotNull}")
    private Integer courseId;

    @NotBlank(message = "{CourseInstanceCreationDTO.title.NotBlank}")
    @Size(max = 50, message = "{CourseInstanceCreationDTO.title.Size}")
    private String title;

    @NotNull(message = "{CourseInstanceCreationDTO.startDate.NotNull}")
    // @Future(message = "{CourseInstanceCreationDTO.startDate.Future}")
    private LocalDate startDate;

    @NotNull(message = "{CourseInstanceCreationDTO.endDate.NotNull}")
    @Future(message = "{CourseInstanceCreationDTO.endDate.Future}")
    private LocalDate endDate;

    private Boolean isActive = true;
}
