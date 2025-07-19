package manasTrainingService.service.impl.course;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.statistics.AttendanceStatsDTO;
import manasTrainingService.dto.statistics.TestResultDTO;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.User;
import manasTrainingService.service.AttendanceService;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.course.CourseInstanceStatisticsService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.util.StatusUtil;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseInstanceStatisticsServiceImpl implements CourseInstanceStatisticsService {

    private final EnrollmentService enrollmentService;
    private final AttendanceService attendanceService;
    private final TestResultService testResultService;

    @Override
    public List<AttendanceStatsDTO> getAttendanceStatsByCourseInstance(CourseInstance courseInstance) {
        List<CourseEnrollment> enrollments = enrollmentService.findAllEnrollmentsForCourseInstance(courseInstance.getId());

        List<AttendanceStatsDTO> statsList = new ArrayList<>();

        for (CourseEnrollment enrollment : enrollments) {
            User student = enrollment.getStudent();
            Status status = enrollment.getStatus();

            Integer absentHours = attendanceService.sumAbsentHoursByStudentAndCourseInstance(student.getId(), courseInstance.getId());

            absentHours = absentHours != null ? absentHours : 0;

            statsList.add(new AttendanceStatsDTO(courseInstance, courseInstance.getCourse().getDurationHours(), absentHours, status, StatusUtil.localize(status), student));
        }

        return statsList;
    }

//    @Override
//    public List<TestResultDTO> getTestResultsByCourseInstance(CourseInstance courseInstance) {
//        List<CourseEnrollment> enrollments = enrollmentService.findAllEnrollmentsForCourseInstance(courseInstance.getId());
//
//        List<Integer> studentIds = enrollments.stream()
//                .map(enrollment -> enrollment.getStudent().getId())
//                .collect(Collectors.toList());
//
//        return testResultService.getTestResultsByStudentIdsAndCourseInstance(studentIds, courseInstance.getId());
//    }
}
