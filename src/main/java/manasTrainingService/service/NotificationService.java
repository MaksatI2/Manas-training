package manasTrainingService.service;


import manasTrainingService.dto.notifications.NotificationResponseDTO;
import manasTrainingService.entity.CourseApplication;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.Notification;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.TargetType;
import manasTrainingService.entity.TestInstance;
import manasTrainingService.entity.User;
import org.springframework.transaction.annotation.Transactional;

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

    void markAllAsReadForUser(User user);

    void deleteAllNotificationsForUser(User user);

    int deleteOldNotifications(int daysThreshold);

    void notifyAdminsAboutCourseCompletion(CourseEnrollment courseEnrollment);

    void notifyTeacherAssignedToCourse(User teacher, CourseInstance courseInstance);

    void notifyTeacherRemovedFromCourse(User teacher, CourseInstance courseInstance);

    void notifyStudentEnrolledToCourse(User student, CourseInstance courseInstance);

    void notifyStudentAboutEnrollmentStatusChange(User student, CourseInstance courseInstance, Status status);

    @Transactional
    void notifyStudentsAboutTest(CourseInstance instance, TestInstance testInstance, String action);
}
