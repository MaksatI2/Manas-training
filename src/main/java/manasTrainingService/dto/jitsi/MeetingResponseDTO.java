package manasTrainingService.dto.jitsi;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MeetingResponseDTO {
    private Integer lessonId;
    private Integer meetingId;
    private Integer scheduleId;
    private String roomName;
    private LocalDateTime startedAt;
    private String lessonTitle;
    private String status;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer teacherId;
    private String teacherName;
    private Integer participantCount;

    public String getRoomName() {
        if (roomName == null || roomName.isEmpty()) {
            return "meeting-" + meetingId;
        }
        return roomName;
    }
}