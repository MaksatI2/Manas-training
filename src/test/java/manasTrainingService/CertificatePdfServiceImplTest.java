package manasTrainingService;

import freemarker.cache.StringTemplateLoader;
import freemarker.template.Configuration;
import manasTrainingService.entity.Certificate;
import manasTrainingService.service.certificate.CertificateService;
import manasTrainingService.service.impl.certificate.CertificatePdfServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.mockito.*;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import java.nio.file.Path;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

class CertificatePdfServiceImplTest {

    @Mock FreeMarkerConfigurer freemarkerConfigurer;
    @Mock CertificateService certificateService;
    @InjectMocks
    CertificatePdfServiceImpl pdfService;

    private Configuration fmCfg;

    @BeforeEach
    void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);

        fmCfg = new Configuration(Configuration.VERSION_2_3_31);
        StringTemplateLoader loader = new StringTemplateLoader();
        loader.putTemplate("admin/viewCertificatePdf.ftlh",
                "<html><body>№${certificate.id}</body></html>");
        fmCfg.setTemplateLoader(loader);

        when(freemarkerConfigurer.getConfiguration()).thenReturn(fmCfg);
    }

    @Test
    void generateCertificatePdf_notFound_throws() {
        when(certificateService.getCertificate(5))
                .thenThrow(new RuntimeException("not found"));

        assertThatThrownBy(() -> pdfService.generateCertificatePdf(5))
                .hasMessageContaining("not found");
    }

    @Test
    void generateCertificatePdf_success_producesNonEmptyPdf(@TempDir Path temp) throws Exception {
        Certificate cert = new Certificate();
        cert.setId(77);
        cert.setIssueDate(LocalDate.now());
        cert.setExpiryDate(LocalDate.now().plusDays(1));
        when(certificateService.getCertificate(77)).thenReturn(cert);

        byte[] pdf = pdfService.generateCertificatePdf(77);
        assertThat(pdf).isNotNull().isNotEmpty();

        Path out = temp.resolve("out.pdf");
        java.nio.file.Files.write(out, pdf);
        String header = new String(java.nio.file.Files.readAllBytes(out), 0, 5);
        assertThat(header).isEqualTo("%PDF-");
    }
}
