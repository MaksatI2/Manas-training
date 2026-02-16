package manasTrainingService.repositories;

import manasTrainingService.entity.Notification;
import manasTrainingService.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Integer> {

    List<Notification> findAllByUserOrderByCreatedAtDesc(User user);

    Long countByUserAndIsReadFalse(User user);

    List<Notification> findAllByUserAndIsReadFalse(User user);

    @Modifying
    @Query("DELETE FROM Notification n WHERE n.user = :user")
    void deleteByUser(@Param("user") User user);

    @Transactional
    @Modifying
    @Query("DELETE FROM Notification n WHERE n.createdAt < :threshold")
    int deleteByCreatedAtBefore(@Param("threshold") LocalDateTime threshold);

}
