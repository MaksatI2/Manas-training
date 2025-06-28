package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.dto.lesson.LessonMaterialDTO;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.service.LessonAccessService;
import manasTrainingService.service.LessonMaterialService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.ScheduleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
public class PublicLessonController {

    private final LessonService lessonService;
    private final LessonMaterialService lessonMaterialsService;
    private final ScheduleService scheduleService;
    private final LessonAccessService lessonAccessService;
    private final LessonMaterialService lessonMaterialService;

    @GetMapping("/lessons/{lessonId}")
    public String showLessonDetails(@PathVariable Integer lessonId, Model model) {
        if (!lessonAccessService.canAccessLesson(lessonService.getLessonModelById(lessonId))) {
            throw new NoAccessException("У вас нет доступа к данному уроку");
        }
        LessonDTO lesson = lessonService.getLessonById(lessonId);
        model.addAttribute("lesson", lesson);
        model.addAttribute("materials", lessonMaterialsService.getMaterialsByLessonId(lessonId));
        model.addAttribute("schedule", scheduleService.getScheduleByLessonId(lessonId));
        return "lessons/lesson";
    }

    @GetMapping("/lessons/{lessonId}/materials/new")
    public String showMaterialForm(@PathVariable Integer lessonId, Model model) {
        if (!lessonAccessService.canAccessLessonStaff(lessonService.getLessonModelById(lessonId))) {
            throw new NoAccessException("У вас нет доступа к данному уроку");
        }        LessonDTO lesson = lessonService.getLessonById(lessonId);
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
}