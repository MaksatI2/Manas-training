package manasTrainingService.service;

import manasTrainingService.entity.User;

public interface EmailVerificationService {
    void generateVerificationToken(User user);

    boolean verifyEmailToken(String token);
}
