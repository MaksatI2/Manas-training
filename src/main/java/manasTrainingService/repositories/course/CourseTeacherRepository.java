package manasTrainingService.repositories.course;

import manasTrainingService.entity.CourseTeacher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface CourseTeacherRepository extends JpaRepository<CourseTeacher, Integer> {
    List<CourseTeacher> findAllByTeacherId(Integer teacherId);
    List<CourseTeacher> findByCourseId(Integer courseId);

    @Modifying
    @Transactional
    @Query("delete from CourseTeacher ct where ct.teacher.id = :teacherId")
    void deleteByTeacherId(@Param("teacherId") Integer teacherId);
}
