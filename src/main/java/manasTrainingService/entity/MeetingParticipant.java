package manasTrainingService.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "meeting_participants")
public class MeetingParticipant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "meeting_id", nullable = false)
    Meeting meeting;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    User user;

    @Column(name = "participant_name", length = 100)
    String participantName;

    @Column(name = "participant_id", length = 100)
    String participantId;

    @Column(name = "joined_at", nullable = false)
    LocalDateTime joinedAt;

    @Column(name = "left_at")
    LocalDateTime leftAt;

    @Column(name = "duration_seconds")
    Integer durationSeconds;

    @Column(name = "is_moderator", nullable = false)
    @Builder.Default
    Boolean isModerator = false;
}