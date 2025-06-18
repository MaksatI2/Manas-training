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
public class CourseTeacherDTO {
    private Integer id;
    private Integer teacherId;
    private String teacherName;
    private LocalDateTime createdAt;
}