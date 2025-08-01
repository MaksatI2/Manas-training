package manasTrainingService.dto.certificate;

import lombok.*;
import manasTrainingService.entity.Certificate;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CertificateViewDto {
    private Integer id;
    private String certificateNumber;
    private String courseTitle;
    private String courseInstanceTitle;
    private String issueDate;
    private String expiryDate;
    private String viewUrl;
    private String downloadUrl;
    private Certificate certificate;
    private LocalDate originalIssueDate;
    private LocalDate originalExpiryDate;

    public boolean isExpired() {
        return originalExpiryDate != null && originalExpiryDate.isBefore(LocalDate.now());
    }

    public long getDaysUntilExpiry() {
        if (originalExpiryDate == null) return -1;
        return java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), originalExpiryDate);
    }
}