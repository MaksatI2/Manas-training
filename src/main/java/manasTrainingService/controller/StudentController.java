package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.edit.UserProfileEditDto;
import manasTrainingService.exceptions.nsee.PhoneAlreadyExistsException;
import manasTrainingService.service.StudentService;
import manasTrainingService.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/student")
@RequiredArgsConstructor
public class StudentController {
    private final StudentService studentService;
    private final UserService userService;

    @GetMapping("/profile")
    public String profilePage(Model model){
        model.addAttribute("student", studentService.getAuthorizedStudentProfile(userService.getAuthorizedUser()));
        return "student/profile-view";
    }

    @GetMapping("/profile/edit")
    public String editStudentProfilePage(Model model){
        model.addAttribute("studentProfile", studentService.getStudentInformationForEdit(userService.getAuthorizedUser()));
        return "student/profile-edit";
    }

    @PostMapping("/profile/edit")
    public String editStudentProfile(@Valid UserProfileEditDto userProfileEditDto,
                                     BindingResult bindingResult,
                                     RedirectAttributes redirectAttributes,
                                     Model model){
        if (bindingResult.hasErrors()) {
            model.addAttribute("studentProfile", userProfileEditDto);
            return "student/profile-edit";
        }

        try {
            studentService.editStudentInformation(userProfileEditDto);
            redirectAttributes.addFlashAttribute("successMessage", "Профиль успешно обновлен!");
            return "redirect:/student/profile";
        } catch (PhoneAlreadyExistsException e) {
            bindingResult.rejectValue("phone", "phone.exists", e.getMessage());
            model.addAttribute("studentProfile", userProfileEditDto);
            return "student/profile-edit";
        }
    }
}
