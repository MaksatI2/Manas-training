package manasTrainingService.controller;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.test.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/courses")
@RequiredArgsConstructor
public class CourseController {

    @Autowired
    private CourseService courseService;
    @Autowired
    private TestService testService;

    @GetMapping
    public String getCourseList(Model model) {
        try {
            List<CourseDto> courses = courseService.getAllCourses();
            List<CourseCategoryDto> categories = courseService.getCategories();
            model.addAttribute("courses", courses);
            model.addAttribute("categories", categories);
            return "courses/course_list";
        } catch (EntityNotFoundException e) {
            model.addAttribute("errorMessage", "Ошибка при загрузке курсов");
            return "error/error";
        }
    }

    @GetMapping("/{id}")
    public String getCourseDetails(@PathVariable Integer id, Model model, Authentication authentication) {
        try {
            CourseDto course = courseService.getById(id);
            model.addAttribute("course", course);
            boolean canEnroll = authentication != null && authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_STUDENT") || a.getAuthority().equals("ROLE_ORGANIZATION"));
            model.addAttribute("canEnroll", canEnroll);
            return "courses/course-view";
        } catch (EntityNotFoundException e) {
            model.addAttribute("errorMessage", "Курс не найден");
            return "error/error";
        }
    }

    @GetMapping("/{id}/tests")
    public String getCourseTests(@PathVariable Integer id, Model model) {
        model.addAttribute("tests", testService.getAllTestsByCourseId(id));
        model.addAttribute("courseId", id);
        return "tests/course-tests";
    }
}