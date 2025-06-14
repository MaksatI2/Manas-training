package manasTrainingService.repositories;

import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.Status;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CourseEnrollmentRepository extends JpaRepository<CourseEnrollment, Integer> {
    List<CourseEnrollment> findAllByCourseId(Integer courseId);
    List<CourseEnrollment> findAllByStudentId(Integer studentId);
    Optional<CourseEnrollment> findByCourseIdAndStudentId(Integer courseId, Integer studentId);
    List<CourseEnrollment> findAllByCourseIdAndStatus(Integer courseId, Status status);
    List<CourseEnrollment> findAllByStudentIdAndStatus(Integer studentId, Status status);

}
