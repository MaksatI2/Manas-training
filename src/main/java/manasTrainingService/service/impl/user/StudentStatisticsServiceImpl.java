package manasTrainingService.service.impl.user;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.statistics.AttendanceStatsDTO;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.User;
import manasTrainingService.repositories.AttendanceRepository;
import manasTrainingService.repositories.ScheduleRepository;
import manasTrainingService.repositories.course.CourseEnrollmentRepository;
import manasTrainingService.service.user.StudentStatisticsService;
import manasTrainingService.util.StatusUtil;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
@RequiredArgsConstructor
public class StudentStatisticsServiceImpl implements StudentStatisticsService {

    private final CourseEnrollmentRepository enrollmentRepository;
    private final ScheduleRepository scheduleRepository;
    private final AttendanceRepository attendanceRepository;

    @Override
    public List<AttendanceStatsDTO> getAllAttendanceStats(User student) {
        List<CourseEnrollment> enrollments = enrollmentRepository
                .findAllActiveEnrollmentsByStudentId(student.getId());

        List<AttendanceStatsDTO> statsList = new ArrayList<>();

        for (CourseEnrollment enrollment : enrollments) {
            CourseInstance course = enrollment.getCourseInstance();
            Status status = enrollment.getStatus();

            Integer totalHours = scheduleRepository
                    .sumActiveScheduleHoursByCourseInstanceId(course.getId());

            Integer absentHours = attendanceRepository
                    .sumAbsentHoursByStudentAndCourseInstance(student.getId(), course.getId());

            totalHours = totalHours != null ? totalHours : 0;
            absentHours = absentHours != null ? absentHours : 0;

            statsList.sort(Comparator.comparing(stat -> !stat.getCourseInstance().getIsActive()));


            statsList.add(new AttendanceStatsDTO(course, totalHours, absentHours, status, StatusUtil.localize(status)));
        }

        return statsList;
    }
}
