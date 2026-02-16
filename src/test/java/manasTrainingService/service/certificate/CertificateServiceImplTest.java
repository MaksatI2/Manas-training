package manasTrainingService.service.certificate;

import jakarta.persistence.EntityNotFoundException;
import manasTrainingService.dto.certificate.*;
import manasTrainingService.entity.Certificate;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.User;
import manasTrainingService.repositories.CertificateRepository;
import manasTrainingService.repositories.course.CourseEnrollmentRepository;
import manasTrainingService.repositories.course.CourseInstanceRepository;
import manasTrainingService.service.impl.certificate.CertificateServiceImpl;
import manasTrainingService.service.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.MessageSource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;

import java.time.LocalDate;
import java.util.*;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CertificateServiceImplTest {

    @Mock
    private CourseEnrollmentRepository enrollRepo;

    @Mock
    private CertificateRepository certRepo;

    @Mock
    private UserService userService;

    @Mock
    private CourseInstanceRepository ciRepo;

    @Mock
    private MessageSource messageSource;

    @InjectMocks
    private CertificateServiceImpl certificateService;

    private User testUser;
    private Course testCourse;
    private CourseInstance testCourseInstance;
    private CourseEnrollment testEnrollment;
    private Certificate testCertificate;

    @BeforeEach
    void setUp() {
        testUser = new User();
        testUser.setId(1);
        testUser.setName("John");
        testUser.setLastName("Doe");
        testUser.setEmail("john.doe@test.com");

        testCourse = new Course();
        testCourse.setId(1);
        testCourse.setTitle("Test Course");

        testCourseInstance = new CourseInstance();
        testCourseInstance.setId(1);
        testCourseInstance.setTitle("Test Course Instance");
        testCourseInstance.setCourse(testCourse);

        testEnrollment = new CourseEnrollment();
        testEnrollment.setStudent(testUser);
        testEnrollment.setCourseInstance(testCourseInstance);

        testCertificate = new Certificate();
        testCertificate.setId(1);
        testCertificate.setCertificateNumber("123");
        testCertificate.setStudent(testUser);
        testCertificate.setCourseInstance(testCourseInstance);
        testCertificate.setIssueDate(LocalDate.now());
        testCertificate.setExpiryDate(LocalDate.now().plusYears(1));
        testCertificate.setMark(85);
        testCertificate.setIssuedBy(testUser);
    }

    @Test
    void getStatuses_WhenStudentHasCompletedCourses_ShouldReturnStatuses() {
        when(enrollRepo.findByStudentIdAndCompletionDateIsNotNull(1))
                .thenReturn(List.of(testEnrollment));
        when(certRepo.findByStudentIdAndCourseInstanceId(1, 1))
                .thenReturn(List.of(testCertificate));

        List<CourseCertificateStatusDto> result = certificateService.getStatuses(1);

        assertThat(result).hasSize(1);
        CourseCertificateStatusDto status = result.get(0);
        assertThat(status.getCourseTitle()).isEqualTo("Test Course");
        assertThat(status.isCertificateCreated()).isTrue();
        assertThat(status.getCertificateId()).containsExactly(1);
        assertThat(status.getCourseInstanceId()).isEqualTo(1);
    }

    @Test
    void getStatuses_WhenNoCertificateExists_ShouldReturnStatusWithNoCertificate() {
        when(enrollRepo.findByStudentIdAndCompletionDateIsNotNull(1))
                .thenReturn(List.of(testEnrollment));
        when(certRepo.findByStudentIdAndCourseInstanceId(1, 1))
                .thenReturn(Collections.emptyList());

        List<CourseCertificateStatusDto> result = certificateService.getStatuses(1);

        assertThat(result).hasSize(1);
        CourseCertificateStatusDto status = result.get(0);
        assertThat(status.isCertificateCreated()).isFalse();
        assertThat(status.getCertificateId()).isEmpty();
    }

    @Test
    void findAllByStudentId_ShouldReturnCertificateViewDtos() {
        when(certRepo.findByStudentId(1)).thenReturn(List.of(testCertificate));

        List<CertificateViewDto> result = certificateService.findAllByStudentId(1);

        assertThat(result).hasSize(1);
        CertificateViewDto dto = result.get(0);
        assertThat(dto.getId()).isEqualTo(1);
        assertThat(dto.getCertificateNumber()).isEqualTo("123");
        assertThat(dto.getCourseTitle()).isEqualTo("Test Course");
        assertThat(dto.getViewUrl()).isEqualTo("/student/certificates/1");
        assertThat(dto.getDownloadUrl()).isEqualTo("/student/certificates/1/pdf");
    }

    @Test
    void findOneByIdAndStudentId_WhenCertificateExists_ShouldReturnCertificateViewDto() {
        when(certRepo.findById(1)).thenReturn(Optional.of(testCertificate));

        CertificateViewDto result = certificateService.findOneByIdAndStudentId(1, 1);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1);
        assertThat(result.getCertificateNumber()).isEqualTo("123");
        assertThat(result.getCourseTitle()).isEqualTo("Test Course");
    }

    @Test
    void findOneByIdAndStudentId_WhenCertificateNotFound_ShouldThrowException() {
        when(certRepo.findById(1)).thenReturn(Optional.empty());
        when(messageSource.getMessage(eq("certificate.not.found"), isNull(), any()))
                .thenReturn("Certificate not found");

        assertThatThrownBy(() -> certificateService.findOneByIdAndStudentId(1, 1))
                .isInstanceOf(EntityNotFoundException.class)
                .hasMessage("Certificate not found");
    }

    @Test
    void findOneByIdAndStudentId_WhenStudentIdDoesNotMatch_ShouldThrowException() {
        when(certRepo.findById(1)).thenReturn(Optional.of(testCertificate));
        when(messageSource.getMessage(eq("certificate.not.found"), isNull(), any()))
                .thenReturn("Certificate not found");

        assertThatThrownBy(() -> certificateService.findOneByIdAndStudentId(1, 2))
                .isInstanceOf(EntityNotFoundException.class)
                .hasMessage("Certificate not found");
    }

    @Test
    void listStudentsWithCertificates_ShouldReturnPageOfStudents() {
        Page<User> userPage = new PageImpl<>(List.of(testUser));
        when(enrollRepo.findStudentsWithCompletedCourses(any(PageRequest.class)))
                .thenReturn(userPage);
        when(enrollRepo.findByStudentIdAndCompletionDateIsNotNull(1))
                .thenReturn(List.of(testEnrollment));

        Page<StudentDto> result = certificateService.listStudentsWithCertificates(0, 10);

        assertThat(result.getContent()).hasSize(1);
        StudentDto studentDto = result.getContent().get(0);
        assertThat(studentDto.getId()).isEqualTo(1);
        assertThat(studentDto.getName()).isEqualTo("John");
        assertThat(studentDto.getLastName()).isEqualTo("Doe");
        assertThat(studentDto.getEmail()).isEqualTo("john.doe@test.com");
    }

    @Test
    void deleteCertificate_ShouldCallRepository() {
        certificateService.deleteCertificate(1);

        verify(certRepo).deleteById(1);
    }

    @Test
    void prepareEdit_WhenCertificateExists_ShouldReturnEditDto() {
        when(certRepo.findById(1)).thenReturn(Optional.of(testCertificate));

        EditCertificateDto result = certificateService.prepareEdit(1);

        assertThat(result.getId()).isEqualTo(1);
        assertThat(result.getStudentId()).isEqualTo(1);
        assertThat(result.getMark()).isEqualTo(85);
        assertThat(result.getIssueDate()).isEqualTo(testCertificate.getIssueDate());
        assertThat(result.getExpiryDate()).isEqualTo(testCertificate.getExpiryDate());
    }

    @Test
    void prepareEdit_WhenCertificateNotFound_ShouldThrowException() {
        when(certRepo.findById(1)).thenReturn(Optional.empty());
        when(messageSource.getMessage(eq("certificate.not.found"), isNull(), any()))
                .thenReturn("Certificate not found");

        assertThatThrownBy(() -> certificateService.prepareEdit(1))
                .isInstanceOf(EntityNotFoundException.class)
                .hasMessage("Certificate not found");
    }


    @Test
    void createCertificate_ShouldCreateAndSaveCertificate() {
        CreateCertificateDto createDto = new CreateCertificateDto();
        createDto.setStudentId(1);
        createDto.setCourseInstanceId(1);
        createDto.setExpiryDate(LocalDate.now().plusYears(1));
        createDto.setMark(95);

        when(ciRepo.findById(1)).thenReturn(Optional.of(testCourseInstance));
        when(userService.getUserById(1)).thenReturn(testUser);
        when(userService.getUserById(2)).thenReturn(testUser);
        when(certRepo.findMaxCertificateNumber()).thenReturn(100);

        certificateService.createCertificate(createDto, 2);

        verify(certRepo).save(any(Certificate.class));
    }

    @Test
    void createCertificate_WhenCourseInstanceNotFound_ShouldThrowException() {
        CreateCertificateDto createDto = new CreateCertificateDto();
        createDto.setCourseInstanceId(999);

        when(ciRepo.findById(999)).thenReturn(Optional.empty());
        when(messageSource.getMessage(eq("course.instance.not.found"), isNull(), any()))
                .thenReturn("Course instance not found");

        assertThatThrownBy(() -> certificateService.createCertificate(createDto, 1))
                .isInstanceOf(EntityNotFoundException.class)
                .hasMessage("Course instance not found");
    }

    @Test
    void getCertificate_WhenExists_ShouldReturnCertificate() {
        when(certRepo.findById(1)).thenReturn(Optional.of(testCertificate));

        Certificate result = certificateService.getCertificate(1);

        assertThat(result).isEqualTo(testCertificate);
    }

    @Test
    void getCertificate_WhenNotFound_ShouldThrowException() {
        when(certRepo.findById(1)).thenReturn(Optional.empty());
        when(messageSource.getMessage(eq("certificate.not.found"), isNull(), any()))
                .thenReturn("Certificate not found");

        assertThatThrownBy(() -> certificateService.getCertificate(1))
                .isInstanceOf(EntityNotFoundException.class);
    }

    @Test
    void getCertificatesByStudentAndCourseInstance_ShouldReturnCertificates() {
        when(certRepo.findByStudentIdAndCourseInstanceId(1, 1))
                .thenReturn(List.of(testCertificate));

        List<Certificate> result = certificateService.getCertificatesByStudentAndCourseInstance(1, 1);

        assertThat(result).containsExactly(testCertificate);
    }

    @Test
    void getTotalCertificates_ShouldReturnCount() {
        when(certRepo.count()).thenReturn(42L);

        long result = certificateService.getTotalCertificates();

        assertThat(result).isEqualTo(42L);
    }

    @Test
    void getCertificatesIssuedThisMonth_ShouldReturnCount() {
        LocalDate startDate = LocalDate.of(2024, 1, 1);
        LocalDate endDate = LocalDate.of(2024, 1, 31);
        when(certRepo.countByIssueDateBetween(startDate, endDate)).thenReturn(15L);

        long result = certificateService.getCertificatesIssuedThisMonth(startDate, endDate);

        assertThat(result).isEqualTo(15L);
    }
}