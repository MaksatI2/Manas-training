package manasTrainingService.controller.rest;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.dto.jitsi.MeetingAnalyticsDTO;
import manasTrainingService.service.jitsi.MeetingAnalyticsService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/analytics")
@RequiredArgsConstructor
public class AnalyticsRestController {

    private final MeetingAnalyticsService analyticsService;

    @GetMapping("/meeting/{meetingId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('TEACHER')")
    public ResponseEntity<MeetingAnalyticsDTO> getMeetingAnalytics(@PathVariable Integer meetingId) {
        try {
            MeetingAnalyticsDTO analytics = analyticsService.getMeetingAnalytics(meetingId);
            return ResponseEntity.ok(analytics);
        } catch (Exception e) {
            log.error("Error getting meeting analytics: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/schedule/{scheduleId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('TEACHER')")
    public ResponseEntity<MeetingAnalyticsDTO> getScheduleAnalytics(@PathVariable Integer scheduleId) {
        try {
            MeetingAnalyticsDTO analytics = analyticsService.getScheduleAnalytics(scheduleId);
            return ResponseEntity.ok(analytics);
        } catch (Exception e) {
            log.error("Error getting schedule analytics: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().build();
        }
    }
}