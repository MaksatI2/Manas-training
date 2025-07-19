package manasTrainingService.service.course;

import manasTrainingService.dto.statistics.AttendanceStatsDTO;
import manasTrainingService.dto.statistics.TestResultDTO;
import manasTrainingService.entity.CourseInstance;

import java.util.List;

public interface CourseInstanceStatisticsService {
    List<AttendanceStatsDTO> getAttendanceStatsByCourseInstance(CourseInstance courseInstance);
}
