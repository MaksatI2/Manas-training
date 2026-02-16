package manasTrainingService.dto.tests;

import lombok.*;
import manasTrainingService.dto.certificate.StudentDto;
import manasTrainingService.dto.instance.CourseInstanceDTO;

import java.math.BigDecimal;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TestResultAdminDto {
    private Integer id;
    private StudentDto student;
    private TestInstanceDto testInstance;
    private CourseInstanceDTO courseInstance;
    private BigDecimal score;
    private BigDecimal percentage;
    private Boolean isPassed;
    private Integer timeSpentMinutes;
}
