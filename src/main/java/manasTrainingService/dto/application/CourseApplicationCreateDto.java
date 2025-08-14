package manasTrainingService.dto.application;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import manasTrainingService.validation.EndDateAfterStartDate;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EndDateAfterStartDate
public class CourseApplicationCreateDto {

    @NotNull(message = "{courseApplicationCreate.courseId.notnull}")
    private Integer courseId;

    @NotEmpty(message = "{courseApplicationCreate.employeeIds.notempty}")
    private List<Integer> employeeIds;

    @NotNull(message = "{courseApplicationCreate.outgoingCode.notnull}")
    @Size(min = 3, max = 50, message = "{courseApplicationCreate.outgoingCode.size}")
    private String outgoingCode;

    private Integer preferredTeacherId;

    @FutureOrPresent(message = "{courseApplicationCreate.preferredStartDate.futureOrPresent}")
    private LocalDate preferredStartDate;

    @FutureOrPresent(message = "{courseApplicationCreate.preferredEndDate.futureOrPresent}")
    private LocalDate preferredEndDate;
}
