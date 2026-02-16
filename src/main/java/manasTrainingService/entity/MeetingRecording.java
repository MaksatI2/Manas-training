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
@Table(name = "meeting_recordings")
public class MeetingRecording {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "meeting_id", nullable = false)
    Meeting meeting;

    @Column(name = "recording_id", nullable = false, unique = true, length = 100)
    String recordingId;

    @Column(name = "file_name", nullable = false, length = 255)
    String fileName;

    @Column(name = "file_path", nullable = false, length = 500)
    String filePath;

    @Column(name = "file_url", length = 500)
    String fileUrl;

    @Column(name = "file_size")
    Long fileSize;

    @Column(name = "duration_seconds")
    Integer durationSeconds;

    @Column(name = "started_at", nullable = false)
    LocalDateTime startedAt;

    @Column(name = "completed_at")
    LocalDateTime completedAt;

    @Column(name = "created_at", nullable = false)
    @Builder.Default
    LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "is_available", nullable = false)
    @Builder.Default
    Boolean isAvailable = false;
}