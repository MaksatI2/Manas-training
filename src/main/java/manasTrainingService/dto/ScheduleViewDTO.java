package manasTrainingService.dto;

import lombok.*;
import lombok.experimental.FieldDefaults;
import manasTrainingService.entity.LessonType;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ScheduleViewDTO {
    Integer id;
    Integer lessonId;
    Integer courseInstanceId;

    String courseTitle;
    String courseInstanceTitle;
    String lessonTitle;
    String lessonDescription;

    LocalDate lessonDate;
    Integer durationHours;

    String teacherName;
    Integer teacherId;

    LessonType lessonType;
    String meetingUrl;
    String notes;

    Boolean isActive;
}
