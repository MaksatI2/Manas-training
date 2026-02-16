package manasTrainingService.util;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.notifications.NotificationWithUnreadCountDTO;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class NotificationWebSocketSender {

    private final SimpMessagingTemplate messagingTemplate;

    public void sendNotification(Integer userId, NotificationWithUnreadCountDTO dto) {
        messagingTemplate.convertAndSend("/topic/notifications/" + userId, dto);
    }
}
