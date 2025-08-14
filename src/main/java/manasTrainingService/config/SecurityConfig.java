package manasTrainingService.config;

import lombok.RequiredArgsConstructor;
import manasTrainingService.service.user.RememberMeService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final RememberMeService rememberMeService;
    private final RememberMeAuthenticationFilter rememberMeAuthenticationFilter;
    private final AuthenticationSuccessHandler customAuthenticationSuccessHandler;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers("/courses/{id}/tests").authenticated()
                        .requestMatchers(
                                "/",
                                "/auth/**",
                                "/static/**",
                                "/js/**",
                                "/favicon.ico",
                                "/error",
                                "/courses/**",
                                "/teachers/**",
                                "/data/images/**",
                                "/ws/**",
                                "/teacher",
                                "/teacher/{id}",
                                "/api/users/current-language"
                        ).permitAll()
                        .requestMatchers("/applications/admin/**").hasAuthority("ADMIN")
                        .requestMatchers("/applications/organization/**").hasAuthority("ORGANIZATION")
                        .requestMatchers("/schedules/**").hasAnyAuthority("ADMIN", "STUDENT", "TEACHER")
                        .requestMatchers("/admin/**").hasAuthority("ADMIN")
                        .requestMatchers("/student/**").hasAuthority("STUDENT")
                        .requestMatchers("/test/create/*").hasAuthority("TEACHER")
                        .requestMatchers("/test/{id}/edit").hasAuthority("TEACHER")
                        .requestMatchers("/test/{id}/delete").hasAuthority("TEACHER")
                        .requestMatchers("/test/{id}/passing").hasAuthority("STUDENT")
                        .anyRequest().authenticated()
                )
                .csrf(csrf -> csrf
                        .ignoringRequestMatchers("/ws/**")
                )
                .addFilterBefore(rememberMeAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                .formLogin(form -> form
                        .loginPage("/auth/login")
                        .successHandler(customAuthenticationSuccessHandler)
                        .loginProcessingUrl("/login")
                        .usernameParameter("login")
                        .passwordParameter("password")
                        .failureUrl("/auth/login?error=true")
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/auth/login")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                        .permitAll()
                )
                .exceptionHandling(exception -> exception
                        .accessDeniedPage("/errors/400")
                )
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.ALWAYS));
        return http.build();
    }
}