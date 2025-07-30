package manasTrainingService.dto.statistics;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class TeacherMonthlyHoursDTO {
    private String name;
    private String lastName;
    private Long totalHours;
}
