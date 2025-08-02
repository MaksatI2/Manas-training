package manasTrainingService.service.certificate;

import manasTrainingService.dto.certificate.*;
import manasTrainingService.entity.Certificate;
import org.springframework.data.domain.Page;

import java.time.LocalDate;
import java.util.List;

public interface CertificateService {
    List<CourseCertificateStatusDto> getStatuses(Integer studentId);

    List<CertificateViewDto> findAllByStudentId(Integer studentId);

    CertificateViewDto findOneByIdAndStudentId(Integer certId, Integer studentId);

    Page<StudentDto> listStudentsWithCertificates(int page, int size);

    StudentCertificatesDto getStudentCertificates(Integer studentId);

    void deleteCertificate(Integer certId);

    EditCertificateDto prepareEdit(Integer certId);

    void saveEditedCertificate(EditCertificateDto dto);

    void createCertificate(CreateCertificateDto dto, Integer issuerUserId);

    CertificateViewDto getCertificateView(Integer certId);

    Certificate getCertificate(Integer certId);

    List<Certificate> getCertificatesByStudentAndCourseInstance(Integer studentId, Integer courseInstanceId);

    Certificate getCertificateWithModules(Integer certId);

    long getTotalCertificates();

    long getCertificatesIssuedThisMonth(LocalDate startDate, LocalDate endDate);

    List<StudentCertificateDetailDto> findAllDetailsByStudentId(Integer studentId);
}
