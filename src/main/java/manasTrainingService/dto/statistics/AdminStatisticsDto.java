package manasTrainingService.dto.statistics;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@AllArgsConstructor
@Builder
@NoArgsConstructor
public class AdminStatisticsDto {
    private long totalStudents;
    private long totalTeachers;
    private long totalCourses;
    private long totalInactiveUsers;
    private long totalTests;
    private long totalCertificates;
    private long totalOrganizations;

    private long completedCourses;
    private long certificatesIssuedThisMonth;

    private BigDecimal averageTestScore;
    private long totalPassedTests;

}
