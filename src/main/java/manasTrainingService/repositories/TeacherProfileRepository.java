package manasTrainingService.repositories;

import manasTrainingService.entity.TeacherProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TeacherProfileRepository extends JpaRepository<TeacherProfile, Integer> {
    Optional<TeacherProfile> findByUserId(Integer userId);
    Optional<TeacherProfile> findByEmployeeId(Integer studentId);
}
