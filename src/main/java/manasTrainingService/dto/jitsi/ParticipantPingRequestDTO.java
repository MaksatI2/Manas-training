package manasTrainingService.dto.jitsi;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ParticipantPingRequestDTO {

    private String participantId;
    private Integer meetingId;
    private Boolean isActive;
    private String connectionStatus;
}