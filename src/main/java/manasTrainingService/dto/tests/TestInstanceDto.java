package manasTrainingService.dto.tests;

import jakarta.validation.constraints.NotNull;
import lombok.*;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TestInstanceDto {
    private Integer id;
    private Integer testId;
    private TestDto test;
    private Integer courseInstanceId;
    private CourseInstanceDTO courseInstance;

    @NotNull(message = "{TestInstanceDto.startDate.NotNull}")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate startDate;

    @NotNull(message = "{TestInstanceDto.startTime.NotNull}")
    private LocalTime startTime;

    @NotNull(message = "{TestInstanceDto.endDate.NotNull}")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate endDate;

    @NotNull(message = "{TestInstanceDto.endTime.NotNull}")
    private LocalTime endTime;

    private Boolean isEnded;
}
