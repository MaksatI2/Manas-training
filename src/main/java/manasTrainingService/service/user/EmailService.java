package manasTrainingService.service.user;

import manasTrainingService.entity.User;

public interface EmailService {
    void sendVerificationEmail(manasTrainingService.entity.User user, String token);

    void sendPasswordResetEmail(User user, String token);

    void sendStudentWelcomeEmail(String email, String name, String rawPassword);

}
