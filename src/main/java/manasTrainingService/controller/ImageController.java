package manasTrainingService.controller;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.ImageDto;
import manasTrainingService.service.ImageService;
import manasTrainingService.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

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
    public String uploadImage(ImageDto avatar) {
        imageService.saveImage(avatar);
        return "redirect:/";
    }

}
