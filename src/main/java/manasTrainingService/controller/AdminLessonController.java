package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.LessonCreateRequest;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.CourseModuleService;
import manasTrainingService.service.LessonService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/course-instances")
public class AdminLessonController {

    private final LessonService lessonService;
    private final CourseModuleService courseModuleService;
    private final CourseInstanceService courseInstanceService;


    @GetMapping("/{instanceId}/modules/{moduleId}/lessons/new")
    public String showCreateLessonForm(@PathVariable Integer instanceId,
                                       @PathVariable Integer moduleId,
                                       Model model) {

        if (!model.containsAttribute("lessonCreateRequest")) {

            model.addAttribute("lessonCreateRequest", new LessonCreateRequest());
        }
        if (!courseModuleService.getCourseModuleById(moduleId).getCourseInstance().getId().equals(instanceId)) {
            throw new IllegalStateException("Данный модуль не относится к этому курсу");
        }
        model.addAttribute("minutesLeft", lessonService.getMinutesLeft(courseModuleService.getCourseModuleById(moduleId)));
        model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(instanceId));
        model.addAttribute("module", courseModuleService.getCourseModuleById(moduleId));
        return "admin/lesson-create";
    }

    @PostMapping("/{instanceId}/modules/{moduleId}/lessons")
    public String createLesson(@PathVariable Integer instanceId,
                               @PathVariable Integer moduleId,
                               @Valid @ModelAttribute("lessonCreateRequest") LessonCreateRequest request,
                               BindingResult bindingResult,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("minutesLeft", lessonService.getMinutesLeft(courseModuleService.getCourseModuleById(moduleId)));
            model.addAttribute("lessonCreateRequest", request);
            model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(instanceId));
            model.addAttribute("module", courseModuleService.getCourseModuleById(moduleId));
            return "admin/lesson-create";
        }

        try {
            Integer courseInstanceId = lessonService.createLesson(request, courseModuleService.getCourseModuleById(moduleId));
            redirectAttributes.addFlashAttribute("success", "Урок успешно создан");
            return "redirect:/admin/course-instances/" + courseInstanceId;
        } catch (IllegalArgumentException e) {
            bindingResult.rejectValue("durationMinutes", "error.durationMinutes", e.getMessage());

            model.addAttribute("lessonCreateRequest", request);
            model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(instanceId));
            model.addAttribute("module", courseModuleService.getCourseModuleById(moduleId));

            return "admin/lesson-create";
        }
    }
}
