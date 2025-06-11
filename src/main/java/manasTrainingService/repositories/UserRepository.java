package manasTrainingService.repositories;

import manasTrainingService.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByEmail(String email);
    Boolean existsByEmail(String email);
    Boolean existsByPhone(String phoneNumber);
    Boolean existsByName(String name);

    Page<User> findByRole_Name(String roleName, Pageable pageable);

    @Query("SELECT u FROM User u WHERE " +
           "(:role IS NULL OR :role = '' OR u.role.name = :role) AND " +
           "(:status IS NULL OR :status = '' OR " +
           "  (:status = 'active' AND u.isActive = true) OR " +
           "  (:status = 'inactive' AND u.isActive = false)) AND " +
           "(:search IS NULL OR :search = '' OR " +
           "  LOWER(u.email) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "  LOWER(u.name) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "  LOWER(u.lastName) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<User> findUsersWithFilters(@Param("role") String role,
                                    @Param("status") String status,
                                    @Param("search") String search,
                                    Pageable pageable);

    Page<User> findByIsActive(Boolean isActive, Pageable pageable);

    @Query("SELECT u FROM User u WHERE " +
           "LOWER(u.email) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(u.name) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(u.lastName) LIKE LOWER(CONCAT('%', :search, '%'))")
    Page<User> findByEmailOrNameContainingIgnoreCase(@Param("search") String search, Pageable pageable);

    @Query("SELECT DISTINCT r.name FROM Role r")
    List<String> findAllDistinctRoleNames();
}