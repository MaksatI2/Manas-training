package manasTrainingService.service.impl;


import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.statistics.AdminStatisticsDto;
import manasTrainingService.dto.statistics.UserStatisticsDto;
import manasTrainingService.service.AdminStatisticsService;
import manasTrainingService.service.CertificateService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.test.TestService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Service
@RequiredArgsConstructor
public class AdminStatisticsServiceImpl implements AdminStatisticsService {

    private final CourseService courseService;
    private final TestService testService;
    private final CertificateService certificateService;
    private final CourseInstanceService courseInstanceService;
    private final TestResultService testResultService;

    private final UserService userService;

    @Override
    public AdminStatisticsDto getSystemStatistics() {
        UserStatisticsDto userStatisticsDto = userService.getUserStatistics();

        long students = userStatisticsDto.getTotalStudents();
        long teachers = userStatisticsDto.getTotalTeachers();
        long orgs = userStatisticsDto.getTotalOrganizations();
        long inactiveUsers = userStatisticsDto.getTotalInactiveUsers();

        long courses = courseService.getTotalCourses();
        long tests = testService.getTotalTests();
        long certs = certificateService.getTotalCertificates();
        long completedCourses = courseInstanceService.getCompletedCoursesCount();
        long certsThisMonth = certificateService.getCertificatesIssuedThisMonth(getStartOfMonthDate(), getEndOfMonthDate());

        BigDecimal avgScore = testResultService.getAverageScore();
        long passedTests = testResultService.getTotalPassedTestsInMonth(getStartOfMonth(), getEndOfMonth());

        return AdminStatisticsDto.builder()
                .totalInactiveUsers(inactiveUsers)
                .totalStudents(students)
                .totalTeachers(teachers)
                .totalCourses(courses)
                .totalTests(tests)
                .totalCertificates(certs)
                .totalOrganizations(orgs)
                .completedCourses(completedCourses)
                .certificatesIssuedThisMonth(certsThisMonth)
                .averageTestScore(avgScore)
                .totalPassedTests(passedTests)
                .build();
    }


    private LocalDateTime getStartOfMonth() {
        LocalDate now = LocalDate.now();
        return now.withDayOfMonth(1).atStartOfDay();
    }

    private LocalDate getStartOfMonthDate() {
        LocalDate now = LocalDate.now();
        return now.withDayOfMonth(1);
    }

    private LocalDateTime getEndOfMonth() {
        LocalDate now = LocalDate.now();
        return now.withDayOfMonth(now.lengthOfMonth()).atTime(LocalTime.MAX);
    }

    private LocalDate getEndOfMonthDate() {
        LocalDate now = LocalDate.now();
        return now.withDayOfMonth(now.lengthOfMonth());
    }
}
