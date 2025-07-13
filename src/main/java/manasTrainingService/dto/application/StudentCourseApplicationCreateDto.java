package manasTrainingService.dto.application;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudentCourseApplicationCreateDto {

    @NotNull(message = "Курс обязателен")
    private Integer courseId;

    private Integer preferredTeacherId;

    @FutureOrPresent(message = "Дата начала должна быть сегодня или позже")
    private LocalDate preferredStartDate;

    @FutureOrPresent(message = "Дата окончания должна быть сегодня или позже")
    private LocalDate preferredEndDate;


    @AssertTrue(message = "Дата окончания не может быть раньше даты начала")
    public boolean isEndAfterStart() {
        return preferredStartDate == null || preferredEndDate == null
                || !preferredEndDate.isBefore(preferredStartDate);
    }
}
