package manasTrainingService.dto.instance;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseInstanceDTO {
    private Integer id;
    private String title;
    private LocalDate startDate;
    private Integer courseId;
    private LocalDate endDate;
    private Integer durationHours;
    private List<CourseModuleDTO> modules;
    private Boolean isActive;
    private String category;
    private String courseTitle;
    private String formattedStartDate;
    private String formattedEndDate;

}