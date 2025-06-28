package manasTrainingService.repositories.quiz;

import manasTrainingService.entity.LessonQuizOption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LessonQuizOptionRepository extends JpaRepository<LessonQuizOption, Integer> {

    List<LessonQuizOption> findAllByQuestionId(Integer questionId);
}
