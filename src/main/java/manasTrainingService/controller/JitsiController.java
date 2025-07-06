package manasTrainingService.controller;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.jitsi.MeetingResponseDTO;
import manasTrainingService.service.jitsi.MeetingService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/jitsi")
@RequiredArgsConstructor
public class JitsiController {

    private final MeetingService meetingService;

    @GetMapping("/meeting/{meetingId}/join")
    public String joinMeetingPage(@PathVariable Integer meetingId,
                                  @RequestParam(required = false) Integer userId,
                                  @RequestParam(required = false) String userRole,
                                  Model model) {
        MeetingResponseDTO meeting = meetingService.getMeetingById(meetingId);
        if (meeting == null || !"ACTIVE".equals(meeting.getStatus())) {
            model.addAttribute("errorMessage", "Встреча не найдена или не активна");
            return "lessons/lesson";
        }

        if (userId != null && userRole != null) {
            boolean canAccess = meetingService.canUserAccessMeeting(userId, userRole, meetingId);
            if (!canAccess) {
                model.addAttribute("errorMessage", "У вас нет доступа к этой встрече");
                return "lessons/lesson";
            }
        }

        model.addAttribute("meeting", meeting);
        model.addAttribute("userId", userId);
        return "jitsi/join-meeting";
    }

    @GetMapping("/schedule/{scheduleId}/start")
    public String startMeetingPage(@PathVariable Integer scheduleId,
                                   @RequestParam Integer teacherId,
                                   Model model) {
        if (meetingService.isMeetingActive(scheduleId)) {
            MeetingResponseDTO existingMeeting = meetingService.getMeetingByScheduleId(scheduleId);
            return "redirect:/jitsi/meeting/" + existingMeeting.getMeetingId() + "/join?userId=" + teacherId + "&userRole=TEACHER";
        }

        model.addAttribute("scheduleId", scheduleId);
        model.addAttribute("teacherId", teacherId);
        return "jitsi/start-meeting";
    }
}