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

    @NotNull(message = "{editCertificate.id.notnull}")
    private Integer id;

    @NotNull(message = "{editCertificate.studentId.notnull}")
    private Integer studentId;


    @NotNull(message = "{editCertificate.issueDate.notnull}")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate issueDate;

    @NotNull(message = "{editCertificate.expiryDate.notnull}")
    @FutureOrPresent(message = "{editCertificate.expiryDate.futureOrPresent}")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate expiryDate;

    @NotNull(message = "{editCertificate.mark.notnull}")
    @Min(value = 0, message = "{editCertificate.mark.min}")
    @Max(value = 100, message = "{editCertificate.mark.max}")
    private Integer mark;
}
