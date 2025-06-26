package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.LessonCreateRequest;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.dto.lesson.LessonEditDto;
import manasTrainingService.dto.lesson.LessonMaterialDTO;
import manasTrainingService.dto.lesson.ScheduleDTO;
import manasTrainingService.dto.teacher.CourseInstanceTeacherDTO;
import manasTrainingService.entity.LessonType;
import manasTrainingService.service.*;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseModuleService;
import manasTrainingService.service.course.CourseTeacherInstanceService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminLessonController {

    private final LessonService lessonService;
    private final CourseModuleService courseModuleService;
    private final CourseInstanceService courseInstanceService;
    private final LessonMaterialService lessonMaterialService;
    private final ScheduleService scheduleService;
    private final CourseTeacherInstanceService courseTeacherInstanceService;


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
        model.addAttribute("minutesLeft", lessonService.getMinutesLeft(courseModuleService.getCourseModuleById(moduleId)));
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

    @GetMapping("/lessons/{lessonId}/materials/new")
    public String showMaterialForm(@PathVariable Integer lessonId, Model model) {
        LessonDTO lesson = lessonService.getLessonById(lessonId);
        model.addAttribute("lesson", lesson);
        model.addAttribute("material", LessonMaterialDTO.builder().lessonId(lessonId).build());
        return "lessons/lesson-material";
    }

    @PostMapping("/lessons/{lessonId}/materials")
    public String addMaterial(
            @PathVariable Integer lessonId,
            @Valid @ModelAttribute("material") LessonMaterialDTO material,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("lesson", lessonService.getLessonById(lessonId));
            model.addAttribute("errorMessage", "Пожалуйста, исправьте ошибки в форме");
            return "lessons/lesson-material";
        }

        try {
            lessonMaterialService.addMaterial(material);
            redirectAttributes.addFlashAttribute("successMessage", "Материал добавлен");
            return "redirect:/lessons/" + lessonId;
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/lessons/" + lessonId;
        }
    }

    @PostMapping("/lessons/{lessonId}/materials/{materialId}/delete")
    public String deleteMaterial(
            @PathVariable Integer lessonId,
            @PathVariable Integer materialId,
            RedirectAttributes redirectAttributes) {
        try {
            lessonMaterialService.deleteMaterial(materialId);
            redirectAttributes.addFlashAttribute("successMessage", "Материал удален");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/lessons/" + lessonId;
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
