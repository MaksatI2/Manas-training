package manasTrainingService.repositories;

import manasTrainingService.entity.Certificate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CertificateRepository extends JpaRepository<Certificate, Integer> {
    List<Certificate> findAllByStudentId(Integer studentId);
    List<Certificate> findAllByCourseId(Integer courseId);
}
