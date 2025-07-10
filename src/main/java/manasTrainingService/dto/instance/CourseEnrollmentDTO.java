package manasTrainingService.dto.instance;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import manasTrainingService.entity.Status;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Setter
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseEnrollmentDTO {
    private Integer id;
    private Integer studentId;
    private String studentName;
    private LocalDateTime enrollmentDate;
    private Status status;
    private BigDecimal progressPercentage;
    private BigDecimal finalGrade;
    private String formattedEnrollmentDate;
}