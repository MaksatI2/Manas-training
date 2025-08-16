package manasTrainingService.dto.lesson;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.*;
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

    @NotNull(message = "{schedule.lessonDate.notNull}")
    private LocalDate lessonDate;

    @NotNull(message = "{schedule.durationHours.notNull}")
    @Min(value = 1, message = "{schedule.durationHours.min}")
    private Integer durationHours;

    @NotNull(message = "{schedule.teacherId.notNull}")
    private Integer teacherId;

    private String teacherName;
    private String title;

    @NotNull(message = "{schedule.lessonType.notNull}")
    private LessonType lessonType;

    private String notes;
    private String formattedLessonDate;
}
