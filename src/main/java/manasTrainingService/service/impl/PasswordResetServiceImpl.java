package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.entity.PasswordResetToken;
import manasTrainingService.entity.User;
import manasTrainingService.repositories.PasswordResetTokenRepository;
import manasTrainingService.repositories.UserRepository;
import manasTrainingService.service.EmailService;
import manasTrainingService.service.PasswordResetService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class PasswordResetServiceImpl implements PasswordResetService {

    private final PasswordResetTokenRepository tokenRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;

    @Override
    public void createResetToken(User user) {
        tokenRepository.deleteByUserId(user.getId().longValue());

        String token = UUID.randomUUID().toString();
        PasswordResetToken resetToken = PasswordResetToken.builder().user(user).token(token).expiryDate(LocalDateTime.now().plusHours(2)).build();

        tokenRepository.save(resetToken);
        emailService.sendPasswordResetEmail(user, token);
    }

    @Override
    public boolean resetPassword(String token, String newPassword) {
        var opt = tokenRepository.findByToken(token);
        if (opt.isEmpty()) return false;

        PasswordResetToken resetToken = opt.get();
        if (resetToken.getExpiryDate().isBefore(LocalDateTime.now())) return false;

        User user = resetToken.getUser();
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        tokenRepository.delete(resetToken);

        return true;
    }
}
