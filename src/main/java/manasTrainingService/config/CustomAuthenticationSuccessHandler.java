package manasTrainingService.config;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import manasTrainingService.entity.User;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.user.RememberMeService;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.LocaleResolver;

import java.io.IOException;
import java.util.Locale;

@Component
@RequiredArgsConstructor
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private final UserRepository userRepository;
    private final LocaleResolver localeResolver;
    private final RememberMeService rememberMeService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {

        String email = authentication.getName();

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Пользователь не найден: " + email));
        String languagePreference = user.getLanguagePreference();
        if (languagePreference == null || languagePreference.isBlank()) {
            languagePreference = "ru";
        }
        Locale locale = new Locale(languagePreference);
        localeResolver.setLocale(request, response, locale);
        LocaleContextHolder.setLocale(locale);

        String rememberMe = request.getParameter("rememberMe");
        if ("on".equals(rememberMe) || "true".equals(rememberMe)) {
            String token = rememberMeService.createRememberMeToken(email, request);
            if (token != null) {
                rememberMeService.addRememberMeCookie(response, token);
            }
        }

        response.sendRedirect("/");
    }
}
