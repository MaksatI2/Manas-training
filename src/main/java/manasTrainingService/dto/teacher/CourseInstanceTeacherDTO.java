package manasTrainingService.dto.teacher;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseInstanceTeacherDTO {
    private Integer id;
    private Integer teacherId;
    private String teacherName;
    private Boolean isPrimary;
    private LocalDateTime createdAt;
}