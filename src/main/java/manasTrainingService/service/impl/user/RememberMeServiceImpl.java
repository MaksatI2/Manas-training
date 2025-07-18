package manasTrainingService.service.impl.user;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.entity.RememberMeToken;
import manasTrainingService.entity.User;
import manasTrainingService.repositories.user.RememberMeTokenRepository;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.user.RememberMeService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class RememberMeServiceImpl implements RememberMeService {

    private final RememberMeTokenRepository rememberMeTokenRepository;
    private final UserRepository userRepository;
    private final SecureRandom secureRandom = new SecureRandom();

    @Value("${app.remember-me.token-validity-days:365}")
    private int tokenValidityDays;

    @Value("${app.remember-me.cookie-name:remember-me}")
    private String cookieName;

    @Value("${app.remember-me.max-tokens-per-user:5}")
    private int maxTokensPerUser;

    @Transactional
    @Override
    public String createRememberMeToken(String email, HttpServletRequest request) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            return null;
        }

        User user = userOpt.get();

        List<RememberMeToken> existingTokens = rememberMeTokenRepository.findByUserAndIsActiveTrue(user);
        if (existingTokens.size() >= maxTokensPerUser) {
            existingTokens.stream()
                    .min((t1, t2) -> t1.getCreatedAt().compareTo(t2.getCreatedAt()))
                    .ifPresent(oldestToken -> {
                        oldestToken.setIsActive(false);
                        rememberMeTokenRepository.save(oldestToken);
                    });
        }

        String token = generateSecureToken();
        String userAgent = request.getHeader("User-Agent");
        String ipAddress = getClientIpAddress(request);

        RememberMeToken rememberMeToken = RememberMeToken.builder()
                .token(token)
                .email(email)
                .user(user)
                .userAgent(userAgent)
                .ipAddress(ipAddress)
                .expiresAt(LocalDateTime.now().plusDays(tokenValidityDays))
                .build();

        rememberMeTokenRepository.save(rememberMeToken);
        log.info("Created remember-me token for user: {}", email);

        return token;
    }

    @Transactional
    @Override
    public Optional<User> validateAndRefreshToken(String token, HttpServletRequest request) {
        Optional<RememberMeToken> tokenOpt = rememberMeTokenRepository.findByTokenAndIsActiveTrue(token);

        if (tokenOpt.isEmpty()) {
            return Optional.empty();
        }

        RememberMeToken rememberMeToken = tokenOpt.get();

        if (rememberMeToken.isExpired()) {
            rememberMeToken.setIsActive(false);
            rememberMeTokenRepository.save(rememberMeToken);
            return Optional.empty();
        }
        rememberMeToken.updateLastUsed();
        rememberMeTokenRepository.save(rememberMeToken);

        User user = rememberMeToken.getUser();
        user.getEmail();

        log.info("Validated remember-me token for user: {}", rememberMeToken.getEmail());
        return Optional.of(user);
    }

    @Transactional
    @Override
    public void invalidateToken(String token) {
        rememberMeTokenRepository.deactivateToken(token);
    }

    @Transactional
    @Override
    public void invalidateTokenById(Long tokenId, String email) {
        Optional<RememberMeToken> tokenOpt = rememberMeTokenRepository.findById(tokenId);
        if (tokenOpt.isPresent()) {
            RememberMeToken token = tokenOpt.get();
            if (token.getEmail().equals(email)) {
                token.setIsActive(false);
                rememberMeTokenRepository.save(token);
                log.info("Invalidated remember-me token {} for user: {}", tokenId, email);
            }
        }
    }

    @Transactional
    @Override
    public void invalidateAllUserTokens(String email) {
        rememberMeTokenRepository.deactivateAllTokensForEmail(email);
        log.info("Invalidated all remember-me tokens for user: {}", email);
    }


    @Override
    public void addRememberMeCookie(HttpServletResponse response, String token) {
        Cookie cookie = new Cookie(cookieName, token);
        cookie.setMaxAge(tokenValidityDays * 24 * 60 * 60);
        cookie.setHttpOnly(true);
        cookie.setSecure(false);
        cookie.setPath("/");
        cookie.setAttribute("SameSite", "Lax");
        response.addCookie(cookie);
        log.debug("Added remember-me cookie with token");
    }

    @Override
    public void removeRememberMeCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie(cookieName, "");
        cookie.setMaxAge(0);
        cookie.setHttpOnly(true);
        cookie.setSecure(false);
        cookie.setPath("/");
        cookie.setAttribute("SameSite", "Lax");
        response.addCookie(cookie);
        log.debug("Removed remember-me cookie");
    }

    @Override
    public Optional<String> getRememberMeTokenFromCookie(HttpServletRequest request) {
        if (request.getCookies() != null) {
            for (Cookie cookie : request.getCookies()) {
                if (cookieName.equals(cookie.getName())) {
                    return Optional.of(cookie.getValue());
                }
            }
        }
        return Optional.empty();
    }

    @Override
    public List<RememberMeToken> getUserActiveTokens(String email) {
        return rememberMeTokenRepository.findByEmailAndIsActiveTrue(email);
    }

    @Scheduled(cron = "0 0 2 * * ?")
    @Transactional
    @Override
    public void cleanupExpiredTokens() {
        int deleted = rememberMeTokenRepository.findExpiredTokens(LocalDateTime.now()).size();
        rememberMeTokenRepository.deleteExpiredAndInactiveTokens(LocalDateTime.now());
        if (deleted > 0) {
            log.info("Cleaned up {} expired remember-me tokens", deleted);
        }
    }

    private String generateSecureToken() {
        byte[] tokenBytes = new byte[32];
        secureRandom.nextBytes(tokenBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
    }

    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }

        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }

        return request.getRemoteAddr();
    }

    @Override
    public Optional<RememberMeToken> getTokenInfo(String token) {
        return rememberMeTokenRepository.findByTokenAndIsActiveTrue(token);
    }
}
