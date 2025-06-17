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
@Table(name = "course_instances")
public class CourseInstance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    Course course;

    @Column(name = "title", length = 200)
    String title;

    @Column(name = "start_date", nullable = false)
    LocalDateTime startDate;

    @Column(name = "end_date", nullable = false)
    LocalDateTime endDate;

    @Column(name = "is_active")
    @Builder.Default
    Boolean isActive = true;

    @Column(name = "created_at")
    @Builder.Default
    LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    @Builder.Default
    LocalDateTime updatedAt = LocalDateTime.now();

    @OneToMany(mappedBy = "courseInstance", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<CourseInstanceTeacher> teachers;

    @OneToMany(mappedBy = "courseInstance", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<CourseEnrollment> enrollments;

    @OneToMany(mappedBy = "courseInstance", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<CourseModule> modules;

    @PreUpdate
    void preUpdate() {
        updatedAt = LocalDateTime.now();
    }
}