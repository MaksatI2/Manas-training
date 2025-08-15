package manasTrainingService.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.dto.jitsi.MeetingAnalyticsDTO;
import manasTrainingService.service.jitsi.MeetingAnalyticsService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Slf4j
@Controller
@RequestMapping("/analytics")
@RequiredArgsConstructor
public class MeetingAnalyticsController {

    private final MeetingAnalyticsService analyticsService;

    @GetMapping("/meeting/{meetingId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('TEACHER')")
    public String viewMeetingAnalytics(@PathVariable Integer meetingId,
                                       Model model,
                                       RedirectAttributes redirectAttributes) {
        try {
            MeetingAnalyticsDTO analytics = analyticsService.getMeetingAnalytics(meetingId);

            model.addAttribute("analytics", analytics);
            model.addAttribute("pageTitle", "Аналитика урока: " + analytics.getLessonTitle());

            return "jitsi/meeting-analytic";
        } catch (Exception e) {
            log.error("Error loading meeting analytics for meetingId: {}", meetingId, e);
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Не удалось загрузить аналитику урока: " + e.getMessage());
            return "redirect:/lessons";
        }
    }

    @GetMapping("/schedule/{scheduleId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('TEACHER')")
    public String viewScheduleAnalytics(@PathVariable Integer scheduleId,
                                        Model model,
                                        RedirectAttributes redirectAttributes) {
        try {
            MeetingAnalyticsDTO analytics = analyticsService.getScheduleAnalytics(scheduleId);

            model.addAttribute("analytics", analytics);
            model.addAttribute("scheduleId", scheduleId);
            model.addAttribute("pageTitle", "Аналитика урока: " + analytics.getLessonTitle());

            return "jitsi/meeting-analytic";
        } catch (Exception e) {
            log.error("Error loading schedule analytics for scheduleId: {}", scheduleId, e);
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Не удалось загрузить аналитику урока: " + e.getMessage());
            return "redirect:/lessons";
        }
    }
}