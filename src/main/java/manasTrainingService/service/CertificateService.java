package manasTrainingService.service;

import java.time.LocalDate;

public interface CertificateService {
    long getTotalCertificates();
    long getCertificatesIssuedThisMonth(LocalDate startDate, LocalDate endDate);
}
