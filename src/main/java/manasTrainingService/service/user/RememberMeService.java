package manasTrainingService.service.user;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import manasTrainingService.entity.RememberMeToken;
import manasTrainingService.entity.User;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

public interface RememberMeService {
    @Transactional
    String createRememberMeToken(String email, HttpServletRequest request);

    @Transactional
    Optional<User> validateAndRefreshToken(String token, HttpServletRequest request);

    @Transactional
    void invalidateToken(String token);

    @Transactional
    void invalidateAllUserTokens(String email);

    void addRememberMeCookie(HttpServletResponse response, String token);

    void removeRememberMeCookie(HttpServletResponse response);

    Optional<String> getRememberMeTokenFromCookie(HttpServletRequest request);

    List<RememberMeToken> getUserActiveTokens(String email);

    @Scheduled(cron = "0 0 2 * * ?") // каждый день в 2:00
    @Transactional
    void cleanupExpiredTokens();
}
