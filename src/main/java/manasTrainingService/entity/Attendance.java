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
@Table(name = "attendance")
public class Attendance {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "schedule_id", nullable = false)
    Schedule schedule;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    User student;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    AttendanceStatus status;

    @Column(name = "check_in_time")
    LocalDateTime checkInTime;

    @Column(name = "notes", columnDefinition = "TEXT")
    String notes;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "marked_by", nullable = false)
    User markedBy;

    @Column(name = "marked_at", nullable = false)
    @Builder.Default
    LocalDateTime markedAt = LocalDateTime.now();

    public enum AttendanceStatus {
        PRESENT("present"),
        ABSENT("absent"),
        LATE("late"),
        EXCUSED("excused");

        private final String value;

        AttendanceStatus(String value) {
            this.value = value;
        }

        public String getValue() {
            return value;
        }
    }
}
