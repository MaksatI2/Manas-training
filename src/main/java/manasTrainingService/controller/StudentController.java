package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.UserProfileEditDto;
import manasTrainingService.service.StudentService;
import manasTrainingService.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/student")
@RequiredArgsConstructor
public class StudentController {
    private final StudentService studentService;
    private final UserService userService;

    @GetMapping("/profile")
    public String profilePage(Model model){
        model.addAttribute("student", studentService.getAuthorizedStudentProfile(userService.getAuthorizedUser()));
        return "profile/view";
    }

    @GetMapping("/profile/edit")
    public String editStudentProfilePage(Model model){
        model.addAttribute("studentProfile", studentService.getStudentInformationForEdit(userService.getAuthorizedUser()));
        return "profile/edit";
    }

    @PostMapping("/profile/edit")
    public String editStudentProfile(@Valid UserProfileEditDto userProfileEditDto, BindingResult bindingResult, Model model){
        if (!bindingResult.hasErrors()) {
            studentService.editStudentInformation(userProfileEditDto);
            return "redirect:/student/profile";
        }
        model.addAttribute("studentProfile", userProfileEditDto);
        return "profile/edit";
    }
}
