package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.config.CustomUserDetails;
import manasTrainingService.dto.UserEditDto;
import manasTrainingService.dto.register.TeacherRegisterDto;
import manasTrainingService.dto.tests.TestInstanceDto;
import manasTrainingService.dto.tests.TestResultAdminDto;
import manasTrainingService.entity.MonthYear;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.exceptions.nsee.user.EmailAlreadyExistsException;
import manasTrainingService.exceptions.nsee.user.PhoneAlreadyExistsException;
import manasTrainingService.service.AdminStatisticsService;
import manasTrainingService.service.ScheduleService;
import manasTrainingService.service.course.CourseTeacherInstanceService;
import manasTrainingService.service.test.TestAnswerService;
import manasTrainingService.service.test.TestInstanceService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.test.TestService;
import manasTrainingService.service.user.OrganizationService;
import manasTrainingService.service.user.StudentStatisticsService;
import manasTrainingService.service.user.UserProfileService;
import manasTrainingService.service.user.UserService;
import manasTrainingService.util.RoleUtil;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
    private final UserService userService;
    private final AdminStatisticsService adminStatisticsService;
    private final UserProfileService userProfileService;
    private final StudentStatisticsService studentStatisticsService;
    private final OrganizationService organizationService;
    private final CourseTeacherInstanceService courseTeacherInstanceService;
    private final ScheduleService scheduleService;
    private final TestResultService testResultService;
    private final TestInstanceService testInstanceService;
    private final TestService testService;
    private final TestAnswerService testAnswerService;
    private final MessageSource messageSource;


    @GetMapping("/teachers/add")
    public String showAddTeacherForm(Model model) {
        model.addAttribute("teacherRegisterDto", new TeacherRegisterDto());
        return "auth/register-teacher";
    }

    @PostMapping("/teachers/add")
    public String addTeacher(@Valid @ModelAttribute TeacherRegisterDto teacherRegisterDto,
                             BindingResult bindingResult,
                             RedirectAttributes redirectAttributes,
                             Model model) {

        if (bindingResult.hasErrors()) {
            return "auth/register-teacher";
        }
        try {
            userService.registerTeacher(teacherRegisterDto);
            redirectAttributes.addFlashAttribute("successMessage",
                    messageSource.getMessage("admin.teacher.add.success", null, LocaleContextHolder.getLocale())
            );
            return "redirect:/admin/users";
        } catch (EmailAlreadyExistsException e) {
            bindingResult.rejectValue("email", "email.exists", e.getMessage());
        } catch (PhoneAlreadyExistsException e) {
            bindingResult.rejectValue("phone", "phone.exists", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    messageSource.getMessage("admin.teacher.add.error", new Object[]{e.getMessage()}, LocaleContextHolder.getLocale())
            );        }
        return "auth/register-teacher";
    }

    @GetMapping("/users")
    public String showUsers(Model model) {
        List<User> users = userService.getAllUsers();
        model.addAttribute("roles", RoleUtil.getAll().keySet());
        model.addAttribute("roleDisplayNames", RoleUtil.getAll());
        model.addAttribute("users", users);
        return "admin/users";
    }

    @GetMapping("/users/{userId}")
    public String showUserDetails(@PathVariable Integer userId, Model model) {
        var profile = userProfileService.getProfileDetails(userId);
        model.addAttribute("profile", profile);

        String roleName = profile.getUser().getRole().getName().toUpperCase();
        switch (roleName) {
            case "STUDENT":
                model.addAttribute("attendanceStatsList", studentStatisticsService.getAllAttendanceStats(profile.getUser()));
                model.addAttribute("testResults", studentStatisticsService.getTestResultsByStudent(profile.getUser()));
                break;
            case "TEACHER":
                model.addAttribute("courses", courseTeacherInstanceService.getTeacherCourses(userId));
                break;
            case "ORGANIZATION":
                model.addAttribute("students", organizationService.getStudentsCourseInfoForOrganization(profile.getUser()));
                break;
        }

        return "admin/user-profile";
    }

    @GetMapping("/users/{userId}/activate")
    public String activateUser(@PathVariable Integer userId, RedirectAttributes redirectAttributes) {
        try {
            User user = userService.getUserById(userId);
            user.setIsActive(true);
            userService.saveUser(user);
            redirectAttributes.addFlashAttribute(
                    "successMessage",
                    messageSource.getMessage("admin.user.activate.success", new Object[]{user.getName()}, LocaleContextHolder.getLocale())
            );
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    messageSource.getMessage("admin.user.activate.error", new Object[]{e.getMessage()}, LocaleContextHolder.getLocale())
            );
        }
        return "redirect:/admin/users";
    }

    @GetMapping("/users/{userId}/deactivate")
    public String deactivateUser(@PathVariable Integer userId, RedirectAttributes redirectAttributes) {
        try {
            CustomUserDetails currentUser = (CustomUserDetails)
                    SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            Integer currentUserId = currentUser.getUser().getId();

            if (currentUserId.equals(userId)) {
                long activeAdmins = userService.countActiveAdmins();
                if (activeAdmins <= 1) {
                    redirectAttributes.addFlashAttribute(
                            "errorMessage",
                            messageSource.getMessage("admin.user.deactivate.self.lastAdmin", null, LocaleContextHolder.getLocale())
                    );
                    return "redirect:/admin/users";
                }
            }

            User user = userService.getUserById(userId);
            user.setIsActive(false);
            userService.saveUser(user);
            redirectAttributes.addFlashAttribute(
                    "successMessage",
                    messageSource.getMessage("admin.user.deactivate.success", new Object[]{user.getName()}, LocaleContextHolder.getLocale())
            );
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    messageSource.getMessage("admin.user.deactivate.error", new Object[]{e.getMessage()}, LocaleContextHolder.getLocale())
            );
        }
        return "redirect:/admin/users";
    }

    @GetMapping("/users/{userId}/delete")
    public String deleteUser(@PathVariable Integer userId, RedirectAttributes redirectAttributes) {
        try {
            CustomUserDetails currentUser = (CustomUserDetails)
                    SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            Integer currentUserId = currentUser.getUser().getId();

            if (currentUserId.equals(userId)) {
                redirectAttributes.addFlashAttribute(
                        "errorMessage",
                        messageSource.getMessage("admin.user.delete.self", null, LocaleContextHolder.getLocale())
                );
                return "redirect:/admin/users";
            }

            userService.deleteUserById(userId);
            redirectAttributes.addFlashAttribute(
                    "successMessage",
                    messageSource.getMessage("admin.user.delete.success", null, LocaleContextHolder.getLocale())
            );
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    messageSource.getMessage("admin.user.delete.error", new Object[]{e.getMessage()}, LocaleContextHolder.getLocale())
            );
        }
        return "redirect:/admin/users";
    }

    @GetMapping("/users/{userId}/edit")
    public String showEditUserForm(@PathVariable Integer userId, Model model, RedirectAttributes redirectAttributes) {
        try {
            UserEditDto userEditDto = userService.getUserEditDtoById(userId);
            model.addAttribute("userEditDto", userEditDto);
            return "admin/edit-user";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    messageSource.getMessage("admin.user.notFound", null, LocaleContextHolder.getLocale())
            );
            return "redirect:/admin/users";
        }
    }

    @PostMapping("/users/{userId}/edit")
    public String updateUser(@PathVariable Integer userId,
                             @Valid @ModelAttribute("userEditDto") UserEditDto userEditDto,
                             BindingResult bindingResult,
                             RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "admin/edit-user";
        }

        try {
            userEditDto.setId(userId);
            userService.updateUser(userEditDto);
            redirectAttributes.addFlashAttribute(
                    "successMessage",
                    messageSource.getMessage("admin.user.update.success", null, LocaleContextHolder.getLocale())
            );
            return "redirect:/admin/users";
        } catch (EmailAlreadyExistsException e) {
            bindingResult.rejectValue("email", "email.exists", e.getMessage());
            return "admin/edit-user";

        } catch (PhoneAlreadyExistsException e) {
            bindingResult.rejectValue("phone", "email.exists", e.getMessage());
            return "admin/edit-user";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    messageSource.getMessage("admin.user.update.error", new Object[]{e.getMessage()}, LocaleContextHolder.getLocale())
            );
            return "redirect:/admin/users";
        }
    }

    @GetMapping("/statistics")
    public String viewUserStatistics(Model model) {
        model.addAttribute("userStats", adminStatisticsService.getSystemStatistics());
        model.addAttribute("months", Arrays.asList(MonthYear.values()));
        return "admin/statistics";
    }

    @GetMapping("/test-results")
    public String viewStudentsTestsResults(Model model){
        model.addAttribute("results", testResultService.getAllResults());
        return "admin/test-results";
    }

    @GetMapping("/test-results/{id}")
    public String viewTestResultDetails(@PathVariable int id, Model model){
        TestResultAdminDto testResultAdminDto = testResultService.getTestResultById(id);
        TestInstanceDto testInstanceDto = testInstanceService.getTestInstanceById(testResultAdminDto.getTestInstance().getId());
        if(!testService.testExistById(testInstanceDto.getTest().getId())){
            throw new NoAccessException(
                    messageSource.getMessage("admin.test.notFound", null, LocaleContextHolder.getLocale())
            );
        }
        model.addAttribute("test", testService.getTestByIdForTestResult(testInstanceDto.getId(), testResultAdminDto.getStudent().getId()));
        model.addAttribute("result", testResultAdminDto);
        model.addAttribute("answers", testAnswerService.getAnswersByAttemtId(testResultAdminDto.getId()));
        return "admin/test_result_details";
    }
}