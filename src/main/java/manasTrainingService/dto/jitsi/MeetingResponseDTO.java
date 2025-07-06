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
public class MeetingResponseDTO {
    Integer lessonId;
    Integer meetingId;
    String roomName;
    String meetingUrl;
    String status;
    LocalDateTime startedAt;
    String lessonTitle;
    String teacherName;
    Integer participantCount;
}