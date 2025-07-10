package manasTrainingService.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "lessons")
public class Lesson {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "module_id", nullable = false)
    CourseModule module;

    @Column(name = "title", length = 200)
    String title;

    @Column(name = "description", columnDefinition = "TEXT")
    String description;

    @OneToMany(mappedBy = "lesson", orphanRemoval = true, cascade = CascadeType.ALL,  fetch = FetchType.LAZY)
    List<Schedule> schedules;

    @OneToMany(mappedBy = "lesson", orphanRemoval = true, cascade = CascadeType.ALL,  fetch = FetchType.LAZY)
    List<LessonMaterial> materials;

    @OneToMany(mappedBy = "lesson", orphanRemoval = true, cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<LessonQuiz> quizzes;

    @OneToOne(mappedBy = "lesson", cascade = CascadeType.ALL, fetch = FetchType.LAZY, optional = true)
    LessonContent content;
}