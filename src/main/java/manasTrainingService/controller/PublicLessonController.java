package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.config.CustomUserDetails;
import manasTrainingService.dto.instance.LessonCreateRequest;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.dto.jitsi.MeetingResponseDTO;
import manasTrainingService.dto.lesson.LessonMaterialDTO;
import manasTrainingService.dto.lesson.ScheduleDTO;
import manasTrainingService.entity.Lesson;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.service.LessonAccessService;
import manasTrainingService.service.LessonMaterialService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.ScheduleService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseModuleService;
import manasTrainingService.service.jitsi.MeetingService;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Locale;

@Controller
@RequiredArgsConstructor
public class PublicLessonController {

    private final LessonService lessonService;
    private final LessonMaterialService lessonMaterialsService;
    private final ScheduleService scheduleService;
    private final LessonAccessService lessonAccessService;
    private final LessonMaterialService lessonMaterialService;
    private final CourseModuleService courseModuleService;
    private final CourseInstanceService courseInstanceService;
    private final MeetingService meetingService;
    private final MessageSource messageSource;

    @GetMapping("/lessons/{lessonId}")
    public String showLessonDetails(@PathVariable Integer lessonId, Model model, Authentication authentication) {
        Locale locale = LocaleContextHolder.getLocale();

        if (!lessonAccessService.canAccessLesson(lessonService.getLessonModelById(lessonId))) {
            throw new NoAccessException(messageSource.getMessage("lesson.access.no_access", null, locale));
        }

        LessonDTO lesson = lessonService.getLessonById(lessonId);
        model.addAttribute("lesson", lesson);
        model.addAttribute("materials", lessonMaterialsService.getMaterialsByLessonId(lessonId));

        ScheduleDTO schedule = scheduleService.getScheduleByLessonId(lessonId);
        model.addAttribute("schedule", schedule);

        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            model.addAttribute("currentUserId", userDetails.getUser().getId());
        }

        if (schedule != null) {
            boolean isMeetingActive = meetingService.isMeetingActive(schedule.getId());
            model.addAttribute("isMeetingActive", isMeetingActive);

            if (isMeetingActive) {
                MeetingResponseDTO activeMeeting = meetingService.getMeetingByScheduleId(schedule.getId());
                model.addAttribute("activeMeeting", activeMeeting);
            }
        }

        return "lessons/lesson";
    }

    @GetMapping("/lessons/{lessonId}/materials/new")
    public String showMaterialForm(@PathVariable Integer lessonId, Model model) {
        Locale locale = LocaleContextHolder.getLocale();

        if (!lessonAccessService.canAccessLessonStaff(lessonService.getLessonModelById(lessonId))) {
            throw new NoAccessException(messageSource.getMessage("lesson.access.no_access", null, locale));
        }
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
        Locale locale = LocaleContextHolder.getLocale();

        if (bindingResult.hasErrors()) {
            model.addAttribute("lesson", lessonService.getLessonById(lessonId));
            model.addAttribute("errorMessage",
                    messageSource.getMessage("lesson.material.form_error", null, locale));
            return "lessons/lesson-material";
        }

        try {
            lessonMaterialService.addMaterial(material);
            redirectAttributes.addFlashAttribute("successMessage",
                    messageSource.getMessage("lesson.material.add_success", null, locale));
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
            redirectAttributes.addFlashAttribute("successMessage",
                    messageSource.getMessage("lesson.material.delete_success", null, LocaleContextHolder.getLocale()));
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/lessons/" + lessonId;
    }

    @GetMapping("/course-instances/{instanceId}/modules/{moduleId}/lessons/new")
    public String showCreateLessonForm(@PathVariable Integer instanceId,
                                       @PathVariable Integer moduleId,
                                       Model model) {
        Locale locale = LocaleContextHolder.getLocale();

        if (!lessonAccessService.canAccessModuleCreation(courseModuleService.getCourseModuleById(moduleId))) {
            throw new NoAccessException(
                    messageSource.getMessage("lesson.access.module_creation_no_access", null, locale));
        }

        if (!model.containsAttribute("lessonCreateRequest")) {
            model.addAttribute("lessonCreateRequest", new LessonCreateRequest());
        }

        if (!courseModuleService.getCourseModuleById(moduleId)
                .getCourseInstance()
                .getId()
                .equals(instanceId)) {
            throw new IllegalStateException(
                    messageSource.getMessage("lesson.module.invalid_instance", null, locale));
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
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        boolean isAdmin = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .anyMatch(role -> role.equals("ADMIN"));
        boolean isTeacher = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .anyMatch(role -> role.equals("TEACHER"));
        if (bindingResult.hasErrors()) {
            model.addAttribute("lessonCreateRequest", request);
            model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(instanceId));
            model.addAttribute("module", courseModuleService.getCourseModuleById(moduleId));
            return "admin/lesson-create";
        }

        try {
            Integer courseInstanceId = lessonService.createLesson(request, courseModuleService.getCourseModuleById(moduleId));
            redirectAttributes.addFlashAttribute("successMessage",
                    messageSource.getMessage("lesson.create_success", null, LocaleContextHolder.getLocale()));
            if (isAdmin) {
                return "redirect:/admin/course-instances/" + courseInstanceId;
            } else if (isTeacher) {
                return "redirect:/teacher/course/" + courseInstanceId;
            }
            return "redirect:/";
        } catch (IllegalArgumentException e) {

            model.addAttribute("lessonCreateRequest", request);
            model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(instanceId));
            model.addAttribute("module", courseModuleService.getCourseModuleById(moduleId));

            return "admin/lesson-create";
        }
    }

    @GetMapping("/lessons/{lessonId}/content-page")
    public String getLessonContentPage(@PathVariable Integer lessonId, Model model, Authentication authentication) {
        Lesson lesson = lessonService.getLessonModelById(lessonId);

        if (!lessonAccessService.canAccessLesson(lesson)) {
            throw new NoAccessException(messageSource.getMessage("lesson.access.no_access", null, LocaleContextHolder.getLocale()));
        }

        model.addAttribute("lesson", lesson);
        boolean isTeacherOrAdmin = authentication != null &&
                authentication.getAuthorities().stream()
                        .anyMatch(a -> a.getAuthority().equals("TEACHER") || a.getAuthority().equals("ADMIN"));

        model.addAttribute("isTeacherOrAdmin", isTeacherOrAdmin);

        return "lessons/content";
    }

}