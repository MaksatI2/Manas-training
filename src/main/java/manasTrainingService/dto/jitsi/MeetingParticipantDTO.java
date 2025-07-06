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
public class MeetingParticipantDTO {
    Integer id;
    Integer meetingId;
    Integer userId;
    String participantName;
    String participantId;
    LocalDateTime joinedAt;
    LocalDateTime leftAt;
    Integer durationSeconds;
    Boolean isModerator;
}