package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseInstanceCreationDTO;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.instance.CourseInstanceUpdateDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.CourseModuleListDTO;
import manasTrainingService.dto.instance.CourseModuleUpdateDTO;
import manasTrainingService.dto.instance.LessonCreateRequest;
import manasTrainingService.dto.teacher.TeacherFormDTO;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseModuleService;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.course.CourseTeacherInstanceService;
import manasTrainingService.service.course.CourseTeacherService;
import manasTrainingService.service.ScheduleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;



@Controller
@RequestMapping("/admin/course-instances")
@RequiredArgsConstructor
public class CourseInstanceController {
    private final CourseInstanceService courseInstanceService;
    private final CourseService courseService;
    private final CourseModuleService courseModuleService;
    private final CourseTeacherService courseTeacherService;
    private final CourseTeacherInstanceService courseInstanceTeacherService;
    private final ScheduleService scheduleService;

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


    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable Integer id, Model model) {
        model.addAttribute("courseInstanceDto", courseInstanceService.getUpdateDtoById(id));
        return "admin/course-instance-edit";
    }

    @PostMapping("/{id}/edit")
    public String updateCourseInstance(@PathVariable Integer id,
                                       @Valid @ModelAttribute("courseInstanceDto") CourseInstanceUpdateDTO courseInstanceDto,
                                       BindingResult result,
                                       Model model,
                                       RedirectAttributes redirectAttributes) {
        if (scheduleService.hasSchedulesBeforeDateRange(id, courseInstanceDto.getStartDate())) {
            result.rejectValue("startDate", "lesson.date.conflict.start", "Существуют уроки до новой даты начала");
        }
        if (scheduleService.hasSchedulesAfterDateRange(id, courseInstanceDto.getEndDate())) {
            result.rejectValue("endDate", "lesson.date.conflict.end", "Существуют уроки после новой даты окончания");
        }

        if (result.hasErrors()) {
            model.addAttribute("courses", courseService.getAllCourses());
            return "admin/course-instance-edit";
        }

        courseInstanceService.updateCourseInstance(id, courseInstanceDto);
        redirectAttributes.addFlashAttribute("successMessage", "Поток курса успешно обновлён");
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
    public String createModules(@PathVariable Integer id,
                                @Valid @ModelAttribute("moduleListDto") CourseModuleListDTO moduleListDto,
                                BindingResult result,
                                Model model) {

        CourseInstanceDTO courseInstanceDto = courseInstanceService.getCourseInstanceById(id);
        List<CourseModuleDTO> modules = courseInstanceDto.getModules();
        int totalModuleHours = modules.stream().mapToInt(CourseModuleDTO::getDurationHours).sum();
        int remainingHours = courseInstanceDto.getDurationHours() - totalModuleHours;

        if (result.hasErrors()) {
            model.addAttribute("courseInstance", courseInstanceDto);
            model.addAttribute("modules", modules);
            model.addAttribute("remainingHours", remainingHours);
            return "admin/course-instance-modules";
        }

        try {
            courseModuleService.createCourseModules(id, moduleListDto.getModules());
            model.addAttribute("successMessage", "Модули были добавлены");
            return "redirect:/admin/course-instances/" + id;
        } catch (IllegalStateException e) {
            model.addAttribute("courseInstance", courseInstanceDto);
            model.addAttribute("modules", modules);
            model.addAttribute("remainingHours", remainingHours);
            model.addAttribute("errorMessage", e.getMessage());
            return "admin/course-instance-modules";
        }
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

    @PostMapping("/{id}/delete")
    public String deleteCourseInstance(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            courseInstanceService.deleteCourseInstance(id);
            redirectAttributes.addFlashAttribute("successMessage", "Поток курса успешно удалён");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Ошибка при удалении потока курса: " + e.getMessage());
        }
        return "redirect:/admin/course-instances";
    }


    @PostMapping("/{id}/modules/{moduleId}/delete")
    public String deleteModule(
            @PathVariable Integer id,
            @PathVariable Integer moduleId,
            RedirectAttributes redirectAttributes
    ) {
        try {
            courseModuleService.deleteByIdIfNoLessons(moduleId);
            redirectAttributes.addFlashAttribute("successMessage", "Модуль успешно удалён");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Модуль содержит уроки и не может быть удалён");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Ошибка при удалении модуля");
        }

        return "redirect:/admin/course-instances/" + id + "/modules";
    }

    @GetMapping("/{id}/modules/{moduleId}/edit")
    public String editModuleForm(
            @PathVariable Integer id,
            @PathVariable Integer moduleId,
            Model model
    ) {
        CourseModuleUpdateDTO dto = courseModuleService.getModuleForUpdate(moduleId);
        model.addAttribute("module", dto);
        model.addAttribute("courseInstanceId", id);
        model.addAttribute("moduleId", moduleId);
        return "admin/course-module-edit";
    }

    @PostMapping("/{id}/modules/{moduleId}/edit")
    public String updateModule(
            @PathVariable Integer id,
            @PathVariable Integer moduleId,
            @Valid @ModelAttribute("module") CourseModuleUpdateDTO dto,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model
    ) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("courseInstanceId", id);
            model.addAttribute("moduleId", moduleId);
            return "admin/course-module-edit";
        }

        try {
            courseModuleService.updateModule(moduleId, dto);
            redirectAttributes.addFlashAttribute("successMessage", "Модуль успешно обновлён");

        } catch (IllegalStateException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("courseInstanceId", id);
            model.addAttribute("moduleId", moduleId);
            return "admin/course-module-edit";
        }
        catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Ошибка при обновлении модуля");
        }

        return "redirect:/admin/course-instances/" + id + "/modules";
    }



}