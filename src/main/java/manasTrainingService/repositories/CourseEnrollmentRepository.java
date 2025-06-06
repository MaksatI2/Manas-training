package manasTrainingService.repositories;

import manasTrainingService.entity.CourseEnrollment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseEnrollmentRepository extends JpaRepository<CourseEnrollment, Integer> {
    List<CourseEnrollment> findAllByCourseId(Integer courseId);
    List<CourseEnrollment> findAllByStudentId(Integer studentId);
}
