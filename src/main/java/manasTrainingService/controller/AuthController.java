package manasTrainingService.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/auth")
public class AuthController {

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
            RedirectAttributes redirectAttributes) {
        try {
            redirectAttributes.addAttribute("message",
                    "Регистрация компании прошла успешно! Войдите в свой аккаунт.");
            return "redirect:/auth/login";
        } catch (Exception e) {
            redirectAttributes.addAttribute("error",
                    "Ошибка при регистрации компании: " + e.getMessage());
            return "redirect:/auth/register/company";
        }
    }
}