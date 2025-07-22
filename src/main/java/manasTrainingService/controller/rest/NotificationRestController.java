package manasTrainingService.controller.rest;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.config.CustomUserDetails;
import manasTrainingService.dto.notifications.NotificationCreateDTO;
import manasTrainingService.dto.notifications.NotificationResponseDTO;
import manasTrainingService.entity.Notification;
import manasTrainingService.entity.NotificationType;
import manasTrainingService.entity.TargetType;
import manasTrainingService.entity.User;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.NotificationService;
import manasTrainingService.util.NotificationWebSocketSender;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationRestController {

    private final NotificationService notificationService;
    private final NotificationWebSocketSender webSocketSender;
    private final UserRepository userRepository;

    @PostMapping
    public ResponseEntity<Void> createNotification(@RequestBody @Valid NotificationCreateDTO dto) {
        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + dto.getUserId()));

        Notification notification = Notification.builder()
                .user(user)
                .title(dto.getTitle())
                .body(dto.getBody())
                .targetType(TargetType.valueOf(dto.getTargetType()))
                .targetId(dto.getTargetId())
                .notificationType(NotificationType.valueOf(dto.getNotificationType()))
                .build();

        notificationService.create(notification);
        NotificationResponseDTO responseDTO = NotificationResponseDTO.builder()
                .id(notification.getId())
                .title(notification.getTitle())
                .body(notification.getBody())
                .targetType(notification.getTargetType().name())
                .targetId(notification.getTargetId())
                .notificationType(notification.getNotificationType().name())
                .isRead(notification.getIsRead())
                .createdAt(notification.getCreatedAt())
                .build();

        notificationService.createAndSend(notification);
        return ResponseEntity.status(201).build();
    }

    @GetMapping
    public ResponseEntity<List<NotificationResponseDTO>> getUserNotifications(@RequestParam Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + userId));

        List<NotificationResponseDTO> notifications = notificationService.getUserNotifications(user);
        return ResponseEntity.ok(notifications);
    }

    @GetMapping("/unread-count")
    public ResponseEntity<Long> getUnreadCount(Authentication authentication) {
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUserDetails userDetails)) {
            return ResponseEntity.ok(0L);
        }
        User user = userDetails.getUser();
        long count = notificationService.countUnreadNotifications(user);
        return ResponseEntity.ok(count);
    }


    @PostMapping("/{notificationId}/read")
    public ResponseEntity<Void> markAsRead(@PathVariable Integer notificationId) {
        notificationService.markAsRead(notificationId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/current-user-id")
    public ResponseEntity<Integer> getCurrentUserId(Authentication authentication) {
        if (authentication != null) {
            Object principal = authentication.getPrincipal();
            if (principal instanceof CustomUserDetails userDetails) {
                User user = userDetails.getUser();
                return ResponseEntity.ok(user.getId());
            }
        }
        return ResponseEntity.ok(0);
    }
    @PostMapping("/mark-all-as-read")
    public ResponseEntity<Void> markAllAsRead(
            @RequestParam String targetType,
            Authentication authentication
    ) {
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUserDetails userDetails)) {
            return ResponseEntity.ok().build();
        }
        notificationService.markAllAsRead(userDetails.getUser(), TargetType.valueOf(targetType));
        return ResponseEntity.ok().build();
    }

}

