package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.config.CustomUserDetails;
import manasTrainingService.dto.certificate.CreateCertificateDto;
import manasTrainingService.dto.certificate.EditCertificateDto;
import manasTrainingService.entity.Certificate;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.certificate.CertificateService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;


@Controller
@RequestMapping("/admin/certificate")
@RequiredArgsConstructor
public class AdminCertificateController {

    private final CertificateService svc;
    private final EnrollmentService enrollmentService;

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model
    ) {
        model.addAttribute("studentsPage", svc.listStudentsWithCertificates(page, size));
        return "admin/certificate";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam Integer studentId, Model model) {
        model.addAttribute("data", svc.getStudentCertificates(studentId));
        return "admin/studentCertificates";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam Integer certId,
                         @RequestParam Integer studentId) {
        svc.deleteCertificate(certId);
        return "redirect:/admin/certificate/detail?studentId=" + studentId;
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model) {
        model.addAttribute("certificateForm", svc.prepareEdit(id));
        return "admin/editCertificate";
    }

    @PostMapping("/edit")
    public String editSubmit(
            @Valid @ModelAttribute("certificateForm") EditCertificateDto form,
            BindingResult br
    ) {
        if (br.hasErrors()) {
            return "admin/editCertificate";
        }
        svc.saveEditedCertificate(form);
        return "redirect:/admin/certificate/detail?studentId=" + form.getStudentId();
    }

    @GetMapping("/create")
    public String createForm(
            @RequestParam Integer studentId,
            @RequestParam Integer courseInstanceId,
            Model model
    ) {
        var dto = new CreateCertificateDto(studentId, courseInstanceId, null, null);
        model.addAttribute("certificateForm", dto);
        return "admin/createCertificate";
    }

    @PostMapping("/create")
    public String createSubmit(
            @Valid @ModelAttribute("certificateForm") CreateCertificateDto form,
            BindingResult br,
            @AuthenticationPrincipal CustomUserDetails user
    ) {
        if (br.hasErrors()) {
            return "admin/createCertificate";
        }
        svc.createCertificate(form, user.getUser().getId());
        return "redirect:/admin/certificate/detail?studentId=" + form.getStudentId();
    }

    @GetMapping("/view/{id}")
    public String viewCertificate(@PathVariable Integer id, Model model) {
        Certificate cert = svc.getCertificateWithModules(id);
        model.addAttribute("certificate", cert);

        CourseEnrollment en = enrollmentService
                .findByStudentAndInstance(
                        cert.getStudent().getId(),
                        cert.getCourseInstance().getId()
                )
                .orElse(null);

        model.addAttribute("enrollment", en);
        return "admin/viewCertificate";
    }

}
