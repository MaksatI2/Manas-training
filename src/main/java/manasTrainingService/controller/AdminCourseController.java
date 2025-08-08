package manasTrainingService.controller;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.create.CreateCourseDto;
import manasTrainingService.dto.edit.CourseEditDto;
import manasTrainingService.service.course.CourseAdminService;
import manasTrainingService.service.course.CourseCategoryService;
import manasTrainingService.service.course.CourseService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.beans.PropertyEditorSupport;
import java.util.List;

@Controller
@RequestMapping("/admin/courses")
@RequiredArgsConstructor
public class AdminCourseController {

    private final CourseAdminService courseAdminService;
    private final CourseCategoryService categoryAdminService;
    private final CourseService courseService;


    @GetMapping
    public String listCourses(Model model) {
        List<CourseDto> courses = courseAdminService.getAllCourses();
        List<CourseCategoryDto> categories = categoryAdminService.getAll(null);

        model.addAttribute("courses", courses);
        model.addAttribute("categories", categories);

        boolean isAdmin = SecurityContextHolder.getContext().getAuthentication().getAuthorities()
                .contains(new SimpleGrantedAuthority("ADMIN"));
        model.addAttribute("isAdmin", isAdmin);

        return "admin/courses";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        List<CourseCategoryDto> categories = categoryAdminService.getAll(null);
        model.addAttribute("categories", categories);
        model.addAttribute("course", new CreateCourseDto());
        return "admin/course-add";
    }

    @PostMapping("/add")
    public String addCourse(@Valid @ModelAttribute("course") CreateCourseDto createCourseDto,
                            BindingResult bindingResult,
                            Model model,
                            RedirectAttributes redirectAttributes) {

        if (bindingResult.hasFieldErrors("duration")) {
            for (FieldError error : bindingResult.getFieldErrors("duration")) {
                if ("typeMismatch".equals(error.getCode())) {
                    bindingResult.rejectValue("duration", "duration.invalid", "Некорректная продолжительность — введите число от 1 до 10 000");
                    break;
                }
            }
        }

        if (bindingResult.hasErrors()) {
            List<CourseCategoryDto> categories = categoryAdminService.getAll(null);
            model.addAttribute("categories", categories);
            return "admin/course-add";
        }

        try {
            CourseDto savedCourse = courseAdminService.create(createCourseDto);
            redirectAttributes.addFlashAttribute("successMessage", "Курс успешно создан");
            return "redirect:/admin/courses/" + savedCourse.getId();
        } catch (Exception e) {
            List<CourseCategoryDto> categories = categoryAdminService.getAll(null);
            model.addAttribute("categories", categories);
            model.addAttribute("errorMessage", e.getMessage());
            return "admin/course-add";
        }
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try {
            CourseDto course = courseAdminService.getById(id);
            List<CourseCategoryDto> categories = categoryAdminService.getAll(null);

            CourseEditDto updateCourseDto = courseAdminService.convertToEditDto(course);

            model.addAttribute("course", updateCourseDto);
            model.addAttribute("categories", categories);
            return "admin/course-edit";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/courses";
        }
    }

    @PostMapping("/edit/{id}")
    public String editCourse(@PathVariable Integer id,
                             @Valid @ModelAttribute("course") CourseEditDto updateCourseDto,
                             BindingResult bindingResult,
                             HttpServletRequest request,
                             Model model,
                             RedirectAttributes redirectAttributes) {

        if (bindingResult.hasFieldErrors("duration")) {
            for (FieldError error : bindingResult.getFieldErrors("duration")) {
                if ("typeMismatch".equals(error.getCode())) {
                    bindingResult.rejectValue("duration", "duration.invalid", "Некорректная продолжительность — введите число от 1 до 10 000");
                    break;
                }
            }
        }
        updateCourseDto.setId(id);

        String[] activeValues = request.getParameterValues("active");
        String[] individualValues = request.getParameterValues("individual");
        updateCourseDto = courseAdminService.prepareEditDtoWithRequestParams(updateCourseDto, activeValues, individualValues);

        if (bindingResult.hasErrors()) {
            List<CourseCategoryDto> categories = categoryAdminService.getAll(null);
            model.addAttribute("categories", categories);
            return "admin/course-edit";
        }

        try {
            CourseDto updatedCourse = courseAdminService.update(updateCourseDto);
            redirectAttributes.addFlashAttribute("successMessage", "Курс успешно обновлен");
            return "redirect:/admin/courses/" + updatedCourse.getId();
        } catch (Exception e) {
            List<CourseCategoryDto> categories = categoryAdminService.getAll(null);
            model.addAttribute("categories", categories);
            model.addAttribute("errorMessage", e.getMessage());
            return "admin/course-edit";
        }
    }

    @GetMapping("/delete/{id}")
    public String deleteCourse(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            courseAdminService.deleteCourse(id);
            redirectAttributes.addFlashAttribute("successMessage", "Курс успешно удалён");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/courses";
    }

    @GetMapping("/{id}")
    public String getCourseDetails(@PathVariable Integer id, Model model, Authentication authentication) {
        try {
            CourseDto course = courseService.getById(id);
            model.addAttribute("course", course);
            boolean canEnroll = authentication != null && authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_STUDENT") || a.getAuthority().equals("ROLE_ORGANIZATION"));
            model.addAttribute("canEnroll", canEnroll);
            return "admin/course-view";
        } catch (EntityNotFoundException e) {
            model.addAttribute("errorMessage", "Курс не найден");
            return "error/error";
        }
    }

}