package manasTrainingService.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "schedules")
public class Schedule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    Course course;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "teacher_id", nullable = false)
    User teacher;

    @Column(name = "title", length = 200)
    String title;

    @Enumerated(EnumType.STRING)
    @Column(name = "lesson_type", nullable = false)
    LessonType lessonType;

    @Column(name = "start_datetime", nullable = false)
    LocalDateTime startDatetime;

    @Column(name = "end_datetime", nullable = false)
    LocalDateTime endDatetime;

    @Column(name = "is_online", nullable = false)
    @Builder.Default
    Boolean isOnline = false;

    @Column(name = "meeting_url", length = 500)
    String meetingUrl;

    @Column(name = "notes", columnDefinition = "TEXT")
    String notes;

    @Column(name = "is_active", nullable = false)
    @Builder.Default
    Boolean isActive = true;

    @OneToMany(mappedBy = "schedule", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<Attendance> attendances;

    public enum LessonType {
        LECTURE("lecture"),
        PRACTICAL("practical"),
        EXAM("exam"),
        CONSULTATION("consultation");

        private final String value;

        LessonType(String value) {
            this.value = value;
        }

        public String getValue() {
            return value;
        }
    }
}
