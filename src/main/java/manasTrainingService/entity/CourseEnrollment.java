package manasTrainingService.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "course_enrollments",
        uniqueConstraints = @UniqueConstraint(columnNames = {"course_id", "student_id"}))
public class CourseEnrollment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    Course course;

    @ManyToOne
    @JoinColumn(name = "student_id")
    User student;

    @Column(name = "enrollment_date", nullable = false)
    @Builder.Default
    LocalDateTime enrollmentDate = LocalDateTime.now();

    @Column(name = "completion_date")
    LocalDateTime completionDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    @Builder.Default
    EnrollmentStatus status = EnrollmentStatus.ENROLLED;

    @Column(name = "progress_percentage", precision = 5, scale = 2)
    @Builder.Default
    BigDecimal progressPercentage = BigDecimal.ZERO;

    @Column(name = "final_grade", precision = 5, scale = 2)
    BigDecimal finalGrade;

    public enum EnrollmentStatus {
        ENROLLED("enrolled"),
        IN_PROGRESS("in_progress"),
        COMPLETED("completed"),
        DROPPED("dropped");

        private final String value;

        EnrollmentStatus(String value) {
            this.value = value;
        }

        public String getValue() {
            return value;
        }
    }
}