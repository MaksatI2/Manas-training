package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.CourseOption;
import manasTrainingService.dto.application.*;
import manasTrainingService.exceptions.nsee.BadRequestException;
import manasTrainingService.service.CourseApplicationService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.user.OrganizationService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@RequestMapping("/applications")
public class CourseApplicationController {

    private final CourseApplicationService applicationService;
    private final CourseService courseService;
    private final OrganizationService organizationService;
    private final CourseInstanceService courseInstanceService;

    @GetMapping("/organization")
    @PreAuthorize("hasRole('organization')")
    public String listApplications(Model model, Principal principal) {
        List<CourseApplicationViewDto> apps = applicationService
                .getApplicationsForOrganization(principal.getName());
        model.addAttribute("applications", apps);
        return "organization/organization_applications_list";
    }

    @GetMapping("/organization/create")
    @PreAuthorize("hasRole('organization')")
    public String showCreateForm(Model model, Principal principal) {
        List<CourseDto> courses = courseService
                .getAvailableCoursesForOrganization(
                        organizationService.getAuthorizedUserOrganizationByEmail(principal.getName()).getUser()
                );
        List<EmployeeShortDto> employees = organizationService.getMyEmployees(principal.getName());

        model.addAttribute("courses", courses);
        model.addAttribute("employees", employees);
        model.addAttribute("application", new CourseApplicationCreateDto());
        return "organization/organization_applications_create";
    }

    @PostMapping("/organization")
    @PreAuthorize("hasRole('organization')")
    public String createApplication(@ModelAttribute("application") @Valid CourseApplicationCreateDto dto,
                                    BindingResult bindingResult, Model model, Principal principal) {
        if (bindingResult.hasErrors()) {
            List<CourseDto> courses = courseService
                    .getAvailableCoursesForOrganization(organizationService
                            .getAuthorizedUserOrganizationByEmail(principal.getName()).getUser());
            List<EmployeeShortDto> employees = organizationService.getMyEmployees(principal.getName());
            List<EmployeeShortDto> teachers = organizationService.getAllTeachersShortDto();

            model.addAttribute("courses", courses);
            model.addAttribute("employees", employees);
            model.addAttribute("teachers", teachers);
            model.addAttribute("application", dto);
            model.addAttribute("errors", bindingResult);

            return "organization/organization_applications_create";
        }

        applicationService.createApplicationForOrganization(dto, principal.getName());
        return "redirect:/applications/organization?success";
    }

    @GetMapping("/organization/{id}")
    @PreAuthorize("hasRole('organization')")
    public String viewApplicationDetails(@PathVariable Integer id, Model model, Principal principal) {
        CourseApplicationViewDto dto = applicationService.getApplicationDetails(id, principal.getName());
        List<ApplicationCommentDto> comments = applicationService.getCommentsForApplication(id);
        model.addAttribute("application", dto);
        model.addAttribute("comments", comments);
        return "organization/organization_applications_detail";
    }

    @GetMapping("/admin")
    @PreAuthorize("hasRole('admin')")
    public String adminApplicationList(Model model) {
        List<CourseApplicationViewDto> apps = applicationService.getAllApplicationsForAdmin();
        model.addAttribute("applications", apps);
        return "admin/admin_applications_list";
    }

    @GetMapping("/admin/{id}")
    @PreAuthorize("hasRole('admin')")
    public String adminApplicationDetail(@PathVariable Integer id, Model model) {
        CourseApplicationViewDto dto = applicationService.getApplicationDetailsForAdmin(id);
        List<ApplicationCommentDto> comments = applicationService.getCommentsForApplication(id);
        model.addAttribute("application", dto);
        model.addAttribute("comments", comments);
        model.addAttribute("statusUpdateDto", new ApplicationStatusUpdateDto());
        return "admin/admin_applications_detail";
    }

    @PostMapping("/admin/{id}/status")
    @PreAuthorize("hasRole('admin')")
    public String updateStatus(@PathVariable Integer id,
                               @ModelAttribute ApplicationStatusUpdateDto dto,
                               Principal principal,
                               RedirectAttributes redirectAttributes,
                               Model model) {
        try {
            applicationService.updateApplicationStatus(id, dto, principal.getName());
            redirectAttributes.addFlashAttribute("successMessage", "Статус заявки успешно обновлён.");
        } catch (BadRequestException ex) {
            CourseApplicationViewDto app = applicationService.getApplicationDetailsForAdmin(id);
            List<ApplicationCommentDto> comments = applicationService.getCommentsForApplication(id);

            model.addAttribute("application", app);
            model.addAttribute("comments", comments);
            model.addAttribute("statusUpdateDto", dto);
            model.addAttribute("errorMessage", ex.getMessage());
            return "admin/admin_applications_detail";
        }

        return "redirect:/applications/admin/" + id;
    }

    @PostMapping("/admin/{id}/comment")
    @PreAuthorize("hasRole('admin')")
    public String addComment(@PathVariable Integer id, @RequestParam String comment, Principal principal) {
        applicationService.addCommentToApplication(id, comment, principal.getName());
        return "redirect:/applications/admin/" + id + "?commentAdded";
    }

    @GetMapping("/organization/calendar")
    @PreAuthorize("hasRole('organization')")
    public String showCourseInstanceCalendarForOrg(Model model, Principal principal) {
        List<CourseInstanceCalendarDTO> calendarItems =
                courseInstanceService.getAllInstancesForCalendar();

        model.addAttribute("calendarItems", calendarItems);
        model.addAttribute("userRole", "organization");
        List<CourseOption> courseOptions = courseService.getAvailableCourseOptionsForCalendar();
        model.addAttribute("courseOptions", courseOptions);

        return "organization/organization_course_instances_calendar";
    }

    @GetMapping("/student/applications")
    @PreAuthorize("hasRole('STUDENT')")
    public String viewStudentApplications(Model model, Principal principal) {
        List<CourseApplicationViewDto> applications = applicationService
                .getAllApplicationsByStudent(principal.getName());

        model.addAttribute("applications", applications);
        return "student/student_applications_list";
    }

    @GetMapping("/organization/{id}/edit")
    @PreAuthorize("hasRole('organization')")
    public String showEditOrganizationForm(@PathVariable Integer id,
                                           Principal principal,
                                           Model model) {
        CourseApplicationViewDto application = applicationService.getApplicationDetails(id, principal.getName());

        CourseApplicationCreateDto dto = new CourseApplicationCreateDto();
        dto.setCourseId(application.getCourseId());
        dto.setPreferredStartDate(application.getPreferredStartDate());
        dto.setPreferredEndDate(application.getPreferredEndDate());
        dto.setOutgoingCode(application.getOutgoingCode());

        if (application.getPreferredTeacher() != null) {
            dto.setPreferredTeacherId(application.getPreferredTeacher().getId());
        }

        dto.setEmployeeIds(
                application.getEmployees().stream()
                        .map(EmployeeShortDto::getId)
                        .collect(Collectors.toList())
        );

        model.addAttribute("application", dto);
        model.addAttribute("id", id);
        model.addAttribute("courses", courseService
                .getAvailableCoursesForOrganization(
                        organizationService.getAuthorizedUserOrganizationByEmail(principal.getName()).getUser()));
        model.addAttribute("employees", organizationService.getMyEmployees(principal.getName()));
        model.addAttribute("teachers", organizationService.getAllTeachersShortDto());

        return "organization/organization_applications_edit";
    }

    @PostMapping("/organization/{id}/edit")
    @PreAuthorize("hasRole('organization')")
    public String updateOrganizationApplication(@PathVariable Integer id,
                                                @ModelAttribute("application") @Valid CourseApplicationCreateDto dto,
                                                BindingResult bindingResult,
                                                Principal principal,
                                                Model model,
                                                RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("courses", courseService
                    .getAvailableCoursesForOrganization(
                            organizationService.getAuthorizedUserOrganizationByEmail(principal.getName()).getUser()));
            model.addAttribute("employees", organizationService.getMyEmployees(principal.getName()));
            model.addAttribute("teachers", organizationService.getAllTeachersShortDto());
            model.addAttribute("errors", bindingResult);
            return "organization/organization_applications_edit";
        }

        applicationService.updateApplicationForOrganization(id, dto, principal.getName());

        redirectAttributes.addFlashAttribute("successMessage", "Заявка успешно обновлена!");
        return "redirect:/applications/organization";
    }


    @GetMapping("/student/applications/{id}")
    @PreAuthorize("hasRole('STUDENT')")
    public String viewStudentApplicationDetails(@PathVariable Integer id,
                                                Principal principal,
                                                Model model) {
        CourseApplicationViewDto application = applicationService
                .getApplicationDetails(id, principal.getName());
        List<ApplicationCommentDto> comments = applicationService.getCommentsForApplication(id);

        model.addAttribute("application", application);
        model.addAttribute("comments", comments);
        return "student/student_applications_detail";
    }

    @GetMapping("/student/applications/create")
    @PreAuthorize("hasRole('STUDENT')")
    public String showStudentApplicationForm(Model model) {
        model.addAttribute("application", new StudentCourseApplicationCreateDto());
        model.addAttribute("courses", courseService.getAllCourses());
        model.addAttribute("teachers", organizationService.getAllTeachersShortDto());
        return "student/student_applications_create";
    }

    @PostMapping("/student/applications")
    @PreAuthorize("hasRole('STUDENT')")
    public String createStudentApplication(@ModelAttribute("application") @Valid StudentCourseApplicationCreateDto dto,
                                           BindingResult bindingResult,
                                           Principal principal,
                                           Model model,
                                           RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("application", dto);
            model.addAttribute("courses", courseService.getAllCourses());
            model.addAttribute("teachers", organizationService.getAllTeachersShortDto());
            model.addAttribute("errors", bindingResult);
            return "student/student_applications_create";
        }

        applicationService.createApplicationFromStudent(dto, principal.getName());
        redirectAttributes.addFlashAttribute("successMessage", "Заявка успешно отправлена!");
        return "redirect:/applications/student/applications";
    }

    @GetMapping("/student/applications/{id}/edit")
    @PreAuthorize("hasRole('STUDENT')")
    public String showEditStudentForm(@PathVariable Integer id,
                                      Principal principal,
                                      Model model) {
        CourseApplicationViewDto application = applicationService.getApplicationDetails(id, principal.getName());
        StudentCourseApplicationCreateDto dto = new StudentCourseApplicationCreateDto();

        dto.setCourseId(application.getCourseId());
        dto.setPreferredStartDate(application.getPreferredStartDate());
        dto.setPreferredEndDate(application.getPreferredEndDate());
        if (application.getPreferredTeacher() != null) {
            dto.setPreferredTeacherId(application.getPreferredTeacher().getId());
        }

        model.addAttribute("application", dto);
        model.addAttribute("courses", courseService.getAllCourses());
        model.addAttribute("teachers", organizationService.getAllTeachersShortDto());
        return "student/student_applications_edit";
    }

    @PostMapping("/student/applications/{id}/edit")
    @PreAuthorize("hasRole('STUDENT')")
    public String updateStudentApplication(@PathVariable Integer id,
                                           @ModelAttribute("application") @Valid StudentCourseApplicationCreateDto dto,
                                           BindingResult bindingResult,
                                           Principal principal,
                                           RedirectAttributes redirectAttributes,
                                           Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("courses", courseService.getAllCourses());
            model.addAttribute("teachers", organizationService.getAllTeachersShortDto());
            model.addAttribute("errors", bindingResult);

            return "student/student_applications_edit";
        }

        applicationService.updateApplicationFromStudent(id, dto, principal.getName());
        redirectAttributes.addAttribute("successMessage", "Заявка успешно обновлена!");
        return "redirect:/applications/student/applications";
    }

    @PostMapping("/student/applications/{id}/delete")
    @PreAuthorize("hasRole('STUDENT')")
    public String deleteStudentApplication(@PathVariable Integer id,
                                           Principal principal,
                                           RedirectAttributes redirectAttributes) {
        applicationService.deleteApplicationById(id, principal.getName());
        redirectAttributes.addFlashAttribute("successMessage", "Заявка удалена.");
        return "redirect:/applications/student/applications";
    }

    @PostMapping("/organization/{id}/delete")
    @PreAuthorize("hasRole('organization')")
    public String deleteOrganizationApplication(@PathVariable Integer id,
                                                Principal principal,
                                                RedirectAttributes redirectAttributes) {
        applicationService.deleteApplicationById(id, principal.getName());
        redirectAttributes.addFlashAttribute("successMessage", "Заявка удалена.");
        return "redirect:/applications/organization";
    }


}
