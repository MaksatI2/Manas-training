package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.service.course.CourseCategoryService;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;

@Controller
@RequestMapping("/admin/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CourseCategoryService categoryService;
    private final MessageSource messageSource;

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("categoryDto", new CourseCategoryDto());
        return "admin/category-add";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try {
            CourseCategoryDto dto = categoryService.getById(id);
            model.addAttribute("categoryDto", dto);
            return "admin/category-edit";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    messageSource.getMessage(
                            "category.not.found",
                            null,
                            LocaleContextHolder.getLocale()
                    )
            );
            return "redirect:/admin/categories";
        }
    }

    @PostMapping("/save")
    public String saveCategory(@Valid @ModelAttribute("categoryDto") CourseCategoryDto dto,
                               BindingResult bindingResult,
                               Model model,
                               RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            if (dto.getId() != null) {
                return "admin/category-edit";
            } else {
                return "admin/category-add";
            }
        }

        try {
            if (dto.getId() != null) {
                categoryService.update(dto.getId(), dto);
                redirectAttributes.addFlashAttribute(
                        "successMessage",
                        messageSource.getMessage("category.updated.success", null, LocaleContextHolder.getLocale())
                );
            } else {
                categoryService.create(dto);
                redirectAttributes.addFlashAttribute(
                        "successMessage",
                        messageSource.getMessage("category.created.success", null, LocaleContextHolder.getLocale())
                );
            }
            return "redirect:/admin/categories";

        } catch (IllegalArgumentException e) {
            bindingResult.rejectValue("name", "error.name", e.getMessage());

            if (dto.getId() != null) {
                return "admin/category-edit";
            } else {
                return "admin/category-add";
            }

        } catch (Exception e) {
            model.addAttribute(
                    "errorMessage",
                    messageSource.getMessage("category.save.error", new Object[]{e.getMessage()}, LocaleContextHolder.getLocale())
            );

            if (dto.getId() != null) {
                return "admin/category-edit";
            } else {
                return "admin/category-add";
            }
        }
    }

    @GetMapping
    public String listCategories(Model model) {
        List<CourseCategoryDto> categories = categoryService.getAllCategories();
        model.addAttribute("categories", categories);
        return "admin/categories";
    }

    @PostMapping("/delete/{id}")
    public String deleteCategory(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            categoryService.delete(id);
            redirectAttributes.addFlashAttribute(
                    "successMessage",
                    messageSource.getMessage("category.deleted.success", null, LocaleContextHolder.getLocale())
            );
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    messageSource.getMessage("category.delete.error", new Object[]{e.getMessage()}, LocaleContextHolder.getLocale())
            );
        }
        return "redirect:/admin/categories";
    }

}
