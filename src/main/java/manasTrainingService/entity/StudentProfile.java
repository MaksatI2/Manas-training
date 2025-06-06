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
@Table(name = "student_profiles")
public class StudentProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    User user;

    @Column(name = "student_id", nullable = false, unique = true, length = 20)
    String studentId;

    @Column(name = "specialization", length = 100)
    String specialization;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    @Builder.Default
    StudentStatus status = StudentStatus.ACTIVE;

    public enum StudentStatus {
        ACTIVE("active"),
        GRADUATED("graduated"),
        SUSPENDED("suspended"),
        DROPPED("dropped");

        private final String value;

        StudentStatus(String value) {
            this.value = value;
        }

        public String getValue() {
            return value;
        }
    }
}
