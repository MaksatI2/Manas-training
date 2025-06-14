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
@Table(name = "courses")
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    CourseCategory category;

    @Column(name = "is_individual", nullable = false)
    @Builder.Default
    Boolean isIndividual = false;

    @Column(name = "code", nullable = false, unique = true, length = 20)
    String code;

    @Column(name = "title", length = 200)
    String title;

    @Column(name = "description", columnDefinition = "TEXT")
    String description;

    @Column(name = "duration_hours", nullable = false)
    Integer durationHours;

    @Column(name = "is_active", nullable = false)
    @Builder.Default
    Boolean isActive = true;

    @Column(name = "created_at", nullable = false)
    @Builder.Default
    LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", nullable = false)
    @Builder.Default
    LocalDateTime updatedAt = LocalDateTime.now();

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<CourseEnrollment> enrollments;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<CourseModule> modules;

    @PreUpdate
    void preUpdate() {
        updatedAt = LocalDateTime.now();
    }
}