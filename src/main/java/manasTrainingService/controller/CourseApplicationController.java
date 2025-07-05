package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseDto;
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
        return "organization/organization_course_instances_calendar";
    }


}
