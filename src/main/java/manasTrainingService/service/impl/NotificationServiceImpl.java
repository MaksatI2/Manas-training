package manasTrainingService.service.impl;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.dto.notifications.NotificationResponseDTO;
import manasTrainingService.dto.notifications.NotificationWithUnreadCountDTO;
import manasTrainingService.entity.*;
import manasTrainingService.repositories.NotificationRepository;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.NotificationService;
import manasTrainingService.util.NotificationWebSocketSender;
import manasTrainingService.util.StatusUtil;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import manasTrainingService.util.DateUtil;

import java.time.LocalDateTime;
import java.util.List;

import static java.util.stream.Collectors.toList;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final NotificationWebSocketSender notificationWebSocketSender;

    @Override
    @Transactional
    public void create(Notification notification) {
        notificationRepository.save(notification);
    }

    @Override
    @Transactional(readOnly = true)
    public List<NotificationResponseDTO> getUserNotifications(User user) {
        return notificationRepository.findAllByUserOrderByCreatedAtDesc(user)
                .stream()
                .map(this::toDTO)
                .collect(toList());
    }

    @Override
    @Transactional(readOnly = true)
    public long countUnreadNotifications(User user) {
        return notificationRepository.countByUserAndIsReadFalse(user);
    }

    @Override
    @Transactional
    public void markAsRead(Integer notificationId) {
        Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new EntityNotFoundException("Notification not found: " + notificationId));
        if (!notification.getIsRead()) {
            notification.setIsRead(true);
            notificationRepository.save(notification);
        }
    }

    private NotificationResponseDTO toDTO(Notification notification) {
        return NotificationResponseDTO.builder()
                .id(notification.getId())
                .title(notification.getTitle())
                .body(notification.getBody())
                .targetType(notification.getTargetType().name())
                .targetId(notification.getTargetId())
                .notificationType(notification.getNotificationType().name())
                .isRead(notification.getIsRead())
                .createdAt(notification.getCreatedAt())
                .link(notification.getLink())
                .build();
    }

    @Transactional
    @Override
    public void markAllAsRead(User user, TargetType targetType) {
        List<Notification> notifications = notificationRepository.findAllByUserOrderByCreatedAtDesc(user);
        notifications.stream()
                .filter(n -> !n.getIsRead() && n.getTargetType() == targetType)
                .forEach(n -> n.setIsRead(true));
        notificationRepository.saveAll(notifications);
    }

    @Override
    public void notifyAdminsAboutNewApplication(CourseApplication application) {
        String submittedBy = application.getOrganization() != null
                ? application.getOrganization().getUser().getName() + " (Организация)"
                : application.getSubmittedBy().getName() + " (Студент)";

        String link = "/applications/admin/" + application.getId();

        List<User> admins = userRepository.findAllByRole_Name("ADMIN");
        for (User admin : admins) {
            Notification notification = Notification.builder()
                    .user(admin)
                    .title("Новая заявка на курс")
                    .body("Создана новая заявка от " + submittedBy)
                    .targetType(TargetType.COURSE_APPLICATION)
                    .targetId(application.getId())
                    .notificationType(NotificationType.GENERAL)
                    .link(link)
                    .build();
            create(notification);
            sendToWebSocket(admin, notification);
        }
    }

    @Override
    public void notifyOrganizationAboutComment(CourseApplication application, String comment) {
        if (application.getOrganization() != null) {
            User orgUser = application.getOrganization().getUser();
            String link = "/applications/organization/" + application.getId();
            sendCommentNotification(orgUser, application, comment, "Новый комментарий к заявке", link);
        }
    }

    @Override
    public void notifyStudentAboutComment(CourseApplication application, String comment) {
        if (application.getSubmittedBy() != null) {
            User student = application.getSubmittedBy();
            String link = "/applications/student/applications/" + application.getId();
            sendCommentNotification(student, application, comment, "Новый комментарий к вашей заявке", link);
        }
    }

    @Override
    public void notifyStudentAboutStatusChange(CourseApplication application) {
        if (application.getSubmittedBy() != null) {
            User student = application.getSubmittedBy();
            String link = "/applications/student/applications/" + application.getId();
            Notification notification = Notification.builder()
                    .user(student)
                    .title("Статус вашей заявки обновлен")
                    .body("Ваша заявка теперь в статусе: " + StatusUtil.localize(application.getStatus()))
                    .targetType(TargetType.COURSE_APPLICATION)
                    .targetId(application.getId())
                    .notificationType(NotificationType.GENERAL)
                    .link(link)
                    .build();
            create(notification);
            sendToWebSocket(student, notification);
        }
    }

    @Override
    public void notifyOrganizationAboutStatusChange(CourseApplication application) {
        if (application.getOrganization() != null) {
            User orgUser = application.getOrganization().getUser();
            String link = "/applications/organization/" + application.getId();
            Notification notification = Notification.builder()
                    .user(orgUser)
                    .title("Статус заявки вашей организации обновлен")
                    .body("Заявка теперь в статусе: " + StatusUtil.localize(application.getStatus()))
                    .targetType(TargetType.COURSE_APPLICATION)
                    .targetId(application.getId())
                    .notificationType(NotificationType.GENERAL)
                    .link(link)
                    .build();
            create(notification);
            sendToWebSocket(orgUser, notification);
        }
    }

    @Transactional
    @Override
    public void createAndSend(Notification notification) {
        create(notification);
        long unreadCount = countUnreadNotifications(notification.getUser());
        NotificationWithUnreadCountDTO dto = NotificationWithUnreadCountDTO.builder()
                .notification(toDTO(notification))
                .unreadCount(unreadCount)
                .build();
        notificationWebSocketSender.sendNotification(notification.getUser().getId(), dto);
    }


    private void sendCommentNotification(User user, CourseApplication app, String comment, String title, String link) {
        Notification notification = Notification.builder()
                .user(user)
                .title(title)
                .body(comment)
                .targetType(TargetType.COURSE_APPLICATION)
                .targetId(app.getId())
                .notificationType(NotificationType.GENERAL)
                .link(link)
                .build();
        create(notification);
        sendToWebSocket(user, notification);
    }

    private void sendToWebSocket(User user, Notification notification) {
        NotificationResponseDTO dto = NotificationResponseDTO.builder()
                .id(notification.getId())
                .title(notification.getTitle())
                .body(notification.getBody())
                .targetType(notification.getTargetType().name())
                .targetId(notification.getTargetId())
                .notificationType(notification.getNotificationType().name())
                .isRead(notification.getIsRead())
                .createdAt(notification.getCreatedAt())
                .link(notification.getLink())
                .build();

        long unreadCount = this.countUnreadNotifications(user);

        NotificationWithUnreadCountDTO dtoWithCount = NotificationWithUnreadCountDTO.builder()
                .notification(dto)
                .unreadCount(unreadCount)
                .build();

        notificationWebSocketSender.sendNotification(user.getId(), dtoWithCount);
    }
    @Transactional
    @Override
    public void markAllAsReadForUser(User user) {
        List<Notification> unread = notificationRepository.findAllByUserAndIsReadFalse(user);
        unread.forEach(n -> n.setIsRead(true));
        notificationRepository.saveAll(unread);
    }

    @Transactional
    @Override
    public void deleteAllNotificationsForUser(User user) {
        notificationRepository.deleteByUser(user);
    }

    @Override
    public int deleteOldNotifications(int daysThreshold) {
        LocalDateTime threshold = LocalDateTime.now().minusDays(daysThreshold);
        return notificationRepository.deleteByCreatedAtBefore(threshold);
    }

    @Scheduled(cron = "0 0 3 * * ?")
    public void autoDeleteOldNotifications() {
        int deleted = deleteOldNotifications(60);
        log.info("Автоудалено {} устаревших уведомлений", deleted);
    }


    @Override
    public void notifyAdminsAboutCourseCompletion(CourseEnrollment courseEnrollment) {
        String studentName = courseEnrollment.getStudent().getName();
        String courseName = courseEnrollment.getCourseInstance().getCourse().getTitle();
        Integer courseInstanceId = courseEnrollment.getCourseInstance().getId();

        String link = "/certificates/create/" + courseInstanceId + "/" + courseEnrollment.getStudent().getId();

        List<User> admins = userRepository.findAllByRole_Name("ADMIN");

        for (User admin : admins) {
            Notification notification = Notification.builder()
                    .user(admin)
                    .title("Завершение курса студентом")
                    .body(studentName + " завершил(а) курс \"" + courseName + "\".")
                    .targetType(TargetType.COURSE_INSTANCE)
                    .targetId(courseInstanceId)
                    .notificationType(NotificationType.COURSE_INSTANCE_FINISHED)
                    .link(link)
                    .build();
            create(notification);
            sendToWebSocket(admin, notification);
        }
    }

    @Override
    public void notifyTeacherAssignedToCourse(User teacher, CourseInstance courseInstance) {
        String courseName = courseInstance.getCourse().getTitle();
        String link = "/teacher/course/" + courseInstance.getId();

        Notification notification = Notification.builder()
                .user(teacher)
                .title("Вы назначены учителем на курс")
                .body("Курс: " + courseName + ", Даты проведения: " + DateUtil.formatDateOnly(courseInstance.getStartDate()) + " - " + DateUtil.formatDateOnly(courseInstance.getEndDate()))
                .targetType(TargetType.COURSE_INSTANCE)
                .targetId(courseInstance.getId())
                .notificationType(NotificationType.GENERAL)
                .link(link)
                .isRead(false)
                .createdAt(LocalDateTime.now())
                .build();

        createAndSend(notification);
    }

    @Override
    public void notifyTeacherRemovedFromCourse(User teacher, CourseInstance courseInstance) {
        String courseName = courseInstance.getCourse().getTitle();
        String link = "/teacher/my-courses" + courseInstance.getId();

        Notification notification = Notification.builder()
                .user(teacher)
                .title("Удаление с курса")
                .body("Вы больше не ведёте данный курс: " + courseName)
                .targetType(TargetType.COURSE_INSTANCE)
                .targetId(courseInstance.getId())
                .notificationType(NotificationType.GENERAL)
                .link(link)
                .isRead(false)
                .createdAt(LocalDateTime.now())
                .build();

        createAndSend(notification);
    }

    @Override
    public void notifyStudentEnrolledToCourse(User student, CourseInstance courseInstance) {
        String courseName = courseInstance.getCourse().getTitle();
        String link = "/student/course/" + courseInstance.getId();

        Notification notification = Notification.builder()
                .user(student)
                .title("Вы записаны на курс")
                .body("Курс: " + courseName + ", Даты проведения: " + DateUtil.formatDateOnly(courseInstance.getStartDate()) + " - " + DateUtil.formatDateOnly(courseInstance.getEndDate()))
                .targetType(TargetType.COURSE_INSTANCE)
                .targetId(courseInstance.getId())
                .notificationType(NotificationType.GENERAL)
                .link(link)
                .isRead(false)
                .createdAt(LocalDateTime.now())
                .build();

        createAndSend(notification);
    }

    @Override
    public void notifyStudentAboutEnrollmentStatusChange(User student, CourseInstance courseInstance, Status status) {
        String courseName = courseInstance.getCourse().getTitle();
        String title;
        String body;
        String link = "/courses/student/" + courseInstance.getId();

        if (status == Status.ENROLLED) {
            title = "Запись на курс подтверждена";
            body = "Вы успешно записаны на курс: " + courseName;
        } else if (status == Status.DROPPED) {
            title = "Удаление с курса";
            body = "Вы больше не участвуете в курсе: " + courseName;
        } else {
            return;
        }

        Notification notification = Notification.builder()
                .user(student)
                .title(title)
                .body(body)
                .targetType(TargetType.COURSE_INSTANCE)
                .targetId(courseInstance.getId())
                .notificationType(NotificationType.GENERAL)
                .link(link)
                .isRead(false)
                .createdAt(LocalDateTime.now())
                .build();

        createAndSend(notification);
    }

    @Transactional
    @Override
    public void notifyStudentsAboutTest(CourseInstance instance, TestInstance testInstance, String action) {
        List<User> students = instance.getEnrollments().stream()
                .map(CourseEnrollment::getStudent)
                .toList();

        String testTitle = testInstance.getTest().getTitle();
        String link = "/student/course/" + instance.getId();

        for (User student : students) {
            Notification notification = Notification.builder()
                    .user(student)
                    .title("Тест " + action + ": " + testTitle)
                    .body("Тест доступен с " + DateUtil.formatWithTime(testInstance.getScheduledStart()) + " до " + DateUtil.formatWithTime(testInstance.getScheduledEnd()))
                    .targetType(TargetType.TEST_INSTANCE)
                    .targetId(testInstance.getId())
                    .notificationType(NotificationType.GENERAL)
                    .link(link)
                    .isRead(false)
                    .createdAt(LocalDateTime.now())
                    .build();

            createAndSend(notification);
        }
    }


}
