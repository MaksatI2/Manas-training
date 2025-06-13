package manasTrainingService.controller;

import jakarta.persistence.EntityNotFoundException;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
public class CourseMvcController {

    @Autowired
    private CourseService courseService;

    @GetMapping("/courses")
    public String getCourseList(Model model) {
        try {
            List<CourseDto> courses = courseService.getAllCourses();
            List<CourseCategoryDto> categories = courseService.getCategories();
            model.addAttribute("courses", courses);
            model.addAttribute("categories", categories);
            return "course/course_list";
        } catch (EntityNotFoundException e) {
            model.addAttribute("errorMessage", "Ошибка при загрузке курсов");
            return "error/error";
        }
    }

    @GetMapping("/courses/{id}")
    public String getCourseDetails(@PathVariable Integer id, Model model, Authentication authentication) {
        try {
            CourseDto course = courseService.getCourseById(id);
            model.addAttribute("course", course);
            boolean canEnroll = authentication != null && authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_STUDENT") || a.getAuthority().equals("ROLE_ORGANIZATION"));
            model.addAttribute("canEnroll", canEnroll);
            return "course/course_details";
        } catch (EntityNotFoundException e) {
            model.addAttribute("errorMessage", "Курс не найден");
            return "error/error";
        }
    }
}