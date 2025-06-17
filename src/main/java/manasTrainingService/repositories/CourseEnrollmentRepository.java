package manasTrainingService.repositories;

import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.Status;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CourseEnrollmentRepository extends JpaRepository<CourseEnrollment, Integer> {
    List<CourseEnrollment> findAllByCourseInstanceId(Integer courseId);
    List<CourseEnrollment> findAllByStudentId(Integer studentId);
    Optional<CourseEnrollment> findByCourseInstanceIdAndStudentId(Integer courseId, Integer studentId);
    List<CourseEnrollment> findAllByCourseInstanceIdAndStatus(Integer courseId, Status status);
    List<CourseEnrollment> findAllByStudentIdAndStatus(Integer studentId, Status status);
    List<CourseEnrollment> findByCourseInstanceId(Integer courseInstanceId);
}
