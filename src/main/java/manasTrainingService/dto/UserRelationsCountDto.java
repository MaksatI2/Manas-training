package manasTrainingService.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserRelationsCountDto {
    private int schedules;
    private int employees;
    private int courseApplicationEmployees;
    private int testResults;
    private int attendancesAsStudent;
    private int attendancesMarkedBy;
    private int certificatesAsStudent;
    private int certificatesIssuedByUser;
    private int courseInstanceTeachers;
    private int courseTeachers;
    private int enrollments;
}
