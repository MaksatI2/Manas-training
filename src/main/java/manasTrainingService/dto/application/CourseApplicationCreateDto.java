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

    @NotNull(message = "Курс обязателен для выбора")
    private Integer courseId;

    @NotEmpty(message = "Выберите хотя бы одного сотрудника")
    private List<Integer> employeeIds;

    @NotNull(message = "Исходящий код обязателен")
    @Size(min = 3, max = 50, message = "Исходящий код должен быть от 3 до 50 символов")
    private String outgoingCode;

    private Integer preferredTeacherId;

    @FutureOrPresent(message = "Желаемая дата начала должна быть сегодняшней или будущей")
    private LocalDate preferredStartDate;

    @FutureOrPresent(message = "Желаемая дата окончания должна быть сегодняшней или будущей")
    private LocalDate preferredEndDate;
}
