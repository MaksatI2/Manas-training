package manasTrainingService.controller.rest;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.dto.jitsi.ParticipantPingRequestDTO;
import manasTrainingService.service.jitsi.ParticipantPingService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/jitsi/ping")
@RequiredArgsConstructor
public class ParticipantPingController {

    private final ParticipantPingService pingService;

    @PostMapping("/record")
    public ResponseEntity<Void> recordPing(@RequestBody ParticipantPingRequestDTO request) {
        try {
            pingService.recordPingByParticipantId(
                    request.getParticipantId(),
                    request.getMeetingId(),
                    request.getIsActive(),
                    request.getConnectionStatus()
            );
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("Error recording ping: {}", e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/heartbeat")
    public ResponseEntity<String> heartbeat(@RequestParam String participantId,
                                            @RequestParam Integer meetingId) {
        try {
            pingService.recordPingByParticipantId(participantId, meetingId, true, "HEARTBEAT");
            return ResponseEntity.ok("OK");
        } catch (Exception e) {
            log.error("Error recording heartbeat: {}", e.getMessage());
            return ResponseEntity.badRequest().body("ERROR");
        }
    }
}