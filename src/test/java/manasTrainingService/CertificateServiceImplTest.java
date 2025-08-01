package manasTrainingService;

import jakarta.persistence.EntityNotFoundException;
import manasTrainingService.dto.certificate.*;
import manasTrainingService.entity.Certificate;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.User;
import manasTrainingService.repositories.CertificateRepository;
import manasTrainingService.repositories.course.CourseEnrollmentRepository;
import manasTrainingService.repositories.course.CourseInstanceRepository;
import manasTrainingService.service.certificate.CertificatePdfService;
import manasTrainingService.service.impl.certificate.CertificateServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CertificateServiceImplTest {

    @Mock CourseEnrollmentRepository enrollRepo;
    @Mock CertificateRepository certRepo;
    @Mock UserService userService;
    @Mock CourseInstanceRepository ciRepo;

    @InjectMocks
    CertificateServiceImpl service;

    private manasTrainingService.entity.CourseEnrollment fakeEnrollment(int ciId, String courseTitle) {
        Course c = new Course();
        c.setTitle(courseTitle);
        CourseInstance ci = new CourseInstance();
        ci.setId(ciId);
        ci.setCourse(c);
        manasTrainingService.entity.CourseEnrollment e = new manasTrainingService.entity.CourseEnrollment();
        e.setCourseInstance(ci);
        e.setCompletionDate(LocalDate.now().atStartOfDay());
        return e;
    }

    @Test
    void getStatuses_whenNoCerts() {
        int studentId = 42;
        // репозиторий возвратил одно завершённое обучение
        when(enrollRepo.findByStudentIdAndCompletionDateIsNotNull(studentId))
                .thenReturn(List.of(fakeEnrollment(7, "Kotlin")));

        // а сертификатов по этому курсу нет
        when(certRepo.findByStudentIdAndCourseInstanceId(studentId, 7))
                .thenReturn(List.of());

        List<CourseCertificateStatusDto> statuses = service.getStatuses(studentId);

        assertThat(statuses).hasSize(1)
                .allSatisfy(s -> {
                    assertThat(s.getCourseTitle()).isEqualTo("Kotlin");
                    assertThat(s.getCertificateId()).isEmpty();
                    assertThat(s.getCourseInstanceId()).isEqualTo(7);
                });
    }

    @Test
    void findAllByStudentId_mapsToDto() {
        Certificate c = new Certificate();
        c.setId(100);
        c.setCertificateNumber("ABC");
        c.setIssueDate(LocalDate.of(2025,1,1));
        c.setExpiryDate(LocalDate.of(2025,12,31));
        CourseInstance ci = new CourseInstance();
        Course course = new Course();
        course.setTitle("Java");
        ci.setCourse(course);
        c.setCourseInstance(ci);
        User u = new User(); u.setId(42);
        c.setStudent(u);

        when(certRepo.findByStudentId(42)).thenReturn(List.of(c));

        List<CertificateViewDto> dtos = service.findAllByStudentId(42);
        assertThat(dtos).hasSize(1);
        CertificateViewDto dto = dtos.get(0);
        assertThat(dto.getId()).isEqualTo(100);
        assertThat(dto.getCertificateNumber()).isEqualTo("ABC");
        assertThat(dto.getCourseTitle()).isEqualTo("Java");
        assertThat(dto.getIssueDate()).isEqualTo(LocalDate.of(2025,1,1));
        assertThat(dto.getExpiryDate()).isEqualTo(LocalDate.of(2025,12,31));
        assertThat(dto.getViewUrl()).endsWith("/student/certificates/100");
        assertThat(dto.getDownloadUrl()).endsWith("/student/certificates/100/pdf");
    }

    @Test
    void findOneByIdAndStudentId_notFoundOrMismatch_throws() {
        when(certRepo.findById(5)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.findOneByIdAndStudentId(5, 10))
                .isInstanceOf(EntityNotFoundException.class);

        Certificate c = new Certificate();
        User other = new User(); other.setId(99);
        c.setStudent(other);
        when(certRepo.findById(6)).thenReturn(Optional.of(c));
        assertThatThrownBy(() -> service.findOneByIdAndStudentId(6, 10))
                .isInstanceOf(EntityNotFoundException.class);
    }

    @Test
    void prepareEdit_and_saveEditedCertificate() {
        Certificate c = new Certificate();
        c.setId(7);
        User stud = new User(); stud.setId(55);
        c.setStudent(stud);
        c.setCertificateNumber("old");
        c.setIssueDate(LocalDate.of(2025,2,2));
        c.setExpiryDate(LocalDate.of(2025,5,5));
        c.setMark(5);

        when(certRepo.findById(7)).thenReturn(Optional.of(c));

        EditCertificateDto dto = service.prepareEdit(7);
        assertThat(dto.getCertificateNumber()).isEqualTo("old");

        dto.setCertificateNumber("new");
        dto.setIssueDate(LocalDate.of(2025,3,3));
        dto.setExpiryDate(LocalDate.of(2025,6,6));
        dto.setMark(4);

        service.saveEditedCertificate(dto);

        ArgumentCaptor<Certificate> cap = ArgumentCaptor.forClass(Certificate.class);
        verify(certRepo).save(cap.capture());

        Certificate saved = cap.getValue();
        assertThat(saved.getCertificateNumber()).isEqualTo("new");
        assertThat(saved.getMark()).isEqualTo(4);
    }

    @Test
    void createCertificate_success_and_generateNextNumber() {
        when(certRepo.findMaxCertificateNumber()).thenReturn(41);
        CourseInstance ci = new CourseInstance(); ci.setId(17);
        when(ciRepo.findById(17)).thenReturn(Optional.of(ci));
        User issuer = new User(); issuer.setId(99);
        User student = new User(); student.setId(123);
        when(userService.getUserById(99)).thenReturn(issuer);
        when(userService.getUserById(123)).thenReturn(student);

        CreateCertificateDto form = new CreateCertificateDto(123,17,null,null);
        form.setExpiryDate(LocalDate.of(2026,1,1));
        form.setMark(5);

        service.createCertificate(form, 99);

        ArgumentCaptor<Certificate> cap = ArgumentCaptor.forClass(Certificate.class);
        verify(certRepo).save(cap.capture());
        Certificate saved = cap.getValue();
        assertThat(saved.getCertificateNumber()).isEqualTo("42");
        assertThat(saved.getStudent().getId()).isEqualTo(123);
        assertThat(saved.getCourseInstance().getId()).isEqualTo(17);
        assertThat(saved.getExpiryDate()).isEqualTo(LocalDate.of(2026,1,1));
    }
}
