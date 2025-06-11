package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.register.TeacherRegisterDto;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.EmailAlreadyExistsException;
import manasTrainingService.exceptions.nsee.PhoneAlreadyExistsException;
import manasTrainingService.service.RoleService;
import manasTrainingService.service.StudentService;
import manasTrainingService.service.UserService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
    private final StudentService studentService;
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
    public String showUsers(
            @RequestParam("page") Optional<Integer> page,
            @RequestParam("size") Optional<Integer> size,
            @RequestParam("role") Optional<String> role,
            @RequestParam("status") Optional<String> status,
            @RequestParam("search") Optional<String> search,
            Model model) {

        int currentPage = page.orElse(1);
        int pageSize = size.orElse(10);

        String roleFilter = role.orElse("");
        String statusFilter = status.orElse("");
        String searchFilter = search.orElse("");

        Page<User> userPage = userService.getUsersWithFilters(
                roleFilter.isEmpty() ? null : roleFilter,
                statusFilter.isEmpty() ? null : statusFilter,
                searchFilter.isEmpty() ? null : searchFilter,
                PageRequest.of(currentPage - 1, pageSize)
        );

        model.addAttribute("userPage", userPage);
        model.addAttribute("roles", roleService.getAllRoles());
        model.addAttribute("selectedRole", roleFilter);
        model.addAttribute("selectedStatus", statusFilter);
        model.addAttribute("searchQuery", searchFilter);

        int totalPages = userPage.getTotalPages();
        if (totalPages > 0) {
            List<Integer> pageNumbers = IntStream.rangeClosed(1, totalPages)
                    .boxed()
                    .collect(Collectors.toList());
            model.addAttribute("pageNumbers", pageNumbers);
        }

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

    @GetMapping("/users/{userId}")
    public String viewUser(@PathVariable Integer userId, Model model) {
        try {
            User user = userService.getUserById(userId);
            model.addAttribute("user", user);
            return "admin/user-details";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Пользователь не найден");
            return "redirect:/admin/users";
        }
    }
}