package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.register.TeacherRegisterDto;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.EmailAlreadyExistsException;
import manasTrainingService.exceptions.nsee.PhoneAlreadyExistsException;
import manasTrainingService.service.RoleService;
import manasTrainingService.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
    private final UserService userService;
    private final RoleService roleService;

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
        model.addAttribute("roles", roleService.getAllRoles());
        model.addAttribute("users", users);
        return "admin/users";
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
}