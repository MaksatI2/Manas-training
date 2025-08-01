package manasTrainingService;

import freemarker.cache.StringTemplateLoader;
import freemarker.template.Configuration;
import manasTrainingService.service.certificate.CertificateService;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.*;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import static org.mockito.Mockito.*;

class CertificatePdfServiceImplTest {

    @Mock FreeMarkerConfigurer freemarkerConfigurer;
    @Mock CertificateService certificateService;
    @InjectMocks

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

}
