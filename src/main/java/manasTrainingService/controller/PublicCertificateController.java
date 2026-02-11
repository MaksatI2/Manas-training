package manasTrainingService.controller;

import lombok.RequiredArgsConstructor;
import manasTrainingService.entity.Certificate;
import manasTrainingService.service.certificate.CertificateService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/certificates/public")
@RequiredArgsConstructor
public class PublicCertificateController {

    private final CertificateService certificateService;

    @GetMapping("/{token}")
    public String viewPublic(@PathVariable String token, Model model) {
        Certificate cert = certificateService.getPublicCertificateOrThrow(token);
        model.addAttribute("certificate", cert);
        return "public/certificate-view";
    }
}
