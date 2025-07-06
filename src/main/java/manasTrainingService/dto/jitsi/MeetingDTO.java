package manasTrainingService.dto.jitsi;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class MeetingDTO {
    Integer id;
    Integer scheduleId;
    String meetingId;
    String roomName;
    String meetingUrl;
    LocalDateTime startedAt;
    LocalDateTime endedAt;
    LocalDateTime createdAt;
}