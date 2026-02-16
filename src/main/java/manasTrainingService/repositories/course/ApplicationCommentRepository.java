package manasTrainingService.repositories.course;

import manasTrainingService.entity.ApplicationComment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ApplicationCommentRepository extends JpaRepository<ApplicationComment, Integer> {
    List<ApplicationComment> findAllByApplicationIdOrderByCreatedAtAsc(Integer applicationId);

    @Modifying
    @Query("DELETE FROM ApplicationComment c WHERE c.application.id = :applicationId")
    void deleteAllByApplicationId(@Param("applicationId") Integer applicationId);

}
