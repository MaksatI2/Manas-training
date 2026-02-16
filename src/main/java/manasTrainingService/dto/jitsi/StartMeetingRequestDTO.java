package manasTrainingService.dto.jitsi;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class StartMeetingRequestDTO {
    Integer scheduleId;
    Integer teacherId;
}