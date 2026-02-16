package manasTrainingService.service.certificate;

public interface CertificatePdfService {
    byte[] generateCertificatePdf(Integer certId) throws Exception;
}
