package manasTrainingService.service.impl.certificate;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.certificate.*;
import manasTrainingService.entity.Certificate;
import manasTrainingService.entity.User;
import manasTrainingService.repositories.CertificateRepository;
import manasTrainingService.repositories.course.CourseEnrollmentRepository;
import manasTrainingService.repositories.course.CourseInstanceRepository;
import manasTrainingService.service.certificate.CertificateService;
import manasTrainingService.service.user.UserService;
import manasTrainingService.util.DateUtil;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor(onConstructor_ = @Lazy)
public class CertificateServiceImpl implements CertificateService {
    private final CourseEnrollmentRepository enrollRepo;
    private final CertificateRepository certRepo;
    private final UserService userService;
    private final CourseInstanceRepository ciRepo;

    @Override
    public List<CourseCertificateStatusDto> getStatuses(Integer studentId) {
        return enrollRepo
                .findByStudentIdAndCompletionDateIsNotNull(studentId).stream()
                .map(en -> {
                    Integer ciId = en.getCourseInstance().getId();
                    List<Certificate> certs = certRepo.findByStudentIdAndCourseInstanceId(studentId, ciId);
                    boolean hasCert = !certs.isEmpty();
                    List<Integer> ids = certs.stream().map(Certificate::getId).toList();
                    return CourseCertificateStatusDto.builder()
                            .courseTitle(en.getCourseInstance().getCourse().getTitle())
                            .certificateCreated(hasCert)
                            .certificateId(hasCert ? ids : Collections.emptyList())
                            .courseInstanceId(ciId)
                            .build();
                })
                .toList();
    }

    @Override
    public List<CertificateViewDto> findAllByStudentId(Integer studentId) {
        return certRepo.findByStudentId(studentId).stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    public CertificateViewDto findOneByIdAndStudentId(Integer certId, Integer studentId) {
        Certificate cert = certRepo.findById(certId)
                .filter(c -> c.getStudent().getId().equals(studentId))
                .orElseThrow(() -> new EntityNotFoundException("Сертификат не найден"));
        return toDto(cert);
    }

    private CertificateViewDto toDto(Certificate c) {
        return CertificateViewDto.builder()
                .id(c.getId())
                .certificateNumber(c.getCertificateNumber())
                .courseTitle(c.getCourseInstance().getCourse().getTitle())
                .issueDate(DateUtil.format(c.getIssueDate()))
                .expiryDate(DateUtil.format(c.getExpiryDate()))
                .originalIssueDate(c.getIssueDate())
                .originalExpiryDate(c.getExpiryDate())
                .viewUrl("/student/certificates/" + c.getId())
                .downloadUrl("/student/certificates/" + c.getId() + "/pdf")
                .build();
    }

    @Override
    public Page<StudentDto> listStudentsWithCertificates(int page, int size) {
        return enrollRepo
                .findStudentsWithCompletedCourses(PageRequest.of(page, size))
                .map(user -> {
                    int completed = enrollRepo
                            .findByStudentIdAndCompletionDateIsNotNull(user.getId())
                            .size();
                    return new StudentDto(
                            user.getId(),
                            user.getName(), user.getLastName(), user.getEmail(),
                            completed
                    );
                });
    }

    @Override
    public StudentCertificatesDto getStudentCertificates(Integer studentId) {
        User student = userService.getUserById(studentId);
        List<CourseCertificateStatusDto> statuses = enrollRepo
                .findByStudentIdAndCompletionDateIsNotNull(studentId).stream()
                .map(e -> {
                    var certs = certRepo
                            .findByStudentIdAndCourseInstanceId(studentId, e.getCourseInstance().getId());

                    CourseCertificateStatusDto.CourseCertificateStatusDtoBuilder builder = CourseCertificateStatusDto.builder()
                            .courseTitle(e.getCourseInstance().getCourse().getTitle())
                            .courseInstanceTitle(e.getCourseInstance().getTitle())
                            .courseStartDate(e.getCourseInstance().getStartDate())
                            .courseEndDate(e.getCourseInstance().getEndDate())
                            .certificateCreated(!certs.isEmpty())
                            .certificateId(certs.stream().map(Certificate::getId).toList())
                            .courseInstanceId(e.getCourseInstance().getId());

                    if (!certs.isEmpty()) {
                        Certificate firstCert = certs.get(0);
                        builder.certificateIssueDate(DateUtil.format(firstCert.getIssueDate()))
                                .certificateExpiryDate(DateUtil.format(firstCert.getExpiryDate()))
                                .certificateNumber(firstCert.getCertificateNumber())
                                .mark(firstCert.getMark());
                    }

                    return builder.build();
                })
                .toList();
        return new StudentCertificatesDto(student, statuses);
    }

    @Override
    public void deleteCertificate(Integer certId) {
        certRepo.deleteById(certId);
    }

    @Override
    public EditCertificateDto prepareEdit(Integer certId) {
        var cert = certRepo.findById(certId)
                .orElseThrow(() -> new EntityNotFoundException("Certificate not found"));
        return new EditCertificateDto(
                cert.getId(),
                cert.getStudent().getId(),
                cert.getCertificateNumber(),
                cert.getIssueDate(),
                cert.getExpiryDate(),
                cert.getMark()
        );
    }

    @Override
    public void saveEditedCertificate(EditCertificateDto dto) {
        var cert = certRepo.findById(dto.getId())
                .orElseThrow(() -> new EntityNotFoundException("Certificate not found"));
        cert.setCertificateNumber(dto.getCertificateNumber());
        cert.setIssueDate(dto.getIssueDate());
        cert.setExpiryDate(dto.getExpiryDate());
        cert.setMark(dto.getMark());
        certRepo.save(cert);
    }

    @Override
    public void createCertificate(CreateCertificateDto dto, Integer issuerUserId) {
        var ci = ciRepo.findById(dto.getCourseInstanceId())
                .orElseThrow(() -> new EntityNotFoundException("Course instance not found"));
        var issuer = userService.getUserById(issuerUserId);
        Certificate cert = new Certificate();
        cert.setStudent(userService.getUserById(dto.getStudentId()));
        cert.setCourseInstance(ci);
        cert.setIssueDate(LocalDate.now());
        cert.setExpiryDate(dto.getExpiryDate());
        cert.setIssuedBy(issuer);
        cert.setMark(dto.getMark());
        cert.setCertificateNumber(generateNextNumber());
        certRepo.save(cert);
    }

    @Override
    public CertificateViewDto getCertificateView(Integer certId) {
        var cert = certRepo.findById(certId)
                .orElseThrow(() -> new EntityNotFoundException("Certificate not found"));
        return CertificateViewDto.builder()
                .certificate(cert)
                .id(cert.getId())
                .certificateNumber(cert.getCertificateNumber())
                .courseTitle(cert.getCourseInstance().getCourse().getTitle())
                .issueDate(DateUtil.format(cert.getIssueDate()))
                .expiryDate(DateUtil.format(cert.getExpiryDate()))
                .downloadUrl("/admin/certificate/pdf/" + cert.getId())
                .viewUrl("/admin/certificate/view/" + cert.getId())
                .build();
    }

    @Override
    public Certificate getCertificate(Integer certId) {
        return certRepo.findById(certId)
                .orElseThrow(() -> new EntityNotFoundException("Certificate not found"));
    }

    @Override
    public List<Certificate> getCertificatesByStudentAndCourseInstance(Integer studentId, Integer courseInstanceId) {
        return certRepo.findByStudentIdAndCourseInstanceId(studentId, courseInstanceId);
    }

    @Override
    public Certificate getCertificateWithModules(Integer certId) {
        return certRepo.findByIdWithModules(certId)
                .orElseThrow(() -> new EntityNotFoundException("Certificate not found"));
    }

    @Override
    public long getTotalCertificates() {
        return certRepo.count();
    }

    @Override
    public long getCertificatesIssuedThisMonth(LocalDate startDate, LocalDate endDate) {
        return certRepo.countByIssueDateBetween(startDate, endDate);
    }
    @Override
    public List<StudentCertificateDetailDto> findAllDetailsByStudentId(Integer studentId) {
        return certRepo.findByStudentId(studentId).stream()
                .map(this::toDetailDto)
                .toList();
    }

    private String generateNextNumber() {
        Integer max = certRepo.findMaxCertificateNumber();
        return String.valueOf((max == null ? 0 : max) + 1);
    }


    private StudentCertificateDetailDto toDetailDto(Certificate c) {
        return StudentCertificateDetailDto.builder()
                .id(c.getId())
                .certificateNumber(c.getCertificateNumber())
                .courseTitle(c.getCourseInstance().getCourse().getTitle())
                .courseInstanceTitle(c.getCourseInstance().getTitle())
                .courseStartDate(c.getCourseInstance().getStartDate())
                .courseEndDate(c.getCourseInstance().getEndDate())
                .issueDate(DateUtil.format(c.getIssueDate()))
                .expiryDate(DateUtil.format(c.getExpiryDate()))
                .originalIssueDate(c.getIssueDate())
                .originalExpiryDate(c.getExpiryDate())
                .mark(c.getMark())
                .viewUrl("/student/certificates/" + c.getId())
                .downloadUrl("/student/certificates/" + c.getId() + "/pdf")
                .build();
    }
}
