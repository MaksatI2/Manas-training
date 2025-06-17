package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseInstanceDTO;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.service.CourseCategoryService;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.CourseService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/course-instances")
@RequiredArgsConstructor
public class CourseInstanceController {
    private final CourseInstanceService courseInstanceService;
    private final CourseService courseService;


    @GetMapping
    public String listCourseInstances(Model model) {
        model.addAttribute("courseInstances", courseInstanceService.findAll());
        return "admin/course-instance-list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("courseInstanceDto", new CourseInstanceDTO());
        model.addAttribute("courses", courseService.getAllCourses());
        return "admin/course-instance-create";
    }

    @PostMapping("/create")
    public String createCourseInstance(@Valid CourseInstanceDTO courseInstanceDTO, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("courseInstanceDto", courseInstanceDTO);

            model.addAttribute("courses", courseService.getAllCourses());
            return "admin/course-instance-create";
        }
        courseInstanceService.createCourseInstance(courseInstanceDTO);
        return "redirect:/admin/course-instances";
    }
}