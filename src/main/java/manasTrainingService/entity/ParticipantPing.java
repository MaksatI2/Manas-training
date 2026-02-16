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
@Table(name = "participant_pings")
public class ParticipantPing {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "meeting_participant_id", nullable = false)
    MeetingParticipant meetingParticipant;

    @Column(name = "ping_time", nullable = false)
    LocalDateTime pingTime;

    @Column(name = "is_active", nullable = false)
    @Builder.Default
    Boolean isActive = true;

    @Column(name = "connection_status", length = 50)
    @Builder.Default
    String connectionStatus = "CONNECTED";
}