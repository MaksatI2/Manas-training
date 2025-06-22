package manasTrainingService.dto.lesson;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import manasTrainingService.entity.LessonType;
import manasTrainingService.validation.LessonDateInCourseRange;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@LessonDateInCourseRange
public class ScheduleDTO {
    private Integer id;
    private Integer courseInstanceId;
    private Integer lessonId;
    @NotNull(message = "Дата урока необходима")
    private LocalDate lessonDate;
    @NotNull(message = "Длительность урока необходима")
    @Min(value = 1, message = "Длительность должна быть больше 0")
    private Integer durationHours;
    @NotNull(message = "Преподаватель необходим")
    private Integer teacherId;
    private String teacherName;
    private String title;
    @NotNull(message = "Тип урока необходим")
    private LessonType lessonType;
    private String meetingUrl;
    private String notes;
}