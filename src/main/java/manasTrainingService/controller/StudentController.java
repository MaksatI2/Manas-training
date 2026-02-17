package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.edit.UserProfileEditDto;
import manasTrainingService.dto.instance.CourseEnrollmentCardDTO;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.tests.TestInstanceDto;
import manasTrainingService.dto.tests.StudentTestListItemDto;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.TestInstance;
import manasTrainingService.exceptions.nsee.TestInstanceNotFoundException;
import manasTrainingService.dto.statistics.AttendanceStatsDTO;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.user.PhoneAlreadyExistsException;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.test.TestInstanceService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.test.TestService;
import manasTrainingService.service.user.StudentService;
import manasTrainingService.service.user.StudentStatisticsService;
import manasTrainingService.service.user.UserService;
import manasTrainingService.util.DateUtil;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Controller
@RequestMapping("/student")
@RequiredArgsConstructor
public class StudentController {
    private final StudentService studentService;
    private final UserService userService;
    private final EnrollmentService enrollmentService;
    private final CourseInstanceService courseInstanceService;
    private final TestInstanceService testInstanceService;
    private final TestResultService testResultService;
    private final TestService testService;
    private final StudentStatisticsService studentStatisticsService;
    private final MessageSource messageSource;

    @GetMapping("/profile")
    public String profilePage(Model model) {
        model.addAttribute("student", studentService.getAuthorizedStudentProfile(userService.getAuthorizedUser()));
        return "student/profile-view";
    }

    @GetMapping("/profile/edit")
    public String editStudentProfilePage(Model model) {
        model.addAttribute("studentProfile",
                studentService.getStudentInformationForEdit(userService.getAuthorizedUser()));
        return "student/profile-edit";
    }

    @PostMapping("/profile/edit")
    public String editStudentProfile(@Valid @ModelAttribute("studentProfile") UserProfileEditDto userProfileEditDto,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model) {
        Locale locale = LocaleContextHolder.getLocale();
        if (bindingResult.hasErrors()) {
            return "student/profile-edit";
        }

        try {
            studentService.editStudentInformation(userProfileEditDto);
            redirectAttributes.addFlashAttribute(
                    "successMessage",
                    messageSource.getMessage("profile.update.success", null, locale));
            return "redirect:/student/profile";
        } catch (PhoneAlreadyExistsException e) {
            model.addAttribute(
                    "errorMessage",
                    messageSource.getMessage("phone.already.exists", null, locale));
            model.addAttribute("studentProfile", userProfileEditDto);
            return "student/profile-edit";
        }
    }

    @GetMapping("my-courses")
    public String getCourses(Model model) {
        List<CourseEnrollmentCardDTO> studentCourses = enrollmentService.getStudentCourses();
        model.addAttribute("courses", studentCourses);
        model.addAttribute("finishedCourses", enrollmentService.getStudentFinishedCourses());
        return "student/my-courses";
    }

    @GetMapping("/course/{id}")
    public String viewStudentCourse(@PathVariable Integer id, Model model) {
        enrollmentService.hasAccess(id);
        CourseInstanceDTO courseInstanceDto = courseInstanceService.getCourseInstanceById(id);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        model.addAttribute("courseInstance", courseInstanceDto);
        model.addAttribute("now", LocalDateTime.now());
        try {
            TestInstanceDto testInstanceDto = testInstanceService.getTestInstanceByCourseInstanceId(id);
            model.addAttribute("testInstance", testInstanceDto);
            if (testResultService.userHasTestAttempt(testInstanceDto.getId())) {
                model.addAttribute(
                        "testResult",
                        testResultService.getResultsByTestInstanceIdAndStudentId(testInstanceDto.getId()));
            }
            model.addAttribute("isAvailableTime", testInstanceService.isValidAccessTime(testInstanceDto.getId()));
            model.addAttribute("testExits", testService.testExistById(testInstanceDto.getTest().getId()));
            model.addAttribute("startDate", testInstanceDto.getStartDate().format(formatter));
            model.addAttribute("endDate", testInstanceDto.getEndDate().format(formatter));
        } catch (TestInstanceNotFoundException e) {
            model.addAttribute(
                    "testInstanceNotFound",
                    messageSource.getMessage(
                            "test.instance.not.found",
                            new Object[] { courseInstanceDto.getCourseTitle() },
                            LocaleContextHolder.getLocale()));
        }
        return "student/course-detail";
    }

    @GetMapping("/statistics")
    public String viewStudentStatistics(Model model) {
        User student = userService.getAuthorizedUser();
        List<AttendanceStatsDTO> stats = studentStatisticsService.getAllAttendanceStats(student);
        model.addAttribute("attendanceStatsList", stats);
        model.addAttribute("testResults", studentStatisticsService.getTestResultsByStudent(student));
        return "student/statistics";
    }

    @GetMapping("/my-tests")
    public String viewMyTests(Model model) {
        User student = userService.getAuthorizedUser();
        List<CourseEnrollment> enrollments = enrollmentService.getAllEnrollmentsByStudentId(student.getId());
        List<StudentTestListItemDto> activeTests = new ArrayList<>();
        List<StudentTestListItemDto> pastTests = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now();

        for (CourseEnrollment enrollment : enrollments) {
            Integer courseInstanceId = enrollment.getCourseInstance().getId();
            Optional<TestInstance> testInstanceOpt = testInstanceService
                    .getTestInstanceModelByCourseInstanceIdWithDetails(courseInstanceId);
            if (testInstanceOpt.isEmpty()) {
                continue;
            }

            TestInstance testInstance = testInstanceOpt.get();
            int attemptCount = testResultService.countUserTestAttempts(testInstance.getId());
            boolean hasPassedAttempt = testResultService.hasPassedAttempt(testInstance.getId());
            boolean hasAttempt = attemptCount > 0;
            boolean isAvailable = testInstance.getScheduledStart().isBefore(now)
                    && testInstance.getScheduledEnd().isAfter(now);
            boolean isEnded = testInstance.getScheduledEnd().isBefore(now);
            boolean isActive = Boolean.TRUE.equals(testInstance.getTest().getIsActive());
            boolean canStart = isActive && isAvailable && attemptCount < 2;

            StudentTestListItemDto item = StudentTestListItemDto.builder()
                    .testInstanceId(testInstance.getId())
                    .courseTitle(testInstance.getTest().getCourse().getTitle())
                    .courseInstanceTitle(testInstance.getInstance().getTitle())
                    .testTitle(testInstance.getTest().getTitle())
                    .startAt(testInstance.getScheduledStart())
                    .endAt(testInstance.getScheduledEnd())
                    .timeRange(DateUtil.formatWithTime(testInstance.getScheduledStart()) + " - "
                            + DateUtil.formatWithTime(testInstance.getScheduledEnd()))
                    .isActive(isActive)
                    .isAvailable(isAvailable)
                    .isEnded(isEnded)
                    .hasAttempt(hasAttempt)
                    .canStart(canStart)
                    .attemptCount(attemptCount)
                    .hasPassedAttempt(hasPassedAttempt)
                    .build();

            if (hasPassedAttempt || (isEnded && hasAttempt)) {
                pastTests.add(item);
            } else {
                activeTests.add(item);
            }
        }

        activeTests.sort(Comparator.comparing(StudentTestListItemDto::getStartAt));
        pastTests.sort(Comparator.comparing(StudentTestListItemDto::getStartAt).reversed());

        model.addAttribute("activeTests", activeTests);
        model.addAttribute("pastTests", pastTests);
        return "student/my-tests";
    }

}
