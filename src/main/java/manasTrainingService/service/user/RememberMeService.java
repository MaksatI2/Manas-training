package manasTrainingService.service.user;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import manasTrainingService.entity.RememberMeToken;
import manasTrainingService.entity.User;

import java.util.List;
import java.util.Optional;

public interface RememberMeService {

    String createRememberMeToken(String email, HttpServletRequest request);

    Optional<User> validateAndRefreshToken(String token, HttpServletRequest request);

    void invalidateTokenById(Long tokenId, String email);

    void invalidateToken(String token);

    void invalidateAllUserTokens(String email);

    void addRememberMeCookie(HttpServletResponse response, String token);

    void removeRememberMeCookie(HttpServletResponse response);

    Optional<String> getRememberMeTokenFromCookie(HttpServletRequest request);

    List<RememberMeToken> getUserActiveTokens(String email);

    void cleanupExpiredTokens();

    Optional<RememberMeToken> getTokenInfo(String token);
}