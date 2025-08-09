package manasTrainingService.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import manasTrainingService.util.DateUtil;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "remember_me_tokens")
public class RememberMeToken {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @Column(name = "token", nullable = false, unique = true, length = 255)
    String token;

    @Column(name = "email", nullable = false, length = 255)
    String email;

    @Column(name = "user_agent", length = 500)
    String userAgent;

    @Column(name = "ip_address", length = 45)
    String ipAddress;

    @Column(name = "created_at", nullable = false)
    @Builder.Default
    LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "expires_at", nullable = false)
    LocalDateTime expiresAt;

    @Column(name = "last_used_at")
    LocalDateTime lastUsedAt;

    @Column(name = "is_active", nullable = false)
    @Builder.Default
    Boolean isActive = true;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    User user;

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiresAt);
    }

    public void updateLastUsed() {
        this.lastUsedAt = LocalDateTime.now();
    }

    public String getCreatedAtFormatted() {
        return DateUtil.formatWithTime(createdAt);
    }

    public String getExpiresAtFormatted() {
        return DateUtil.formatWithTime(expiresAt);
    }

    public String getLastUsedAtFormatted() {
        return DateUtil.formatWithTime(lastUsedAt);
    }
}