package manasTrainingService.dto.certificate;

import jakarta.validation.constraints.*;
import lombok.*;
import manasTrainingService.validation.EndDateAfterStartDate;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EndDateAfterStartDate
public class CreateCertificateDto {

    @NotNull
    private Integer studentId;

    @NotNull
    private Integer courseInstanceId;

    @NotNull
    @FutureOrPresent(message="Дата окончания не может быть раньше сегодня")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate expiryDate;

    @NotNull
    @Min(value = 0,  message = "Оценка не может быть меньше 0")
    @Max(value = 100, message = "Оценка не может быть больше 100")
    private Integer mark;

}
