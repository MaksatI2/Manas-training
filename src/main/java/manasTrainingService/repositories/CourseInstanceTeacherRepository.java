package manasTrainingService.repositories;

import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseInstanceTeacher;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CourseInstanceTeacherRepository extends JpaRepository<CourseInstanceTeacher, Integer> {
    List<CourseInstanceTeacher> findByCourseInstanceId(Integer courseInstance);
    boolean existsByCourseInstanceIdAndTeacherIdAndIsPrimaryTrue(Integer courseInstance, Integer teacherId);
    boolean existsByCourseInstanceIdAndTeacherId(Integer courseInstance, Integer teacherId);
    Optional<CourseInstanceTeacher> findByCourseInstanceIdAndTeacherId(Integer courseId, Integer teacherId);
    List<CourseInstanceTeacher> findByTeacherIdAndIsPrimaryTrue(Integer teacherId);
}
