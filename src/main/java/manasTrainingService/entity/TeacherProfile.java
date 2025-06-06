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
@Table(name = "teacher_profiles")
public class TeacherProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    User user;

    @Column(name = "employee_id", nullable = false, unique = true, length = 20)
    String employeeId;

    @Column(name = "department", length = 100)
    String department;

    @Column(name = "qualifications", columnDefinition = "TEXT")
    String qualifications;

    @Column(name = "bio", columnDefinition = "TEXT")
    String bio;
}