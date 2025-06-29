package manasTrainingService.repositories.course;

import manasTrainingService.entity.ApplicationComment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ApplicationCommentRepository extends JpaRepository<ApplicationComment, Integer> {
    List<ApplicationComment> findAllByApplicationIdOrderByCreatedAtAsc(Integer applicationId);
}
