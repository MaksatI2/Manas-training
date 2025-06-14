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
@Table(name = "course_instance_teachers",
        uniqueConstraints = @UniqueConstraint(columnNames = {"course_instance_id", "teacher_id"}))
public class CourseInstanceTeacher {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_instance_id", nullable = false)
    CourseInstance courseInstance;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "teacher_id", nullable = false)
    User teacher;

    @Column(name = "is_primary")
    Boolean isPrimary;

    @Column(name = "created_at")
    @Builder.Default
    LocalDateTime createdAt = LocalDateTime.now();
}