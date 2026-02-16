package manasTrainingService.service;

import manasTrainingService.dto.notifications.NotificationResponseDTO;
import manasTrainingService.entity.*;
import manasTrainingService.repositories.NotificationRepository;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.impl.NotificationServiceImpl;
import manasTrainingService.util.NotificationWebSocketSender;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import jakarta.persistence.EntityNotFoundException;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class NotificationServiceImplTest {

    @Mock
    private NotificationRepository notificationRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private NotificationWebSocketSender webSocketSender;

    @InjectMocks
    private NotificationServiceImpl service;

    private User user;

    @BeforeEach
    void setup() {
        user = new User();
        user.setId(1);
        user.setName("Test User");
    }

    @Test
    void create_shouldSaveNotification() {
        Notification notification = new Notification();
        service.create(notification);
        verify(notificationRepository).save(notification);
    }

    @Test
    void getUserNotifications_shouldReturnMappedDTOs() {
        Notification notification = Notification.builder()
                .id(1)
                .title("Test Title")
                .body("Test Body")
                .targetType(TargetType.COURSE)
                .targetId(5)
                .notificationType(NotificationType.GENERAL)
                .isRead(false)
                .build();

        when(notificationRepository.findAllByUserOrderByCreatedAtDesc(user))
                .thenReturn(List.of(notification));

        List<NotificationResponseDTO> result = service.getUserNotifications(user);

        assertEquals(1, result.size());
        assertEquals("Test Title", result.get(0).getTitle());
    }

    @Test
    void countUnreadNotifications_shouldReturnCount() {
        when(notificationRepository.countByUserAndIsReadFalse(user)).thenReturn(5L);
        assertEquals(5L, service.countUnreadNotifications(user));
    }

    @Test
    void markAsRead_shouldMarkAsRead() {
        Notification notification = Notification.builder()
                .id(1)
                .isRead(false)
                .build();

        when(notificationRepository.findById(1)).thenReturn(Optional.of(notification));

        service.markAsRead(1);

        assertTrue(notification.getIsRead());
        verify(notificationRepository).save(notification);
    }

    @Test
    void markAsRead_shouldThrowIfNotFound() {
        when(notificationRepository.findById(1)).thenReturn(Optional.empty());
        assertThrows(EntityNotFoundException.class, () -> service.markAsRead(1));
    }

    @Test
    void markAllAsRead_shouldUpdateCorrectNotifications() {
        Notification unread = Notification.builder().isRead(false).targetType(TargetType.COURSE_APPLICATION).build();
        Notification read = Notification.builder().isRead(true).targetType(TargetType.COURSE_APPLICATION).build();
        Notification other = Notification.builder().isRead(false).targetType(TargetType.TEST).build();

        when(notificationRepository.findAllByUserOrderByCreatedAtDesc(user))
                .thenReturn(List.of(unread, read, other));

        service.markAllAsRead(user, TargetType.COURSE_APPLICATION);

        assertTrue(unread.getIsRead());
        assertFalse(other.getIsRead());
        verify(notificationRepository).saveAll(any());
    }

    @Test
    void notifyAdminsAboutNewApplication_shouldSendNotifications() {
        User orgUser = new User();
        orgUser.setName("OrganizationName");
        Organization organization = new Organization();
        organization.setUser(orgUser);

        CourseApplication app = new CourseApplication();
        app.setId(1);
        app.setOrganization(organization);

        User admin = new User();
        admin.setId(10);
        admin.setName("Admin");

        when(userRepository.findAllByRole_Name("ADMIN")).thenReturn(List.of(admin));
        when(notificationRepository.countByUserAndIsReadFalse(admin)).thenReturn(0L);

        service.notifyAdminsAboutNewApplication(app);

        verify(notificationRepository).save(any());
        verify(webSocketSender).sendNotification(eq(10), any());
    }

    @Test
    void notifyOrganizationAboutComment_shouldSendNotification() {
        User orgUser = new User();
        orgUser.setId(5);
        Organization organization = new Organization();
        organization.setUser(orgUser);
        CourseApplication app = new CourseApplication();
        app.setOrganization(organization);

        when(notificationRepository.countByUserAndIsReadFalse(orgUser)).thenReturn(0L);

        service.notifyOrganizationAboutComment(app, "Comment");

        verify(notificationRepository).save(any());
        verify(webSocketSender).sendNotification(eq(5), any());
    }

    @Test
    void notifyStudentAboutComment_shouldSendNotification() {
        User student = new User();
        student.setId(5);
        CourseApplication app = new CourseApplication();
        app.setSubmittedBy(student);

        when(notificationRepository.countByUserAndIsReadFalse(student)).thenReturn(0L);

        service.notifyStudentAboutComment(app, "Comment");

        verify(notificationRepository).save(any());
        verify(webSocketSender).sendNotification(eq(5), any());
    }

    @Test
    void notifyStudentAboutStatusChange_shouldSendNotification() {
        User student = new User();
        student.setId(5);
        CourseApplication app = new CourseApplication();
        app.setId(1);
        app.setSubmittedBy(student);
        app.setStatus(Status.APPROVED);

        when(notificationRepository.countByUserAndIsReadFalse(student)).thenReturn(0L);

        service.notifyStudentAboutStatusChange(app);

        verify(notificationRepository).save(any());
        verify(webSocketSender).sendNotification(eq(5), any());
    }

    @Test
    void notifyOrganizationAboutStatusChange_shouldSendNotification() {
        User user = new User();
        user.setId(5);
        Organization org = new Organization();
        org.setUser(user);
        CourseApplication app = new CourseApplication();
        app.setId(1);
        app.setOrganization(org);
        app.setStatus(Status.APPROVED);

        when(notificationRepository.countByUserAndIsReadFalse(user)).thenReturn(0L);

        service.notifyOrganizationAboutStatusChange(app);

        verify(notificationRepository).save(any());
        verify(webSocketSender).sendNotification(eq(5), any());
    }

    @Test
    void createAndSend_shouldSaveAndSend() {
        user.setId(5);
        Notification notification = Notification.builder()
                .user(user)
                .targetType(TargetType.COURSE)
                .notificationType(NotificationType.GENERAL)
                .isRead(false)
                .build();

        when(notificationRepository.countByUserAndIsReadFalse(user)).thenReturn(2L);

        service.createAndSend(notification);

        verify(notificationRepository).save(notification);
        verify(webSocketSender).sendNotification(eq(5), any());
    }
}
