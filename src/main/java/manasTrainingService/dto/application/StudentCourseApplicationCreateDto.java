package manasTrainingService.dto.application;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import manasTrainingService.validation.EndDateAfterStartDate;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EndDateAfterStartDate
public class StudentCourseApplicationCreateDto {

    @NotNull(message = "{studentCourseApplicationCreate.courseId.notnull}")
    private Integer courseId;

    private Integer preferredTeacherId;

    @FutureOrPresent(message = "{studentCourseApplicationCreate.preferredStartDate.futureOrPresent}")
    private LocalDate preferredStartDate;

    @FutureOrPresent(message = "{studentCourseApplicationCreate.preferredEndDate.futureOrPresent}")
    private LocalDate preferredEndDate;
}
