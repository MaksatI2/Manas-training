package manasTrainingService.repositories.user;

import manasTrainingService.entity.Organization;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface OrganizationRepository extends JpaRepository<Organization, Integer> {
    Optional<Organization> findByCode(String code);
    Optional<Organization> findByUserId(Integer userId);
}
