package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseInstanceCreationDTO;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.CourseModuleListDTO;
import manasTrainingService.dto.instance.LessonCreateRequest;
import manasTrainingService.dto.teacher.TeacherFormDTO;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.CourseModuleService;
import manasTrainingService.service.CourseService;
import manasTrainingService.service.CourseTeacherInstanceService;
import manasTrainingService.service.CourseTeacherService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Optional;


@Controller
@RequestMapping("/admin/course-instances")
@RequiredArgsConstructor
public class CourseInstanceController {
    private final CourseInstanceService courseInstanceService;
    private final CourseService courseService;
    private final CourseModuleService courseModuleService;
    private final CourseTeacherService courseTeacherService;
    private final CourseTeacherInstanceService courseInstanceTeacherService;

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
        model.addAttribute("lessonCreateRequest", new LessonCreateRequest());
        return "admin/course-instance-detail";
    }

    @GetMapping("/{id}/modules")
    public String manageModules(@PathVariable Integer id, Model model) {
        CourseInstanceDTO courseInstanceDto = courseInstanceService.getCourseInstanceById(id);
        List<CourseModuleDTO> modules = courseInstanceDto.getModules();

        int totalModuleHours = modules.stream().mapToInt(CourseModuleDTO::getDurationHours).sum();
        int remainingHours = courseInstanceDto.getDurationHours() - totalModuleHours;

        model.addAttribute("courseInstance", courseInstanceDto);
        model.addAttribute("modules", modules);
        model.addAttribute("moduleListDto", new CourseModuleListDTO());
        model.addAttribute("remainingHours", remainingHours);
        return "admin/course-instance-modules";
    }

    @PostMapping("/{id}/modules")
    public String createModules(@PathVariable Integer id, @Valid @ModelAttribute("moduleListDto") CourseModuleListDTO moduleListDto, BindingResult result, Model model) {

        CourseInstanceDTO courseInstanceDto = courseInstanceService.getCourseInstanceById(id);
        List<CourseModuleDTO> modules = courseInstanceDto.getModules();
        int totalExistingHours = modules.stream()
                .mapToInt(CourseModuleDTO::getDurationHours)
                .sum();

        int newModulesHours = Optional.ofNullable(moduleListDto.getModules())
                .orElse(Collections.emptyList())
                .stream()
                .filter(Objects::nonNull)
                .mapToInt(m -> m.getDurationHours() != null ? m.getDurationHours() : 0)
                .sum();

        int totalHoursAfterAdd = totalExistingHours + newModulesHours;
        int maxAllowedHours = courseInstanceDto.getDurationHours();

        if (totalHoursAfterAdd > maxAllowedHours) {
            result.reject("duration.exceeded", "Общее количество часов превышает лимит курса");

            int remainingHours = maxAllowedHours - totalExistingHours;

            model.addAttribute("courseInstance", courseInstanceDto);
            model.addAttribute("modules", modules);
            model.addAttribute("remainingHours", remainingHours);
            model.addAttribute("errorMessage", "Общее количество часов превышает допустимое значение (" + maxAllowedHours + ")");
            return "admin/course-instance-modules";
        }

        if (result.hasErrors()) {

            int totalModuleHours = modules.stream().mapToInt(CourseModuleDTO::getDurationHours).sum();
            int remainingHours = courseInstanceDto.getDurationHours() - totalModuleHours;

            model.addAttribute("courseInstance", courseInstanceDto);
            model.addAttribute("modules", modules);
            model.addAttribute("remainingHours", remainingHours);
            return "admin/course-instance-modules";
        }

        model.addAttribute("successMessage", "Модули были добавлены");
        courseModuleService.createCourseModules(id, moduleListDto.getModules());
        return "redirect:/admin/course-instances/" + id;
    }

    @GetMapping("/{id}/teachers")
    public String showTeacherManagementPage(@PathVariable Integer id, Model model) {
        CourseInstanceDTO courseInstance = courseInstanceService.getCourseInstanceById(id);
        model.addAttribute("courseInstance", courseInstance);
        model.addAttribute("instanceTeachers", courseInstanceTeacherService.getTeachersByCourseInstanceId(id));
        model.addAttribute("eligibleTeachers", courseTeacherService.getEligibleTeachersForCourseInstance(id));
        model.addAttribute("teacherForm", new TeacherFormDTO());
        return "admin/manage-teachers";
    }

    @PostMapping("/{id}/teachers/add")
    public String addTeachers(
            @PathVariable Integer id,
            @Valid @ModelAttribute("teacherForm") TeacherFormDTO teacherForm,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(id));
            model.addAttribute("instanceTeachers", courseInstanceTeacherService.getTeachersByCourseInstanceId(id));
            model.addAttribute("eligibleTeachers", courseTeacherService.getEligibleTeachersForCourseInstance(id));
            model.addAttribute("errorMessage", "Пожалуйста, выберите хотя бы одного преподавателя");
            return "admin/manage-teachers";
        }

        try {
            courseInstanceTeacherService.addTeachers(id, teacherForm.getTeacherIds());
            redirectAttributes.addFlashAttribute("successMessage", "Преподаватели добавлены");
            return "redirect:/admin/course-instances/" + id + "/teachers";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/course-instances/" + id + "/teachers";
        }
    }

    @PostMapping("/{courseInstanceId}/teachers/{teacherId}/toggle-primary")
    public String togglePrimaryTeacher(@PathVariable Integer courseInstanceId,
                                       @PathVariable Integer teacherId,
                                       RedirectAttributes redirectAttributes) {
        try {
            courseInstanceTeacherService.togglePrimary(courseInstanceId, teacherId);
            redirectAttributes.addFlashAttribute("successMessage", "Статус преподавателя обновлён");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/course-instances/" + courseInstanceId + "/teachers";
    }


}