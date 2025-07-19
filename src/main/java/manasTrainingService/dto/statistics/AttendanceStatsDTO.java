package manasTrainingService.dto.statistics;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.User;

@Getter
@AllArgsConstructor
@Setter
public class AttendanceStatsDTO {
    private final CourseInstance courseInstance;
    private final int totalHours;
    private final int absentHours;
    private final Status enrollmentStatus;
    private String localisedStatus;
    private User student;

    public int getAttendancePercentage() {
        return totalHours == 0 ? 0 : (absentHours * 100 / totalHours);
    }
}
