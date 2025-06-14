package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.service.CourseAdminService;
import manasTrainingService.service.CourseCategoryAdminService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Controller
@RequestMapping("/admin/courses")
@RequiredArgsConstructor
public class AdminCourseController {

    private final CourseAdminService courseAdminService;
    private final CourseCategoryAdminService categoryAdminService;

    @GetMapping
    public String listCourses(@RequestParam Optional<Integer> page,
                              @RequestParam Optional<String> search,
                              @RequestParam Optional<Integer> categoryId,
                              @RequestParam Optional<Boolean> isActive,
                              @RequestParam Optional<Boolean> isIndividual,
                              Model model,
                              @RequestHeader(value = "X-Requested-With", required = false) String requestedWith) {
        int currentPage = page.orElse(1);
        Page<CourseDto> coursePage = courseAdminService.getCourses(
                PageRequest.of(currentPage - 1, 10),
                categoryId.orElse(null),
                search.orElse(null),
                isActive.orElse(null),
                isIndividual.orElse(null));
        List<CourseCategoryDto> categories = categoryAdminService.getAll(null);
        model.addAttribute("coursePage", coursePage);
        model.addAttribute("categories", categories);
        model.addAttribute("selectedCategoryId", categoryId.orElse(null));
        model.addAttribute("searchQuery", search.orElse(""));
        model.addAttribute("selectedIsActive", isActive.orElse(null));
        model.addAttribute("selectedIsIndividual", isIndividual.orElse(null));
        boolean isAdmin = SecurityContextHolder.getContext().getAuthentication().getAuthorities()
                .contains(new SimpleGrantedAuthority("ADMIN"));
        model.addAttribute("isAdmin", isAdmin);
        if (coursePage.getTotalPages() > 1) {
            List<Integer> pageNumbers = IntStream.rangeClosed(1, coursePage.getTotalPages())
                    .boxed()
                    .collect(Collectors.toList());
            model.addAttribute("pageNumbers", pageNumbers);
        }
        return "admin/courses";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("courseDto", CourseDto.builder().active(true).individual(false).build());
        model.addAttribute("categories", categoryAdminService.getAll(null));
        boolean isAdmin = SecurityContextHolder.getContext().getAuthentication().getAuthorities()
                .contains(new SimpleGrantedAuthority("ADMIN"));
        model.addAttribute("isAdmin", isAdmin);
        return "admin/course-form";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try {
            CourseDto course = courseAdminService.getById(id);
            model.addAttribute("courseDto", course);
            model.addAttribute("categories", categoryAdminService.getAll(null));
            boolean isAdmin = SecurityContextHolder.getContext().getAuthentication().getAuthorities()
                    .contains(new SimpleGrantedAuthority("ADMIN"));
            model.addAttribute("isAdmin", isAdmin);
            return "admin/course-form";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/courses";
        }
    }

    @PostMapping("/save")
    public String saveCourse(@Valid @ModelAttribute("courseDto") CourseDto dto,
                             BindingResult bindingResult,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            for (FieldError error : bindingResult.getFieldErrors()) {
                dto.addError(error.getField(), error.getDefaultMessage());
            }
            model.addAttribute("courseDto", dto);
            model.addAttribute("categories", categoryAdminService.getAll(null));
            boolean isAdmin = SecurityContextHolder.getContext().getAuthentication().getAuthorities()
                    .contains(new SimpleGrantedAuthority("ADMIN"));
            model.addAttribute("isAdmin", isAdmin);
            return "admin/course-form";
        }
        try {
            if (dto.getId() != null) {
                courseAdminService.update(dto.getId(), dto);
                redirectAttributes.addFlashAttribute("successMessage", "Курс обновлён");
            } else {
                courseAdminService.create(dto);
                redirectAttributes.addFlashAttribute("successMessage", "Курс создан");
            }
            return "redirect:/admin/courses";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            model.addAttribute("courseDto", dto);
            model.addAttribute("categories", categoryAdminService.getAll(null));
            boolean isAdmin = SecurityContextHolder.getContext().getAuthentication().getAuthorities()
                    .contains(new SimpleGrantedAuthority("ADMIN"));
            model.addAttribute("isAdmin", isAdmin);
            return "admin/course-form";
        }
    }

    @GetMapping("/delete/{id}")
    public String deleteCourse(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            courseAdminService.delete(id);
            redirectAttributes.addFlashAttribute("successMessage", "Курс успешно удалён");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/courses";
    }
}