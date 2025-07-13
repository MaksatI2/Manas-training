package manasTrainingService.dto.application;

import lombok.*;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.User;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseApplicationViewDto {
    private Integer id;
    private Integer courseId;
    private String courseTitle;
    private String organizationName;
    private String outgoingCode;
    private LocalDateTime submittedAt;
    private Status status;
    private String localizedStatus;
    private List<EmployeeShortDto> employees;
    private User preferredTeacher;
    private LocalDate preferredStartDate;
    private LocalDate preferredEndDate;
    private String formattedSubmittedAt;
    private String formattedPreferredStartDate;
    private String formattedPreferredEndDate;
    private String organizationCode;

}
