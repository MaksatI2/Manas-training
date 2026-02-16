package manasTrainingService.controller.rest;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.UserRelationsCountDto;
import manasTrainingService.exceptions.nsee.user.UserNotFoundException;
import manasTrainingService.service.user.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import java.util.Locale;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserRestController {

    private final UserService userService;

    @GetMapping("/{userId}/relations-count")
    public ResponseEntity<UserRelationsCountDto> getUserRelationsCount(@PathVariable Integer userId) {
        try {
            UserRelationsCountDto relationsCount = userService.getUserRelationsCount(userId);
            return ResponseEntity.ok(relationsCount);
        } catch (UserNotFoundException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(500).build();
        }
    }

    @PostMapping("/language")
    public void updateLanguage(@RequestParam String lang, Authentication authentication) {
        userService.updateLanguage(authentication, lang);
    }

    @GetMapping("/current-language")
    @ResponseBody
    public String getCurrentLanguage(HttpServletRequest request) {
        Locale locale = (Locale) request.getSession().getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME);
        return locale != null ? locale.getLanguage() : "ru";
    }
}
