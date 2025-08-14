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

    @NotNull(message = "{createCertificate.studentId.notnull}")
    private Integer studentId;

    @NotNull(message = "{createCertificate.courseInstanceId.notnull}")
    private Integer courseInstanceId;

    @NotNull(message = "{createCertificate.expiryDate.notnull}")
    @FutureOrPresent(message = "{createCertificate.expiryDate.futureOrPresent}")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate expiryDate;

    @NotNull(message = "{createCertificate.mark.notnull}")
    @Min(value = 0, message = "{createCertificate.mark.min}")
    @Max(value = 100, message = "{createCertificate.mark.max}")
    private Integer mark;
}
