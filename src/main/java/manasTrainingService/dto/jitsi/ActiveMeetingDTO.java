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
public class ActiveMeetingDTO {
    Integer id;
    Integer scheduleId;
    String roomName;
    String meetingUrl;
    String lessonTitle;
    String courseTitle;
    String teacherName;
    LocalDateTime startedAt;
    Integer participantCount;
}