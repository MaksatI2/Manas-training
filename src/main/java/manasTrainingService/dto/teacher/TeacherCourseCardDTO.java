package manasTrainingService.dto.teacher;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.entity.Test;

import java.time.LocalDateTime;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TeacherCourseCardDTO {
    Integer courseInstanceId;
    String courseTitle;
    String instanceTitle;
    LocalDateTime startDate;
    LocalDateTime endDate;
    Boolean isPrimary;
    TestDto courseTest;
}
