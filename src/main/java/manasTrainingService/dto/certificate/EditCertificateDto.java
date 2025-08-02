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
public class EditCertificateDto {
    @NotNull
    private Integer id;

    @NotNull
    private Integer studentId;

    @NotBlank(message="Номер сертификата обязателен")
    private String certificateNumber;

    @NotNull(message="Дата выдачи обязательна")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate issueDate;

    @NotNull(message="Срок действия обязателен")
    @FutureOrPresent(message="Срок действия не может быть в прошлом")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate expiryDate;

    @NotNull(message="Оценка обязательна")
    @Min(value=0, message="Оценка не может быть меньше 0")
    @Max(value=100, message="Оценка не может быть больше 100")
    private Integer mark;

}