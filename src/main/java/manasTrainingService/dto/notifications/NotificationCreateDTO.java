package manasTrainingService.dto.notifications;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Value;

@Value
public class NotificationCreateDTO {

    @NotNull
    Integer userId;

    @NotBlank
    String title;

    String body;

    @NotBlank
    String targetType;

    @NotNull
    Integer targetId;

    @NotBlank
    String notificationType;
}
