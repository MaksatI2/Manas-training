package manasTrainingService.dto.tests;

import jakarta.validation.constraints.NotNull;
import lombok.*;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;
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
    @NotNull(message = "Дата обязательна для заполнения")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate startDate;
    @NotNull(message = "Время обязательно для заполнения")
    private LocalTime startTime;

    @NotNull(message = "Дата обязательна для заполнения")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate endDate;
    @NotNull(message = "Время обязательно для заполнения")
    private LocalTime endTime;
    private Boolean isEnded;
}
