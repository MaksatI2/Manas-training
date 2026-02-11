package manasTrainingService.controller;

import lombok.RequiredArgsConstructor;
import manasTrainingService.config.CustomUserDetails;
import manasTrainingService.dto.certificate.CertificateShareDto;
import manasTrainingService.dto.certificate.StudentCertificateDetailDto;
import manasTrainingService.entity.Certificate;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.certificate.CertificateService;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
            throw new NoAccessException(
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

    @PostMapping("/{id}/public")
        @ResponseBody
        public ResponseEntity<CertificateShareDto> setPublic(
        @PathVariable Integer id,
        @AuthenticationPrincipal CustomUserDetails user,
        @RequestParam boolean enabled
        ) {
        Integer studentId = user.getUser().getId();
        CertificateShareDto dto = cas.setPublicAccess(id, studentId, enabled);
        return ResponseEntity.ok(dto);
        }

}
