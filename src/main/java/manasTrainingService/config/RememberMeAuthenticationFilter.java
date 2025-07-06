package manasTrainingService.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.entity.User;
import manasTrainingService.service.user.RememberMeService;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Optional;

@Component
@RequiredArgsConstructor
@Slf4j
public class RememberMeAuthenticationFilter extends OncePerRequestFilter {

    private final RememberMeService rememberMeService;
    private final UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        if (SecurityContextHolder.getContext().getAuthentication() != null) {
            filterChain.doFilter(request, response);
            return;
        }


        String requestURI = request.getRequestURI();
        if (requestURI.equals("/auth/login") || requestURI.equals("/login")) {
            filterChain.doFilter(request, response);
            return;
        }

        try {
            Optional<String> tokenOpt = rememberMeService.getRememberMeTokenFromCookie(request);

            if (tokenOpt.isPresent()) {
                String token = tokenOpt.get();
                Optional<User> userOpt = rememberMeService.validateAndRefreshToken(token, request);

                if (userOpt.isPresent()) {
                    User user = userOpt.get();
                    UserDetails userDetails = userDetailsService.loadUserByUsername(user.getEmail());

                    if (userDetails != null && userDetails.isEnabled()) {
                        UsernamePasswordAuthenticationToken authToken =
                                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                        authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                        SecurityContextHolder.getContext().setAuthentication(authToken);

                        log.debug("User authenticated via remember-me token: {}", user.getEmail());
                    }
                } else {
                    rememberMeService.removeRememberMeCookie(response);
                }
            }
        } catch (Exception e) {
            log.error("Error during remember-me authentication", e);
            SecurityContextHolder.clearContext();
            rememberMeService.removeRememberMeCookie(response);
        }

        filterChain.doFilter(request, response);
    }
}