package manasTrainingService.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.register.OrganizationRegisterDto;
import manasTrainingService.dto.PasswordResetDto;
import manasTrainingService.dto.register.StudentRegisterDto;
import manasTrainingService.entity.RememberMeToken;
import manasTrainingService.exceptions.nsee.user.*;
import manasTrainingService.service.user.RememberMeService;
import manasTrainingService.service.user.UserService;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;
    private final RememberMeService rememberMeService;

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

        Optional<String> tokenOpt = rememberMeService.getRememberMeTokenFromCookie(request);
        if (tokenOpt.isPresent()) {
            Optional<manasTrainingService.entity.User> userOpt = rememberMeService.validateAndRefreshToken(tokenOpt.get(), request);
            if (userOpt.isPresent()) {
                manasTrainingService.entity.User user = userOpt.get();
                model.addAttribute("quickLoginAvailable", true);
                model.addAttribute("quickLoginEmail", user.getEmail());
                model.addAttribute("quickLoginName", user.getName() + " " + user.getLastName());
            }
        }

        return "auth/login";
    }

    @PostMapping("/quick-login")
    public String quickLogin(HttpServletRequest request, HttpServletResponse response,
                             RedirectAttributes redirectAttributes) {
        Optional<String> tokenOpt = rememberMeService.getRememberMeTokenFromCookie(request);

        if (tokenOpt.isPresent()) {
            Optional<manasTrainingService.entity.User> userOpt = rememberMeService.validateAndRefreshToken(tokenOpt.get(), request);
            if (userOpt.isPresent()) {
                return "redirect:/";
            }
        }

        redirectAttributes.addAttribute("error", "Сессия истекла. Пожалуйста, войдите снова.");
        rememberMeService.removeRememberMeCookie(response);
        return "redirect:/auth/login";
    }

    @PostMapping("/dismiss-quick-login")
    public String dismissQuickLogin(HttpServletRequest request, HttpServletResponse response) {
        Optional<String> tokenOpt = rememberMeService.getRememberMeTokenFromCookie(request);
        if (tokenOpt.isPresent()) {
            rememberMeService.invalidateToken(tokenOpt.get());
        }
        rememberMeService.removeRememberMeCookie(response);
        return "redirect:/auth/login";
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
            return "redirect:/auth/verify-pending?email=" + studentRegisterDto.getEmail();
        } catch (EmailAlreadyExistsException e) {
            bindingResult.rejectValue("email", "email.exists", e.getMessage());
        } catch (PhoneAlreadyExistsException e) {
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
            return "redirect:/auth/verify-pending?email=" + organizationRegisterDto.getEmail();
        } catch (EmailAlreadyExistsException e) {
            bindingResult.rejectValue("email", "email.exists", e.getMessage());
        } catch (PhoneAlreadyExistsException e) {
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
        if (email.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Почта не может быть пустой");
            return "redirect:/auth/forgot-password";

        }
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

    @GetMapping("/verify-pending")
    public String showVerificationPendingPage(@RequestParam("email") String email, Model model) {
        model.addAttribute("email", email);
        return "auth/verify-pending";
    }

    @PostMapping("/resend-verification")
    public String resendVerificationEmail(@RequestParam("email") String email, RedirectAttributes redirectAttributes) {
        try {
            userService.resendVerificationEmail(email);
            redirectAttributes.addFlashAttribute("message", "Письмо с подтверждением повторно отправлено на " + email);
        } catch (UserNotFoundException e) {
            redirectAttributes.addFlashAttribute("error", "Пользователь с таким email не найден.");
        } catch (EmailAlreadyVerifiedException e) {
            redirectAttributes.addFlashAttribute("error", "Email уже подтвержден. Вы можете войти в систему.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Произошла ошибка при отправке письма. Попробуйте позже.");
        }
        return "redirect:/auth/verify-pending?email=" + email;
    }

    @GetMapping("/manage-devices")
    public String manageDevices(Model model, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/auth/login";
        }

        String email = authentication.getName();
        List<RememberMeToken> activeTokens = rememberMeService.getUserActiveTokens(email);
        model.addAttribute("activeTokens", activeTokens);
        return "auth/manage-devices";
    }

    @PostMapping("/revoke-token")
    public String revokeToken(@RequestParam("tokenId") Long tokenId,
                              Authentication authentication,
                              HttpServletRequest request,
                              HttpServletResponse response,
                              RedirectAttributes redirectAttributes) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/auth/login";
        }

        String currentEmail = authentication.getName();

        Optional<String> currentTokenOpt = rememberMeService.getRememberMeTokenFromCookie(request);

        try {
            rememberMeService.invalidateTokenById(tokenId, currentEmail);

            if (currentTokenOpt.isPresent()) {
                Optional<RememberMeToken> tokenInfo = rememberMeService.getTokenInfo(currentTokenOpt.get());
                if (tokenInfo.isPresent() && tokenInfo.get().getId().equals(tokenId)) {
                    rememberMeService.removeRememberMeCookie(response);
                }
            }

            redirectAttributes.addFlashAttribute("message", "Устройство успешно отключено.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Ошибка при отключении устройства.");
        }

        return "redirect:/auth/manage-devices";
    }

    @PostMapping("/logout-all-devices")
    public String logoutAllDevices(Authentication authentication,
                                   HttpServletRequest request,
                                   HttpServletResponse response,
                                   RedirectAttributes redirectAttributes) {
        if (authentication != null && authentication.isAuthenticated()) {
            String email = authentication.getName();
            rememberMeService.invalidateAllUserTokens(email);
            rememberMeService.removeRememberMeCookie(response);
            new SecurityContextLogoutHandler().logout(request, response, authentication);

            redirectAttributes.addFlashAttribute("message", "Вы вышли из всех устройств.");
        }

        return "redirect:/auth/login";
    }
}