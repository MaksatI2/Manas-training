package manasTrainingService.repositories.course;

import manasTrainingService.entity.CourseEnrollment;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
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

    boolean existsByCourseInstanceIdAndStudentId(Integer courseInstanceId, Integer studentId);

    List<CourseEnrollment> findByStudentIdAndStatus(Integer studentId, Status status);

    boolean existsByStudentIdAndCourseInstanceId(Integer studentId, Integer courseInstanceId);

    List<CourseEnrollment> findByStudentIn(List<User> students);

    List<CourseEnrollment> findByStudent(User student);

    @Query("""
                SELECT e FROM CourseEnrollment e
                JOIN FETCH e.courseInstance ci
                JOIN FETCH ci.course
                WHERE e.student IN :students
            """)
    List<CourseEnrollment> findWithCourseByStudentIn(@Param("students") List<User> students);


}
