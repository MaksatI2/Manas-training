package manasTrainingService.dto.instance;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import manasTrainingService.entity.Status;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseEnrollmentCardDTO {
    private Integer courseInstanceId;
    private String courseTitle;
    private String instanceTitle;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private Status status;
    private BigDecimal progress;
    private String localizedStatus;
}

