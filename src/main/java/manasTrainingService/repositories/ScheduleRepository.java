package manasTrainingService.repositories;

import manasTrainingService.entity.LessonType;
import manasTrainingService.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Integer>, JpaSpecificationExecutor<Schedule> {
    Optional<Schedule> findByLessonId(Integer lessonId);

    @Query("SELECT s FROM Schedule s WHERE " +
           "(:courseTitle IS NULL OR s.courseInstance.course.title LIKE %:courseTitle%) AND " +
           "(:courseInstanceTitle IS NULL OR s.courseInstance.title LIKE %:courseInstanceTitle%) AND " +
           "(:teacherName IS NULL OR CONCAT(s.teacher.name, ' ', s.teacher.lastName) LIKE %:teacherName%) AND " +
           "(:lessonType IS NULL OR s.lessonType = :lessonType) AND " +
           "s.isActive = true")
    List<Schedule> findWithFilters(
            @Param("courseTitle") String courseTitle,
            @Param("courseInstanceTitle") String courseInstanceTitle,
            @Param("teacherName") String teacherName,
            @Param("lessonType") LessonType lessonType);
}