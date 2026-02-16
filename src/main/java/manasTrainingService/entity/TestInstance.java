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
@Table(name = "test_instances")
public class TestInstance {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    Integer id;

    @OneToOne
    @JoinColumn(name = "course_instance_id", nullable = false, unique = true)
    CourseInstance instance;

    @ManyToOne
    @JoinColumn(name = "test_id", nullable = false)
    Test test;

    @Column(name = "scheduled_start")
    LocalDateTime scheduledStart;

    @Column(name ="scheduled_end")
    LocalDateTime scheduledEnd;

    @OneToMany(mappedBy = "testInstance", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<TestResult> attempts;
}
