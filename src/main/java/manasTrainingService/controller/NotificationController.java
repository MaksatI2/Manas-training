package manasTrainingService.controller;

import lombok.RequiredArgsConstructor;
import manasTrainingService.config.CustomUserDetails;
import manasTrainingService.dto.notifications.NotificationResponseDTO;
import manasTrainingService.entity.User;
import manasTrainingService.service.NotificationService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping("/notifications")
    public String notificationsPage(Model model, Authentication authentication) {
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUserDetails userDetails)) {
            return "redirect:/auth/login";
        }
        User user = userDetails.getUser();
        List<NotificationResponseDTO> notifications = notificationService.getUserNotifications(user);
        model.addAttribute("notifications", notifications);
        return "notifications/list";
    }
}
