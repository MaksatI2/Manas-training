package manasTrainingService.repositories;

import manasTrainingService.entity.LessonType;
import manasTrainingService.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Integer> {
    Optional<Schedule> findByTeacherId(Integer teacherId);

    List<Schedule> findAllByLessonType(LessonType lessonType);

    Optional<Schedule> findByLessonId(Integer lessonId);

    @Query("""
                SELECT COUNT(s) > 0 FROM Schedule s
                WHERE s.courseInstance.id = :courseInstanceId
                  AND (s.lessonDate < :newStart OR s.lessonDate > :newEnd)
            """)
    boolean existsByCourseInstanceIdAndLessonDateOutsideRange(
            @Param("courseInstanceId") Integer courseInstanceId,
            @Param("newStart") LocalDate newStart,
            @Param("newEnd") LocalDate newEnd
    );

    @Query("""
            SELECT COUNT(s) > 0 FROM Schedule s
            WHERE s.courseInstance.id = :courseInstanceId
              AND s.lessonDate < :newStart
            """)
    boolean existsByCourseInstanceIdAndLessonDateBeforeStart(
            @Param("courseInstanceId") Integer courseInstanceId,
            @Param("newStart") LocalDate newStart
    );

    @Query("""
            SELECT COUNT(s) > 0 FROM Schedule s
            WHERE s.courseInstance.id = :courseInstanceId
              AND s.lessonDate > :newEnd
            """)
    boolean existsByCourseInstanceIdAndLessonDateAfterEnd(
            @Param("courseInstanceId") Integer courseInstanceId,
            @Param("newEnd") LocalDate newEnd
    );


}
