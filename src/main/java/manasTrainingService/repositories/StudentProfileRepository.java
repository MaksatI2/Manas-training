package manasTrainingService.repositories;

import manasTrainingService.entity.StudentProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StudentProfileRepository extends JpaRepository<StudentProfile, Integer> {
    Optional<StudentProfile> findByUserId(Integer userId);
    Optional<StudentProfile> findByOrganizationId(Integer organizationId);
}
