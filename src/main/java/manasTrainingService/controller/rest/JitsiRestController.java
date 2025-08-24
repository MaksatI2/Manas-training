package manasTrainingService.controller.rest;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.jitsi.*;
import manasTrainingService.service.jitsi.MeetingParticipantService;
import manasTrainingService.service.jitsi.MeetingService;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/jitsi")
@RequiredArgsConstructor
public class JitsiRestController {

    private final MeetingService meetingService;
    private final MeetingParticipantService participantService;
    private final SimpMessagingTemplate messagingTemplate;

    @PostMapping("/meetings/start")
    public ResponseEntity<MeetingResponseDTO> startMeeting(@RequestBody StartMeetingRequestDTO request) {
        try {
            MeetingResponseDTO response = meetingService.startMeeting(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/meetings/end")
    public ResponseEntity<Void> endMeeting(@RequestBody EndMeetingRequestDTO request) {
        try {
            meetingService.endMeeting(request);
            try {
                messagingTemplate.convertAndSend("/topic/meetings/" + request.getMeetingId(), "ENDED");
                Thread.sleep(100);
            } catch (Exception e) {
                System.err.println("Ошибка отправки WebSocket уведомления: " + e.getMessage());
            }

            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/meetings/join")
    public ResponseEntity<MeetingParticipantDTO> joinMeeting(@RequestBody JoinMeetingRequestDTO request) {
        try {
            MeetingParticipantDTO participant = participantService.joinMeeting(request);
            return ResponseEntity.ok(participant);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/meetings/{meetingId}/leave")
    public ResponseEntity<Void> leaveMeeting(@PathVariable Integer meetingId, @RequestParam Integer userId) {
        try {
            participantService.leaveMeeting(meetingId, userId);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/meetings/{meetingId}/leave-by-participant")
    public ResponseEntity<Void> leaveMeetingByParticipantId(@PathVariable Integer meetingId,
                                                            @RequestParam String participantId) {
        try {
            participantService.leaveMeetingByParticipantId(meetingId, participantId);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
}