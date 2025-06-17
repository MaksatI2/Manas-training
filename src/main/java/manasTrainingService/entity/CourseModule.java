package manasTrainingService.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "course_modules")
public class CourseModule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_instance_id", nullable = false)
    CourseInstance courseInstance;

    @Column(name = "title", length = 200)
    String title;

    @Column(name = "duration_hours", nullable = false)
    Integer durationHours;

    @Column(name = "description", columnDefinition = "TEXT")
    String description;

    @Column(name = "order_index", nullable = false)
    Integer orderIndex;

    @Column(name = "is_active", nullable = false)
    @Builder.Default
    Boolean isActive = true;
}
