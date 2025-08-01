package manasTrainingService.dto.certificate;

import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseCertificateStatusDto {
    private String courseTitle;
    private String courseInstanceTitle;
    private LocalDateTime courseStartDate;
    private LocalDateTime courseEndDate;
    private boolean certificateCreated;
    private List<Integer> certificateId;
    private Integer courseInstanceId;
    private String certificateIssueDate;
    private String certificateExpiryDate;
    private String certificateNumber;
    private Integer mark;
    public String getFormattedStartDate() {
        return courseStartDate != null ?
                manasTrainingService.util.DateUtil.formatDateOnly(courseStartDate) : "";
    }

    public String getFormattedEndDate() {
        return courseEndDate != null ?
                manasTrainingService.util.DateUtil.formatDateOnly(courseEndDate) : "";
    }
}