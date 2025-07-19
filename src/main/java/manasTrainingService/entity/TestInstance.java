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
@Table(name = "test_instances")
public class TestInstance {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    Integer id;

    @ManyToOne
    @JoinColumn(name = "course_instance_id")
    CourseInstance instance;

    @ManyToOne
    @JoinColumn(name = "test_id")
    Test test;

    @Column(name = "scheduled_start")
    LocalDateTime scheduledStart;

    @Column(name ="scheduled_end")
    LocalDateTime scheduledEnd;
}
