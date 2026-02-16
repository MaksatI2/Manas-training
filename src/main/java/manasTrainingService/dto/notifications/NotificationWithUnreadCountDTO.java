package manasTrainingService.dto.notifications;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class NotificationWithUnreadCountDTO {
    NotificationResponseDTO notification;
    long unreadCount;
}
