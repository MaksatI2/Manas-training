package manasTrainingService.controller;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import manasTrainingService.config.CustomUserDetails;
import manasTrainingService.dto.certificate.CertificateViewDto;
import manasTrainingService.dto.certificate.StudentCertificateDetailDto;
import manasTrainingService.entity.Certificate;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.certificate.CertificateService;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpHeaders;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Locale;

@Controller
@RequestMapping("/student/certificates")
@RequiredArgsConstructor
public class StudentCertificateController {

    private final CertificateService cas;
    private final EnrollmentService enrollmentService;
    private final MessageSource messageSource;

    @GetMapping
    public String list(Model model, @AuthenticationPrincipal CustomUserDetails user) {
        Integer studentId = user.getUser().getId();
        List<StudentCertificateDetailDto> certs = cas.findAllDetailsByStudentId(studentId);
        model.addAttribute("certificates", certs);
        return "student/certificates";
    }


    @GetMapping("/{id}")
    public String viewOwnCertificate(@PathVariable Integer id,
                                     @AuthenticationPrincipal CustomUserDetails user,
                                     Model model) {
        Certificate cert = cas.getCertificateWithModules(id);
        if (!cert.getStudent().getId().equals(user.getUser().getId())) {
            Locale locale = LocaleContextHolder.getLocale();
            throw new AccessDeniedException(
                    messageSource.getMessage("certificate.not.yours", null, locale)
            );
        }
        model.addAttribute("certificate", cert);

        CourseEnrollment en = enrollmentService
                .findByStudentAndInstance(user.getUser().getId(), cert.getCourseInstance().getId())
                .orElse(null);
        model.addAttribute("enrollment", en);

        return "admin/viewCertificate";
    }

}
