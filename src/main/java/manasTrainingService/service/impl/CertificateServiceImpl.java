package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.repositories.CertificateRepository;
import manasTrainingService.service.CertificateService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
@RequiredArgsConstructor
public class CertificateServiceImpl implements CertificateService {

    private final CertificateRepository certificateRepository;

    @Override
    public long getTotalCertificates() {
        return certificateRepository.count();
    }

    @Override
    public long getCertificatesIssuedThisMonth(LocalDate startDate, LocalDate endDate) {
        return certificateRepository.countByIssueDateBetween(startDate, endDate);
    }
}
