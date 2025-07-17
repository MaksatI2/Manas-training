package manasTrainingService.service.user;

import manasTrainingService.dto.statistics.AttendanceStatsDTO;
import manasTrainingService.entity.User;

import java.util.List;

public interface StudentStatisticsService {
    List<AttendanceStatsDTO> getAllAttendanceStats(User student);
}
