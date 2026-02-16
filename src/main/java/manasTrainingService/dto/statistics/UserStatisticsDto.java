package manasTrainingService.dto.statistics;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class UserStatisticsDto {
    private long totalStudents;
    private long totalTeachers;
    private long totalOrganizations;
    private long totalInactiveUsers;


}
