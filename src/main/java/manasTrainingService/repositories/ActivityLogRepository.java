package manasTrainingService.repositories;

import manasTrainingService.entity.ActivityLogs;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ActivityLogRepository extends JpaRepository<ActivityLogs, Integer> {
}

