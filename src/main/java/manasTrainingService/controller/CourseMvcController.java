package manasTrainingService.controller;

import jakarta.persistence.EntityNotFoundException;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class CourseMvcController {

    @Autowired
    private CourseController courseController;

    @GetMapping("/courses")
    public String getCourseList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false) String search,
            Model model) {
        try {
            Page<CourseDto> courses = courseController.getCourses(page, categoryId, search).getBody();
            List<CourseCategoryDto> categories = courseController.getCategories().getBody();
            model.addAttribute("courses", courses.getContent());
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", courses.getTotalPages());
            model.addAttribute("categories", categories);
            model.addAttribute("categoryId", categoryId);
            model.addAttribute("search", search);
            return "course/course_list";
        } catch (EntityNotFoundException e) {
            model.addAttribute("errorMessage", "Выбрана неверная категория");
            return "error/error";
        }
    }

    @GetMapping("/courses/{id}")
    public String getCourseDetails(@PathVariable Integer id, Model model, Authentication authentication) {
        try {
            CourseDto course = courseController.getCourseById(id).getBody();
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

    @GetMapping("/courses/reset")
    public String resetFilters() {
        return "redirect:/courses";
    }
}