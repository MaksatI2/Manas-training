package manasTrainingService.repositories;

import manasTrainingService.entity.Notification;
import manasTrainingService.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Integer> {

    List<Notification> findAllByUserOrderByCreatedAtDesc(User user);

    Long countByUserAndIsReadFalse(User user);
}
