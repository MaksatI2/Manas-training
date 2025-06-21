package manasTrainingService.controller.publicview;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.TeacherCardDto;
import manasTrainingService.dto.profile.TeacherProfileDto;
import manasTrainingService.service.TeacherService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/teachers")
@RequiredArgsConstructor
public class TeacherViewController {

    private final TeacherService teacherService;

    @GetMapping
    public String listTeachers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "9") int size,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String department,
            Model model) {

        Pageable pageable = PageRequest.of(page, size);
        Page<TeacherCardDto> teacherPage = teacherService.getTeachers(pageable, search, department);

        model.addAttribute("teachers", teacherPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", teacherPage.getTotalPages());
        model.addAttribute("search", search);
        model.addAttribute("department", department);
        model.addAttribute("size", size);

        return "teacher/list";
    }

    @GetMapping("/{id}")
    public String viewTeacherProfile(@PathVariable("id") Long id, Model model) {
        TeacherProfileDto teacherProfile = teacherService.getTeacherProfileById(id);
        model.addAttribute("teacher", teacherProfile);
        return "teacher/teacher-profile";
    }
}
