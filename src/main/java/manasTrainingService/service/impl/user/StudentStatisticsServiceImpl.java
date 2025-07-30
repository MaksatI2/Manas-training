package manasTrainingService.service.impl.user;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.statistics.AttendanceStatsDTO;
import manasTrainingService.dto.statistics.TestResultDTO;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.TestResult;
import manasTrainingService.entity.User;

import manasTrainingService.service.AttendanceService;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.ScheduleService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.user.StudentStatisticsService;
import manasTrainingService.util.DateUtil;
import manasTrainingService.util.StatusUtil;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StudentStatisticsServiceImpl implements StudentStatisticsService {

    private final EnrollmentService enrollmentService;
    private final ScheduleService scheduleService;
    private final AttendanceService attendanceService;
    private final TestResultService testResultService;

    @Override
    public List<AttendanceStatsDTO> getAllAttendanceStats(User student) {
        List<CourseEnrollment> enrollments = enrollmentService
                .findAllActiveEnrollmentsByStudentId(student.getId());

        List<AttendanceStatsDTO> statsList = new ArrayList<>();

        for (CourseEnrollment enrollment : enrollments) {
            CourseInstance course = enrollment.getCourseInstance();
            Status status = enrollment.getStatus();

            Integer totalHours = scheduleService
                    .sumActiveScheduleHoursByCourseInstanceId(course.getId());

            Integer absentHours = attendanceService
                    .sumAbsentHoursByStudentAndCourseInstance(student.getId(), course.getId());

            totalHours = totalHours != null ? totalHours : 0;
            absentHours = absentHours != null ? absentHours : 0;

            statsList.add(new AttendanceStatsDTO(course, totalHours, absentHours, status, StatusUtil.localize(status), enrollment.getStudent()));
        }

        statsList.sort(Comparator.comparing(stat -> !stat.getCourseInstance().getIsActive()));

        return statsList;
    }

    @Override
    public List<TestResultDTO> getTestResultsByStudent(User student) {
        List<TestResult> results = testResultService.getTestResultsByStudentId(student.getId());

        return results.stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<TestResultDTO> getTestResultsByCourseInstanceId(Integer courseInstanceId) {
        List<TestResult> results = testResultService.getTestResultsByCourseInstanceId(courseInstanceId);

        return results.stream()
                .map(this::toDtoWithStudentName)
                .collect(Collectors.toList());
    }

    private TestResultDTO toDto(TestResult result) {
        return TestResultDTO.builder()
                .courseTitle(result.getTestInstance().getInstance().getTitle())
                .testTitle(result.getTestInstance().getInstance().getTitle())
                .score(result.getScore())
                .isPassed(result.getIsPassed())
                .submittedAt(result.getSubmittedAt())
                .localisedTime(DateUtil.formatWithTime(result.getSubmittedAt()))
                .build();
    }

    private TestResultDTO toDtoWithStudentName(TestResult result) {
        return TestResultDTO.builder()
                .courseTitle(result.getTestInstance().getInstance().getTitle())
                .testTitle(result.getTestInstance().getInstance().getTitle())
                .score(result.getScore())
                .isPassed(result.getIsPassed())
                .submittedAt(result.getSubmittedAt())
                .localisedTime(DateUtil.formatWithTime(result.getSubmittedAt()))
                .studentName(result.getStudent().getName() + " " + result.getStudent().getLastName())
                .build();
    }



}
