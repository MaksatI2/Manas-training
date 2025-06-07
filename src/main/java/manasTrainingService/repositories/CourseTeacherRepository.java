package manasTrainingService.repositories;

import manasTrainingService.entity.CourseTeacher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseTeacherRepository extends JpaRepository<CourseTeacher, Integer> {
    List<CourseTeacher> findAllByTeacherId(Integer teacherId);
}
