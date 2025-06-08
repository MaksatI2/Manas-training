package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.OrganizationRegisterDto;
import manasTrainingService.exceptions.OrganizationEmailAlreadyExistsException;
import manasTrainingService.exceptions.OrganizationNameAlreadyExistsException;
import manasTrainingService.exceptions.OrganizationPhoneAlreadyExistsException;
import manasTrainingService.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;

    @GetMapping("/register")
    public String showRegistrationChoice() {
        return "auth/register-choice";
    }

    @GetMapping("/register/student")
    public String showStudentRegistration(Model model) {
        model.addAttribute("userType", "student");
        return "auth/register-student";
    }

    @GetMapping("/register/company")
    public String showCompanyRegistration(Model model) {
        model.addAttribute("userType", "company");
        model.addAttribute("organizationDto", new OrganizationRegisterDto());
        return "auth/register-company";
    }

    @GetMapping("/login")
    public String showLogin(
            @RequestParam(value = "message", required = false) String message,
            @RequestParam(value = "error", required = false) String error,
            Model model) {
        if (message != null && !message.isEmpty()) {
            model.addAttribute("message", message);
        }
        if (error != null && !error.isEmpty()) {
            model.addAttribute("error", error);
        }
        return "auth/login";
    }

    @PostMapping("/register/student")
    public String registerStudent(
            RedirectAttributes redirectAttributes) {

        try {
            redirectAttributes.addAttribute("message",
                    "Регистрация прошла успешно! Войдите в свой аккаунт.");
            return "redirect:/auth/login";
        } catch (Exception e) {
            redirectAttributes.addAttribute("error",
                    "Ошибка при регистрации: " + e.getMessage());
            return "redirect:/auth/register/student";
        }
    }

    @PostMapping("/register/company")
    public String registerCompany(
            @Valid @ModelAttribute("organizationDto") OrganizationRegisterDto organizationRegisterDto,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("userType", "company");
            return "auth/register-company";
        }

        try {
            userService.registerOrganization(organizationRegisterDto);
            redirectAttributes.addAttribute("message",
                    "Регистрация компании прошла успешно! Войдите в свой аккаунт.");
            return "redirect:/auth/login";
        } catch (OrganizationEmailAlreadyExistsException e) {
            bindingResult.rejectValue("email", "email.exists", e.getMessage());
        } catch (OrganizationPhoneAlreadyExistsException e) {
            bindingResult.rejectValue("phone", "phone.exists", e.getMessage());
        } catch (OrganizationNameAlreadyExistsException e) {
            bindingResult.rejectValue("companyName", "companyName.exists", e.getMessage());
        }
        model.addAttribute("userType", "company");
        return "auth/register-company";
    }
}