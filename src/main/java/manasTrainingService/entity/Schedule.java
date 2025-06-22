package manasTrainingService.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
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
    @JoinColumn(name = "course_instance_id", nullable = false)
    CourseInstance courseInstance;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lesson_id", nullable = false)
    Lesson lesson;

    @Column(name = "lesson_date", nullable = false)
    LocalDate lessonDate;

    @Column(name = "duration_hours", nullable = false)
    @Builder.Default
    Integer durationHours = 1;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "teacher_id", nullable = false)
    User teacher;

    @Column(name = "title", length = 200)
    String title;

    @Enumerated(EnumType.STRING)
    @Column(name = "lesson_type", nullable = false)
    LessonType lessonType;

    @Column(name = "meeting_url", length = 500)
    String meetingUrl;

    @Column(name = "notes", columnDefinition = "TEXT")
    String notes;

    @Column(name = "is_active", nullable = false)
    @Builder.Default
    Boolean isActive = true;

    @OneToMany(mappedBy = "schedule", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<Attendance> attendances;
}
