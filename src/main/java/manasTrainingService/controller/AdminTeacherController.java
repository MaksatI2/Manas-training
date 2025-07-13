package manasTrainingService.controller;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.profile.TeacherProfileDto;
import manasTrainingService.dto.teacher.CourseTeacherDTO;
import manasTrainingService.entity.Course;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.course.CourseTeacherService;
import manasTrainingService.service.user.TeacherService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/teachers")
@RequiredArgsConstructor
public class AdminTeacherController {

    private final CourseService courseService;
    private final CourseTeacherService courseTeacherService;
    private final TeacherService teacherService;

    @GetMapping("/{teacherId}/manage-courses")
    public String showManageCoursesForm(@PathVariable Integer teacherId, Model model) {
        TeacherProfileDto teacher = teacherService.getTeacherProfileById(teacherId.longValue());
        List<CourseDto> allCourses = courseService.getAllCourses();
        List<CourseTeacherDTO> assignedCourses = courseTeacherService.getCoursesByTeacherId(teacherId);

        model.addAttribute("teacher", teacher);
        model.addAttribute("allCourses", allCourses);

        model.addAttribute("assignedCourses", assignedCourses.stream()
                .map(CourseTeacherDTO::getCourseId)
                .collect(Collectors.toSet()));
        return "admin/manage-courses";
    }

    @PostMapping("/{teacherId}/manage-courses")
    public String updateTeacherCourses(@PathVariable Integer teacherId,
                                       @RequestParam(required = false, name = "courseIds") List<Integer> courseIds,
                                       RedirectAttributes redirectAttributes) {
        courseTeacherService.updateTeacherCourses(teacherId, courseIds != null ? courseIds : Collections.emptyList());
        redirectAttributes.addFlashAttribute("successMessage", "Курсы преподавателя успешно обновлены!");
        return "redirect:/admin/teachers/" + teacherId + "/manage-courses";
    }
}
