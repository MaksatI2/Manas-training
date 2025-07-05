package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.edit.UserProfileEditDto;
import manasTrainingService.dto.instance.CourseEnrollmentCardDTO;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.exceptions.nsee.user.PhoneAlreadyExistsException;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.user.StudentService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/student")
@RequiredArgsConstructor
public class StudentController {
    private final StudentService studentService;
    private final UserService userService;
    private final EnrollmentService enrollmentService;
    private final CourseInstanceService courseInstanceService;

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
            model.addAttribute("errorMessage", "Данный телефонный номер уже зарегистрирован");
            model.addAttribute("studentProfile", userProfileEditDto);
            return "student/profile-edit";
        }
    }

    @GetMapping("my-courses")
    public String getCourses(Model model) {
        List<CourseEnrollmentCardDTO> studentCourses = enrollmentService.getStudentCourses();
        model.addAttribute("courses", studentCourses);
        return "student/my-courses";
    }

    @GetMapping("/course/{id}")
    public String viewStudentCourse(@PathVariable Integer id,
                                    Model model) {
        enrollmentService.hasAccess(id);
        CourseInstanceDTO courseInstanceDto = courseInstanceService.getCourseInstanceById(id);
        model.addAttribute("courseInstance", courseInstanceDto);
        model.addAttribute("userRole", userService.getAuthorizedUser().getRole());
        return "student/course-detail";
    }

}
