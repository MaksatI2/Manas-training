package manasTrainingService.repositories;

import manasTrainingService.entity.LessonContent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface LessonContentRepository extends JpaRepository<LessonContent, Integer> {
    Optional<LessonContent> findByLessonId(Integer lessonId);
}
