package manasTrainingService.controller;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.jitsi.MeetingResponseDTO;
import manasTrainingService.service.jitsi.MeetingService;
import manasTrainingService.service.user.UserService;
import manasTrainingService.entity.User;
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
    private final UserService userService;

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

        User currentUser = null;
        String userName = "Гость";

        if (userId != null && userRole != null) {
            boolean canAccess = meetingService.canUserAccessMeeting(userId, userRole, meetingId);
            if (!canAccess) {
                model.addAttribute("errorMessage", "У вас нет доступа к этой встрече");
                return "lessons/lesson";
            }

            currentUser = userService.getUserById(userId);
            if (currentUser != null) {
                userName = currentUser.getName() + " " + currentUser.getLastName();
            }
        }

        if (meeting.getRoomName() == null || meeting.getRoomName().isEmpty()) {
            String roomName = "meeting-" + meetingId;
            meeting.setRoomName(roomName);
        }

        model.addAttribute("meeting", meeting);
        model.addAttribute("userId", userId);
        model.addAttribute("userName", userName);
        model.addAttribute("userRole", userRole);
        model.addAttribute("currentUser", currentUser);

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

        User teacher = userService.getUserById(teacherId);
        String teacherName = "Преподаватель";
        if (teacher != null) {
            teacherName = teacher.getName() + " " + teacher.getLastName();
        }

        model.addAttribute("scheduleId", scheduleId);
        model.addAttribute("teacherId", teacherId);
        model.addAttribute("teacherName", teacherName);
        model.addAttribute("teacher", teacher);

        return "jitsi/start-meeting";
    }
}