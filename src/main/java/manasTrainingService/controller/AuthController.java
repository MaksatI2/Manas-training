package manasTrainingService.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.OrganizationRegisterDto;
import manasTrainingService.dto.PasswordResetDto;
import manasTrainingService.dto.StudentRegisterDto;
import manasTrainingService.exceptions.nsee.*;
import manasTrainingService.service.UserService;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.web.WebAttributes;
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
        model.addAttribute("studentRegisterDto", new StudentRegisterDto());
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
            HttpServletRequest request,
            Model model
    ) {
        if (message != null) {
            model.addAttribute("message", message);
        }

        if (error != null) {
            Exception ex = (Exception) request.getSession()
                    .getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);

            if (ex instanceof DisabledException) {
                model.addAttribute("error", "Ваш email не подтвержден. Пожалуйста, проверьте почту.");
            } else {
                model.addAttribute("error", "Неверный email или пароль");
            }
        }

        return "auth/login";
    }

    @PostMapping("/register/student")
    public String registerStudent(
            @Valid @ModelAttribute("studentRegisterDto") StudentRegisterDto studentRegisterDto,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("userType", "student");
            return "auth/register-student";
        }

        try {
            userService.registerStudent(studentRegisterDto);
            redirectAttributes.addAttribute("message",
                    "Регистрация прошла успешно! Войдите в свой аккаунт.");
            return "redirect:/auth/login";
        } catch (StudentEmailAlreadyExistsException e) {
            bindingResult.rejectValue("email", "email.exists", e.getMessage());
        } catch (StudentPhoneAlreadyExistsException e) {
            bindingResult.rejectValue("phone", "phone.exists", e.getMessage());
        } catch (OrganizationCodeNotFound e) {
            bindingResult.rejectValue("organizationCode", "organizationCode.notfound", e.getMessage());
        }
        model.addAttribute("userType", "student");
        return "auth/register-student";
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

    @GetMapping("/verify-email")
    public String verifyEmail(@RequestParam("token") String token, RedirectAttributes redirectAttributes) {
        boolean success = userService.verifyEmailToken(token);
        if (success) {
            redirectAttributes.addAttribute("message", "Email успешно подтверждён! Теперь вы можете войти.");
        } else {
            redirectAttributes.addAttribute("error", "Ссылка недействительна или истекла.");
        }
        return "redirect:/auth/login";
    }

    @GetMapping("/forgot-password")
    public String forgotPasswordPage() {
        return "auth/forgot-password";
    }

    @PostMapping("/forgot-password")
    public String sendResetEmail(@RequestParam("email") String email, RedirectAttributes redirectAttributes) {
        try {
            userService.sendResetToken(email);
            redirectAttributes.addFlashAttribute("message", "Инструкция по сбросу пароля отправлена на указанный email.");
        } catch (UserNotFoundException e) {
            redirectAttributes.addFlashAttribute("error", "Пользователь с таким email не найден.");
        }
        return "redirect:/auth/forgot-password";
    }

    @GetMapping("/reset-password")
    public String resetPasswordPage(@RequestParam("token") String token, Model model, RedirectAttributes redirectAttributes) {
        if (!userService.isValidResetToken(token)) {
            redirectAttributes.addFlashAttribute("error", "Ссылка для сброса пароля недействительна или устарела.");
            return "redirect:/auth/forgot-password";
        }

        PasswordResetDto passwordResetDto = new PasswordResetDto();
        passwordResetDto.setToken(token);

        model.addAttribute("passwordResetDto", passwordResetDto);
        return "auth/reset-password";
    }

    @PostMapping("/reset-password")
    public String handlePasswordReset(
            @Valid @ModelAttribute("passwordResetDto") PasswordResetDto passwordResetDto,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (!userService.isValidResetToken(passwordResetDto.getToken())) {
            redirectAttributes.addFlashAttribute("error", "Ссылка для сброса пароля недействительна или устарела.");
            return "redirect:/auth/forgot-password";
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("passwordResetDto", passwordResetDto);
            return "auth/reset-password";
        }

        boolean success = userService.resetPassword(passwordResetDto.getToken(), passwordResetDto.getPassword());
        if (success) {
            redirectAttributes.addFlashAttribute("message", "Пароль успешно изменён. Войдите в систему.");
            return "redirect:/auth/login";
        } else {
            redirectAttributes.addFlashAttribute("error", "Произошла ошибка при сбросе пароля. Попробуйте еще раз.");
            model.addAttribute("passwordResetDto", passwordResetDto);
            return "auth/reset-password";
        }
    }
}