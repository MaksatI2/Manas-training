package manasTrainingService.repositories;

import manasTrainingService.entity.TeacherProfile;
import manasTrainingService.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TeacherProfileRepository extends JpaRepository<TeacherProfile, Integer> {
    Optional<TeacherProfile> findByUserId(Integer userId);
    Optional<TeacherProfile> findByUser(User user);
}
