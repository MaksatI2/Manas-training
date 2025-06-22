package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.organization.AssignCourseDto;
import manasTrainingService.dto.organization.CreateStudentByOrganizationDto;
import manasTrainingService.dto.organization.StudentCourseInfoDto;
import manasTrainingService.dto.organization.StudentEditByOrganizationDto;
import manasTrainingService.entity.User;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.user.OrganizationService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/organization/students")
@RequiredArgsConstructor
public class OrganizationStudentController {

    private final OrganizationService organizationService;
    private final UserService userService;
    private final CourseService courseService;

    @GetMapping
    public String listStudentsWithCourses(Model model) {
        User orgUser = userService.getAuthorizedUser();
        List<StudentCourseInfoDto> students = organizationService.getStudentsCourseInfoForOrganization(orgUser);
        model.addAttribute("students", students);
        return "organization/students/list";
    }

    @GetMapping("/add")
    public String showAddStudentForm(Model model) {
        model.addAttribute("studentDto", new CreateStudentByOrganizationDto());
        model.addAttribute("validationErrors", Map.of());
        return "organization/students/add";
    }

    @PostMapping("/add")
    public String addStudent(
            @Valid @ModelAttribute("studentDto") CreateStudentByOrganizationDto dto,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("studentDto", dto);
            model.addAttribute("validationErrors", getFieldErrors(bindingResult));
            return "organization/students/add";
        }

        try {
            organizationService.createStudentByOrganization(dto, userService.getAuthorizedUser());
            redirectAttributes.addFlashAttribute("successMessage", "Студент успешно добавлен");
            return "redirect:/organization/students";
        } catch (Exception e) {
            model.addAttribute("studentDto", dto);
            model.addAttribute("errorMessage", e.getMessage());
            return "organization/students/add";
        }
    }

    private Map<String, String> getFieldErrors(BindingResult result) {
        return result.getFieldErrors().stream()
                .collect(Collectors.toMap(
                        FieldError::getField,
                        FieldError::getDefaultMessage,
                        (existing, replacement) -> existing
                ));
    }

    @GetMapping("/{studentId}/edit")
    public String editStudentForm(@PathVariable Integer studentId, Model model) {
        User student = userService.getUserById(studentId.intValue());
        StudentEditByOrganizationDto dto = StudentEditByOrganizationDto.builder().studentId(Long.valueOf(student.getId())).name(student.getName()).lastName(student.getLastName()).email(student.getEmail()).phone(student.getPhone()).build();
        model.addAttribute("student", dto);
        return "organization/students/edit";
    }

    @PostMapping("/{studentId}/edit")
    public String updateStudent(@PathVariable Integer studentId, @Valid @ModelAttribute("student") StudentEditByOrganizationDto dto, BindingResult bindingResult, RedirectAttributes redirectAttributes, Model model) {
        if (bindingResult.hasErrors()) {
            return "organization/students/edit";
        }

        try {
            organizationService.editStudentProfileByOrganization(dto);
            redirectAttributes.addFlashAttribute("successMessage", "Данные студента обновлены");
            return "redirect:/organization/students";
        } catch (Exception e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "organization/students/edit";
        }
    }

    @PostMapping("/{studentId}/delete")
    public String deleteStudent(@PathVariable Integer studentId, RedirectAttributes redirectAttributes) {
        try {
            organizationService.deleteStudentFromOrganization(studentId, userService.getAuthorizedUser());
            redirectAttributes.addFlashAttribute("successMessage", "Студент удалён из организации");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/organization/students";
    }

    @GetMapping("/{studentId}/assign")
    public String showAssignCourseForm(@PathVariable Long studentId, Model model) {
        AssignCourseDto dto = AssignCourseDto.builder().studentId(studentId).build();
        model.addAttribute("assignDto", dto);

        List<CourseDto> availableCourses = courseService.getAvailableCoursesForOrganization(userService.getAuthorizedUser());
        System.out.println("Available courses: " + availableCourses.size());

        model.addAttribute("courses", availableCourses);
        return "organization/students/assign-course";
    }


    @PostMapping("/{studentId}/assign")
    public String assignCourse(@PathVariable Long studentId, @Valid @ModelAttribute("assignDto") AssignCourseDto dto, BindingResult bindingResult, RedirectAttributes redirectAttributes, Model model) {
        if (bindingResult.hasErrors()) {
            return "organization/students/assign-course";
        }

        try {
            dto.setStudentId(studentId);
            organizationService.assignStudentToCourse(dto, userService.getAuthorizedUser());
            redirectAttributes.addFlashAttribute("successMessage", "Курс успешно назначен");
            return "redirect:/organization/students";
        } catch (Exception e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "organization/students/assign-course";
        }
    }

    @PostMapping("/enrollment/{enrollmentId}/remove")
    public String removeFromCourse(@PathVariable Integer enrollmentId, RedirectAttributes redirectAttributes) {
        try {
            organizationService.removeStudentFromCourse(enrollmentId, userService.getAuthorizedUser());
            redirectAttributes.addFlashAttribute("successMessage", "Студент удалён с курса");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/organization/students";
    }

    @GetMapping("/unassigned")
    public String showUnassignedStudents(Model model) {
        List<User> unassignedStudents = userService.getStudentsWithoutOrganization();
        model.addAttribute("unassigned", unassignedStudents);
        return "organization/students/unassigned";
    }

    @PostMapping("/unassigned/{studentId}/attach")
    public String attachStudentToOrganization(@PathVariable Integer studentId, RedirectAttributes redirectAttributes) {
        try {
            organizationService.attachStudentToOrganization(studentId, userService.getAuthorizedUser());
            redirectAttributes.addFlashAttribute("successMessage", "Студент добавлен в организацию");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/organization/students";
    }


}
