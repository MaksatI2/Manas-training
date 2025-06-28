package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.LessonCreateRequest;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.dto.lesson.LessonEditDto;
import manasTrainingService.service.*;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseModuleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminLessonController {

    private final LessonService lessonService;
    private final CourseModuleService courseModuleService;
    private final CourseInstanceService courseInstanceService;
    private final LessonMaterialService lessonMaterialService;

    @GetMapping("/course-instances/{instanceId}/modules/{moduleId}/lessons/new")
    public String showCreateLessonForm(@PathVariable Integer instanceId,
                                       @PathVariable Integer moduleId,
                                       Model model) {

        if (!model.containsAttribute("lessonCreateRequest")) {

            model.addAttribute("lessonCreateRequest", new LessonCreateRequest());
        }
        if (!courseModuleService.getCourseModuleById(moduleId).getCourseInstance().getId().equals(instanceId)) {
            throw new IllegalStateException("Данный модуль не относится к этому курсу");
        }
        model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(instanceId));
        model.addAttribute("module", courseModuleService.getCourseModuleById(moduleId));
        return "admin/lesson-create";
    }

    @PostMapping("/course-instances/{instanceId}/modules/{moduleId}/lessons")
    public String createLesson(@PathVariable Integer instanceId,
                               @PathVariable Integer moduleId,
                               @Valid @ModelAttribute("lessonCreateRequest") LessonCreateRequest request,
                               BindingResult bindingResult,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("lessonCreateRequest", request);
            model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(instanceId));
            model.addAttribute("module", courseModuleService.getCourseModuleById(moduleId));
            return "admin/lesson-create";
        }

        try {
            Integer courseInstanceId = lessonService.createLesson(request, courseModuleService.getCourseModuleById(moduleId));
            redirectAttributes.addFlashAttribute("successMessage", "Урок успешно создан");
            return "redirect:/admin/course-instances/" + courseInstanceId;
        } catch (IllegalArgumentException e) {

            model.addAttribute("lessonCreateRequest", request);
            model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(instanceId));
            model.addAttribute("module", courseModuleService.getCourseModuleById(moduleId));

            return "admin/lesson-create";
        }
    }


    @PostMapping("/lessons/{id}/delete")
    public String deleteLesson(@PathVariable Integer id,
                               RedirectAttributes redirectAttributes) {
        LessonDTO lesson = lessonService.getLessonById(id);
        CourseModuleDTO module = courseModuleService.getCourseModuleDTOById(lesson.getModuleId());
        lessonService.deleteById(id);
        redirectAttributes.addFlashAttribute("successMessage", "Урок удалён");
        return "redirect:/admin/course-instances/" + module.getCourseInstanceId();
    }

    @GetMapping("/lessons/{id}/edit")
    public String editLessonForm(@PathVariable Integer id, Model model) {
        LessonEditDto lesson = lessonService.getLessonEditDto(id);
        model.addAttribute("lessonId", id);

        model.addAttribute("lessonEditDto", lesson);
        return "admin/lesson-edit";
    }

    @PostMapping("/lessons/{id}/edit")
    public String updateLesson(@PathVariable Integer id,
                               @Valid @ModelAttribute("lessonEditDto") LessonEditDto dto,
                               BindingResult bindingResult,
                               RedirectAttributes redirectAttributes,
                               Model model) {
        model.addAttribute("lessonId", id);

        if (bindingResult.hasErrors()) {
            return "admin/lesson-edit";
        }

        try {
            lessonService.updateLesson(id, dto);
        } catch (IllegalArgumentException ex) {
            bindingResult.rejectValue("durationMinutes", "lesson.duration.exceeded", ex.getMessage());
            return "admin/lesson-edit";
        }

        redirectAttributes.addFlashAttribute("successMessage", "Урок обновлён");
        return "redirect:/lessons/" + id;
    }
}
