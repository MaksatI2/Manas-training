package manasTrainingService.dto.certificate;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudentCertificateDetailDto {
    private Integer id;
    private String certificateNumber;
    private String courseTitle;
    private String courseInstanceTitle;
    private LocalDateTime courseStartDate;
    private LocalDateTime courseEndDate;
    private String issueDate;
    private String expiryDate;
    private Integer mark;
    private String viewUrl;
    private String downloadUrl;
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
