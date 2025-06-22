package manasTrainingService.service.user;

import manasTrainingService.entity.User;

public interface PasswordResetService {
    void createResetToken(User user);

    boolean resetPassword(String token, String newPassword);
    boolean isValidToken(String token);
}
