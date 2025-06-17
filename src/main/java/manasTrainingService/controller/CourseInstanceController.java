package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseInstanceCreationDTO;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.CoursePlanDTO;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.CourseModuleService;
import manasTrainingService.service.CourseService;
import manasTrainingService.service.LessonService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/course-instances")
@RequiredArgsConstructor
public class CourseInstanceController {
    private final CourseInstanceService courseInstanceService;
    private final CourseService courseService;
    private final LessonService lessonService;
    private final CourseModuleService courseModuleService;

    @GetMapping
    public String listCourseInstances(Model model) {
        model.addAttribute("courseInstances", courseInstanceService.findAll());
        return "admin/course-instance-list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("courseInstanceDto", new CourseInstanceCreationDTO());
        model.addAttribute("courses", courseService.getAllCourses());
        return "admin/course-instance-create";
    }

    @PostMapping("/create")
    public String createCourseInstance(@Valid @ModelAttribute("courseInstanceDto")CourseInstanceCreationDTO courseInstanceCreationDTO, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("courses", courseService.getAllCourses());
            return "admin/course-instance-create";
        }
        courseInstanceService.createCourseInstance(courseInstanceCreationDTO);
        return "redirect:/admin/course-instances";
    }

    @GetMapping("/{id}")
    public String viewCourseInstance(@PathVariable Integer id, Model model) {
        CourseInstanceDTO courseInstanceDto = courseInstanceService.getCourseInstanceById(id);
        model.addAttribute("courseInstance", courseInstanceDto);
        return "admin/course-instance-detail";
    }

}