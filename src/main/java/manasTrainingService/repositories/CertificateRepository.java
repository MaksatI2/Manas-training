package manasTrainingService.repositories;

import manasTrainingService.entity.Certificate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface CertificateRepository extends JpaRepository<Certificate, Integer> {
    List<Certificate> findAllByStudentId(Integer studentId);
    Certificate findByCertificateNumber(String certificateNumber);
    boolean existsByCertificateNumber(String certificateNumber);
    List<Certificate> findAllByStudentIdAndIsActiveTrue(Integer studentId);
    List<Certificate> findByStudentId(Integer studentId);
    @Query("SELECT COALESCE(MAX(CAST(c.certificateNumber AS integer)), 0) FROM Certificate c")
    Integer findMaxCertificateNumber();
    boolean existsByStudentIdAndCourseInstanceId(Integer studentId, Integer courseInstanceId);
    List<Certificate> findByStudentIdAndCourseInstanceId(Integer studentId, Integer courseInstanceId);
    @Query("""
    SELECT DISTINCT c
    FROM Certificate c
    JOIN FETCH c.courseInstance ci
    LEFT JOIN FETCH ci.modules m
    WHERE c.id = :id
    """)
    Optional<Certificate> findByIdWithModules(@Param("id") Integer id);
    long countByIssueDateBetween(LocalDate startDate, LocalDate endDate);
    Optional<Certificate> findByPublicToken(String publicToken);
    @Query("select c from Certificate c where c.id = :id and c.student.id = :studentId")
    Optional<Certificate> findByIdAndStudentId(@Param("id") Integer id, @Param("studentId") Integer studentId);
}
