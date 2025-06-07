package manasTrainingService.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "course_applications")
public class CourseApplication {
    public enum ApplicationStatus {
        PENDING, APPROVED, REJECTED
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    Course course;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "organization_id")
    Organization organization;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "submitted_by", nullable = false)
    User submittedBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "preferred_teacher_id")
    User preferredTeacher;

    @Column(name = "preferred_start_date")
    LocalDate preferredStartDate;

    @Column(name = "preferred_end_date")
    LocalDate preferredEndDate;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    ApplicationStatus status = ApplicationStatus.PENDING;

    @Column(name = "submitted_at", nullable = false)
    @Builder.Default
    LocalDateTime submittedAt = LocalDateTime.now();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "processed_by")
    User processedBy;

    @Column(name = "processed_at")
    LocalDateTime processedAt;

    @OneToMany(mappedBy = "application", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<CourseApplicationEmployee> employees;
}