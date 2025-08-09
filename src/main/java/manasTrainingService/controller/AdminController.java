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
                    "Преподаватель успешно добавлен! Ссылка для активации отправлена на email.");
            return "redirect:/admin/users";
        } catch (EmailAlreadyExistsException e) {
            bindingResult.rejectValue("email", "email.exists", e.getMessage());
        } catch (PhoneAlreadyExistsException e) {
            bindingResult.rejectValue("phone", "phone.exists", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
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
            redirectAttributes.addFlashAttribute("successMessage",
                    "Пользователь " + user.getName() + " успешно активирован!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Ошибка при активации пользователя: " + e.getMessage());
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
                    redirectAttributes.addFlashAttribute("errorMessage",
                            "Невозможно деактивировать себя, так как Вы — последний активный администратор.");
                    return "redirect:/admin/users";
                }
            }

            User user = userService.getUserById(userId);
            user.setIsActive(false);
            userService.saveUser(user);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Пользователь " + user.getName() + " успешно деактивирован!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Ошибка при деактивации пользователя: " + e.getMessage());
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
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Вы не можете удалить самого себя.");
                return "redirect:/admin/users";
            }

            userService.deleteUserById(userId);
            redirectAttributes.addFlashAttribute("successMessage", "Пользователь успешно удален.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Ошибка при удалении пользователя: " + e.getMessage());
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
            redirectAttributes.addFlashAttribute("errorMessage", "Пользователь не найден");
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
            redirectAttributes.addFlashAttribute("successMessage", "Пользователь успешно обновлен");
            return "redirect:/admin/users";
        } catch (EmailAlreadyExistsException e) {
            bindingResult.rejectValue("email", "email.exists", e.getMessage());
            return "admin/edit-user";

        } catch (PhoneAlreadyExistsException e) {
            bindingResult.rejectValue("phone", "email.exists", e.getMessage());
            return "admin/edit-user";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Ошибка при обновлении пользователя: " + e.getMessage());
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
            throw new NoAccessException("Такого теста уже не существует");
        }
        model.addAttribute("test", testService.getTestByIdForTestResult(testInstanceDto.getId(), testResultAdminDto.getStudent().getId()));
        model.addAttribute("result", testResultAdminDto);
        model.addAttribute("answers", testAnswerService.getAnswersByAttemtId(testResultAdminDto.getId()));
        return "admin/test_result_details";
    }
}