package manasTrainingService.controller;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseApplicationEmployeeDTO;
import manasTrainingService.dto.instance.CourseEnrollmentDTO;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.instance.ParticipantFormDTO;
import manasTrainingService.entity.Status;
import manasTrainingService.service.course.CourseApplicationEmployeeService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.EnrollmentService;
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
@RequestMapping("/admin/course-instances/{id}/participants")
@RequiredArgsConstructor
public class CourseInstanceParticipantsController {

    private final CourseInstanceService courseInstanceService;
    private final EnrollmentService enrollmentService;
    private final CourseApplicationEmployeeService applicationEmployeeService;

    @GetMapping
    public String showParticipants(@PathVariable Integer id, Model model) {
        CourseInstanceDTO courseInstance = courseInstanceService.getCourseInstanceById(id);
        List<CourseEnrollmentDTO> enrollments = enrollmentService.getEnrollmentsByCourseInstanceId(id);
        List<CourseApplicationEmployeeDTO> pendingEmployees = applicationEmployeeService.getPendingEmployeesForCourseInstance(courseInstance.getCourseId());

        model.addAttribute("courseInstance", courseInstance);
        model.addAttribute("enrollments", enrollments);
        model.addAttribute("pendingEmployees", pendingEmployees);
        model.addAttribute("participantForm", new ParticipantFormDTO());
        return "admin/course-instance-participants";
    }

    @PostMapping("/add")
    public String addParticipants(@PathVariable Integer id, @Valid @ModelAttribute("participantForm") ParticipantFormDTO participantForm, BindingResult result, Model model) {
        if (result.hasErrors() || participantForm.getPendingEmployeeIds().isEmpty()) {
            CourseInstanceDTO courseInstance = courseInstanceService.getCourseInstanceById(id);
            List<CourseEnrollmentDTO> enrollments = enrollmentService.getEnrollmentsByCourseInstanceId(id);
            List<CourseApplicationEmployeeDTO> pendingEmployees = applicationEmployeeService.getPendingEmployeesForCourseInstance(courseInstance.getCourseId());

            model.addAttribute("courseInstance", courseInstance);
            model.addAttribute("enrollments", enrollments);
            model.addAttribute("pendingEmployees", pendingEmployees);
            model.addAttribute("errorMessage", "Выберите хотя бы одного участника");
            return "admin/course-instance-participants";
        }

        enrollmentService.enrollEmployees(id, participantForm.getPendingEmployeeIds());
        return "redirect:/admin/course-instances/" + id + "/participants";
    }

    @PostMapping("/toggle-status/{enrollmentId}")
    public String toggleStatus(@PathVariable Integer id,
                               @PathVariable Integer enrollmentId,
                               RedirectAttributes redirectAttributes) {
        CourseEnrollmentDTO enrollment = enrollmentService.getEnrollmentsByCourseInstanceId(id).stream()
                .filter(e -> e.getId().equals(enrollmentId))
                .findFirst()
                .orElseThrow(() -> new EntityNotFoundException("Запись на курс не была найдена"));

        Status newStatus = (enrollment.getStatus() == Status.ENROLLED)
                ? Status.DROPPED
                : Status.ENROLLED;

        enrollmentService.changeEnrollmentStatus(enrollmentId, newStatus);

        redirectAttributes.addFlashAttribute("successMessage", "Статус ученика изменен");
        return "redirect:/admin/course-instances/" + id + "/participants";
    }

}