package manasTrainingService.service.user;

import manasTrainingService.entity.CourseApplication;
import manasTrainingService.entity.User;

public interface EmailService {
    void sendVerificationEmail(manasTrainingService.entity.User user, String token);

    void sendPasswordResetEmail(User user, String token);

    void sendStudentWelcomeEmail(String email, String name, String rawPassword);

    void sendNewCommentNotification(CourseApplication app, String comment, User author);

    void sendApplicationStatusUpdateEmail(CourseApplication app);
}
