package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.entity.EmailVerificationToken;
import manasTrainingService.entity.User;
import manasTrainingService.repositories.EmailVerificationTokenRepository;
import manasTrainingService.service.EmailService;
import manasTrainingService.service.EmailVerificationService;
import manasTrainingService.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailVerificationServiceImpl implements EmailVerificationService {

    private final EmailVerificationTokenRepository tokenRepository;
    private final EmailService emailService;
    private UserService userService;

    @Autowired
    public void setUserService(@Lazy UserService userService) {
        this.userService = userService;
    }

    @Override
    public void generateVerificationToken(User user) {
        tokenRepository.deleteByUserId(user.getId().longValue());

        String token = UUID.randomUUID().toString();
        EmailVerificationToken emailToken = EmailVerificationToken.builder()
                .user(user)
                .token(token)
                .expiryDate(LocalDateTime.now().plusDays(1))
                .build();
        tokenRepository.save(emailToken);
        emailService.sendVerificationEmail(user, token);
    }

    @Override
    public boolean verifyEmailToken(String token) {
        var opt = tokenRepository.findByToken(token);
        if (opt.isEmpty()) return false;

        var emailToken = opt.get();
        if (emailToken.getExpiryDate().isBefore(LocalDateTime.now())) return false;

        User user = emailToken.getUser();
        user.setIsActive(true);
        userService.saveUser(user);
        tokenRepository.delete(emailToken);

        return true;
    }
}
