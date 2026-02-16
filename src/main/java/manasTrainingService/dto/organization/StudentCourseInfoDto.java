package manasTrainingService.dto.organization;

import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudentCourseInfoDto {
    private Integer enrollmentId;
    private Integer studentId;
    private String fullName;
    private String email;
    private String phone;
    private String courseTitle;
    private String status;
    private BigDecimal progress;
    private BigDecimal finalGrade;
    private String localizedStatus;

}
