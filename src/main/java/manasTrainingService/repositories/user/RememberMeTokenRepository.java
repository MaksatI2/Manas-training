package manasTrainingService.repositories.user;

import manasTrainingService.entity.RememberMeToken;
import manasTrainingService.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface RememberMeTokenRepository extends JpaRepository<RememberMeToken, Long> {

    Optional<RememberMeToken> findByTokenAndIsActiveTrue(String token);

    List<RememberMeToken> findByEmailAndIsActiveTrue(String email);

    List<RememberMeToken> findByUserAndIsActiveTrue(User user);

    @Modifying
    @Transactional
    @Query("UPDATE RememberMeToken r SET r.isActive = false WHERE r.email = :email")
    void deactivateAllTokensForEmail(@Param("email") String email);

    @Modifying
    @Transactional
    @Query("UPDATE RememberMeToken r SET r.isActive = false WHERE r.user = :user")
    void deactivateAllTokensForUser(@Param("user") User user);

    @Modifying
    @Transactional
    @Query("UPDATE RememberMeToken r SET r.isActive = false WHERE r.token = :token")
    void deactivateToken(@Param("token") String token);

    @Modifying
    @Transactional
    @Query("DELETE FROM RememberMeToken r WHERE r.expiresAt < :now OR r.isActive = false")
    void deleteExpiredAndInactiveTokens(@Param("now") LocalDateTime now);

    @Query("SELECT r FROM RememberMeToken r WHERE r.expiresAt < :now")
    List<RememberMeToken> findExpiredTokens(@Param("now") LocalDateTime now);
}
