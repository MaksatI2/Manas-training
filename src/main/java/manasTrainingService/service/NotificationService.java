package manasTrainingService.service;


import manasTrainingService.dto.notifications.NotificationResponseDTO;
import manasTrainingService.entity.CourseApplication;
import manasTrainingService.entity.Notification;
import manasTrainingService.entity.TargetType;
import manasTrainingService.entity.User;

import java.util.List;

public interface NotificationService {
    void create(Notification notification);

    List<NotificationResponseDTO> getUserNotifications(User user);

    long countUnreadNotifications(User user);

    void markAsRead(Integer notificationId);

    void markAllAsRead(User user, TargetType targetType);

    void notifyAdminsAboutNewApplication(CourseApplication application);

    void notifyOrganizationAboutComment(CourseApplication application, String comment);

    void notifyStudentAboutComment(CourseApplication application, String comment);

    void notifyStudentAboutStatusChange(CourseApplication application);

    void notifyOrganizationAboutStatusChange(CourseApplication application);

    void createAndSend(Notification notification);
}
