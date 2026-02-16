package manasTrainingService.dto.application;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseInstanceCalendarDTO {
    private Integer id;
    private Integer courseId;
    private String courseInstanceTitle;
    private String courseTitle;
    private String category;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;
    private String color;
}