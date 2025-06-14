package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.service.CourseCategoryAdminService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;
import java.util.Optional;
import java.util.stream.IntStream;

@Controller
@RequestMapping("/admin/categories")
@RequiredArgsConstructor
public class AdminCategoryController {

    private final CourseCategoryAdminService categoryService;

    @GetMapping
    public String listCategories(@RequestParam Optional<String> search,
                                 @RequestParam Optional<Integer> page,
                                 @RequestHeader(value = "X-Requested-With", required = false)
                                 String requestedWith, Model model) {
        int currentPage = page.orElse(1);
        int pageSize = 10;

        Page<CourseCategoryDto> categoryPage = categoryService.getPage(search.orElse(null),
                PageRequest.of(currentPage - 1, pageSize));
        model.addAttribute("categoryPage", categoryPage);
        model.addAttribute("search", search.orElse(""));

        if (categoryPage.getTotalPages() > 1) {
            List<Integer> pageNumbers = IntStream.rangeClosed(1, categoryPage.getTotalPages()).boxed().toList();
            model.addAttribute("pageNumbers", pageNumbers);
        }
        if ("XMLHttpRequest".equals(requestedWith)) {
            return "admin/categories";
        }
        return "admin/categories";
    }


    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("categoryDto", new CourseCategoryDto());
        return "admin/category-form";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try {
            CourseCategoryDto dto = categoryService.getById(id);
            model.addAttribute("categoryDto", dto);
            return "admin/category-form";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Категория не найдена");
            return "redirect:/admin/categories";
        }
    }

    @PostMapping("/save")
    public String saveCategory(@Valid @ModelAttribute("categoryDto")
                               CourseCategoryDto dto,
                               BindingResult bindingResult,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "admin/category-form";
        }

        try {
            if (dto.getId() != null) {
                categoryService.update(dto.getId(), dto);
                redirectAttributes.addFlashAttribute("successMessage", "Категория обновлена");
            } else {
                categoryService.create(dto);
                redirectAttributes.addFlashAttribute("successMessage", "Категория создана");
            }
            return "redirect:/admin/categories";
        } catch (IllegalArgumentException e) {
            bindingResult.rejectValue("name", "error.name", e.getMessage());
            return "admin/category-form";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/categories";
        }
    }


    @GetMapping("/delete/{id}")
    public String deleteCategory(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            categoryService.delete(id);
            redirectAttributes.addFlashAttribute("successMessage", "Категория удалена");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Ошибка удаления: " + e.getMessage());
        }
        return "redirect:/admin/categories";
    }

}
