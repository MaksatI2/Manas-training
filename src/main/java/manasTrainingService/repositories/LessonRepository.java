package manasTrainingService.repositories;

import manasTrainingService.entity.Lesson;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LessonRepository extends JpaRepository<Lesson, Integer> {
    List<Lesson> findAllByModuleId(Integer moduleId);
    List<Lesson> findByModuleId(Integer moduleId);

    @Query("SELECT COALESCE(SUM(l.durationMinutes), 0) FROM Lesson l WHERE l.module.id = :moduleId")
    int getTotalUsedMinutes(@Param("moduleId") Integer moduleId);
}
