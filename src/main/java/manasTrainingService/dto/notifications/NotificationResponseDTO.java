package manasTrainingService.dto.notifications;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Builder;
import lombok.Value;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Value
@Builder
public class NotificationResponseDTO {
    Integer id;
    String title;
    String body;
    String targetType;
    Integer targetId;
    String notificationType;
    Boolean isRead;
    String link;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    LocalDateTime createdAt;

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "";
        return createdAt.format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm"));
    }
}
