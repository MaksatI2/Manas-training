package manasTrainingService.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.dto.ImageDto;
import manasTrainingService.exceptions.nsee.ImageValidationException;
import manasTrainingService.service.user.ImageService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Slf4j
@Controller
@RequestMapping("image")
@RequiredArgsConstructor
public class ImageController {
    private final ImageService imageService;
    private final UserService userService;

    @GetMapping("upload")
    public String addAvatar(Model model) {
        model.addAttribute("userId", userService.getAuthorizedUser().getId());
        return "profileImages/upload_image";
    }

    @PostMapping("upload")
    public String uploadImage(ImageDto avatar, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        try {
            String filename = imageService.saveImage(avatar);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Изображение успешно загружено!");
            log.info("Изображение успешно загружено: {}", filename);
            if (request.isUserInRole("STUDENT")){
                return "redirect:/student/profile";
            }else if(request.isUserInRole("TEACHER")){
                return "redirect:/teacher/profile";
            }
            return "redirect:/organization/profile";

        } catch (ImageValidationException e) {
            log.warn("Ошибка валидации изображения: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/image/upload";

        }
    }
}