package manasTrainingService.repositories.quiz;

import manasTrainingService.entity.LessonQuizOption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LessonQuizOptionRepository extends JpaRepository<LessonQuizOption, Integer> {

    List<LessonQuizOption> findAllByQuestionId(Integer questionId);

    @Modifying
    @Query(value = "DELETE FROM LessonQuizOption l WHERE l = :lessonQuizOption")
    void delete(LessonQuizOption lessonQuizOption);
}
