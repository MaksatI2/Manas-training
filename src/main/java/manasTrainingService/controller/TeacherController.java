package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.TeacherCardDto;
import manasTrainingService.dto.edit.TeacherProfileEditDto;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.profile.TeacherProfileDto;
import manasTrainingService.dto.statistics.TestResultDTO;
import manasTrainingService.dto.tests.TestInstanceDto;
import manasTrainingService.entity.TestInstance;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.TestInstanceNotFoundException;
import manasTrainingService.dto.statistics.AttendanceStatsDTO;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.exceptions.nsee.user.PhoneAlreadyExistsException;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.LessonAccessService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseInstanceStatisticsService;
import manasTrainingService.service.course.CourseTeacherInstanceService;
import manasTrainingService.service.test.TestInstanceService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.user.RoleService;
import manasTrainingService.service.user.StudentStatisticsService;
import manasTrainingService.service.user.TeacherService;
import manasTrainingService.service.user.UserService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/teacher")
@RequiredArgsConstructor
public class TeacherController {

    private final UserService userService;
    private final TeacherService teacherService;
    private final CourseTeacherInstanceService courseTeacherInstanceService;
    private final CourseInstanceService courseInstanceService;
    private final RoleService roleService;
    private final TestInstanceService testInstanceService;
    private final CourseInstanceStatisticsService courseInstanceStatisticsService;
    private final LessonAccessService lessonAccessService;
    private final TestResultService testResultService;
    private final StudentStatisticsService studentStatisticsService;

    @GetMapping("/profile")
    public String viewProfile(Model model) {
        User currentUser = userService.getAuthorizedUser();
        TeacherProfileDto teacherProfile = teacherService.getTeacherProfile(currentUser);
        model.addAttribute("teacher", teacherProfile);
        return "teacher/profile-view";
    }

    @GetMapping("/profile/edit")
    public String editProfileForm(Model model) {
        model.addAttribute("teacherEditDto", teacherService.getTeacherInformationForEdit(userService.getAuthorizedUser()));
        return "teacher/profile-edit";
    }

    @PostMapping("/profile/edit")
    public String editProfile(@Valid @ModelAttribute("teacherEditDto") TeacherProfileEditDto teacherProfileEditDto,
                              BindingResult bindingResult,
                              RedirectAttributes redirectAttributes,
                              Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("teacherEditDto", teacherProfileEditDto);
            return "teacher/profile-edit";
        }

        try {
            userService.editTeacherInformation(teacherProfileEditDto);
            redirectAttributes.addFlashAttribute("successMessage", "Профиль успешно обновлен!");
            return "redirect:/teacher/profile";
        } catch (PhoneAlreadyExistsException e) {
            bindingResult.rejectValue("phone", "phone.exists", e.getMessage());
            model.addAttribute("teacherEditDto", teacherProfileEditDto);
            return "teacher/profile-edit";
        }
    }

    @GetMapping("/my-courses")
    public String viewTeacherCourses(Model model) {
        Integer userId = userService.getAuthorizedUser().getId();
        model.addAttribute("courses", courseTeacherInstanceService.getTeacherCourses(userId));
        return "teacher/my-courses";
    }

    @GetMapping("/course/{id}")
    public String viewTeacherCourse(@PathVariable Integer id,
                                    Model model) {
        courseTeacherInstanceService.hasAccess(id);
        CourseInstanceDTO courseInstanceDto = courseInstanceService.getCourseInstanceById(id);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        model.addAttribute("courseInstance", courseInstanceDto);
        if(userService.getAuthorizedUser().getRole() == roleService.getTeacherRoleId()){
            model.addAttribute("role", roleService.getTeacherRoleId().getName());
        }
        try {
            TestInstanceDto testInstanceDto = testInstanceService.getTestInstanceByCourseInstanceId(id);
            model.addAttribute("testInstance", testInstanceDto);
            model.addAttribute("startDate", testInstanceDto.getStartDate().format(formatter));
            model.addAttribute("endDate", testInstanceDto.getEndDate().format(formatter));
            model.addAttribute("hasResults", testResultService.hasResultsByTestInstanceId(testInstanceDto.getId()));
        } catch (TestInstanceNotFoundException e) {
            model.addAttribute("testInstanceNotFound", e.getMessage());
        }
        return "teacher/course-detail";
    }
    @GetMapping("/course/{id}/statistics")
    public String viewCourseInstanceStatistics(@PathVariable("id") Integer id, Model model) {
        CourseInstance courseInstance = courseInstanceService.getCourseInstanceModelById(id);
        if (!lessonAccessService.canAccessInstanceStatistics(courseInstance)) {
            throw new NoAccessException("У вас нет доступа к потоку курса");
        }

        List<AttendanceStatsDTO> attendanceStats = courseInstanceStatisticsService.getAttendanceStatsByCourseInstance(courseInstance);

        List<TestResultDTO> results = studentStatisticsService.getTestResultsByCourseInstanceId(id);

        model.addAttribute("results", results);
        model.addAttribute("courseInstance", courseInstance);
        model.addAttribute("attendanceStatsList", attendanceStats);


        return "teacher/course-statistics";
    }


    @GetMapping
    public String listTeachers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "9") int size,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String department,
            Model model) {

        Pageable pageable = PageRequest.of(page, size);
        Page<TeacherCardDto> teacherPage = teacherService.getTeachers(pageable, search, department);

        model.addAttribute("teachers", teacherPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", teacherPage.getTotalPages());
        model.addAttribute("search", search);
        model.addAttribute("department", department);
        model.addAttribute("size", size);

        return "teacher/list";
    }

    @GetMapping("/{id}")
    public String viewTeacherProfile(@PathVariable("id") Long id, Model model) {
        TeacherProfileDto teacherProfile = teacherService.getTeacherProfileById(id);
        model.addAttribute("teacher", teacherProfile);
        return "teacher/teacher-profile";
    }
}
