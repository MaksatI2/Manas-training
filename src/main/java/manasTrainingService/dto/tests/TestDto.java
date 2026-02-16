package manasTrainingService.dto.tests;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import manasTrainingService.dto.CourseDto;
import org.aspectj.bridge.IMessage;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TestDto {
    private Integer id;
    private Integer courseInstanceId;
    private CourseDto course;
    @NotBlank(message = "{TestDto.title.NotBlank}")
    private String title;

    @NotBlank(message = "{TestDto.description.NotBlank}")
    private String description;

    @NotNull(message = "{TestDto.passingScore.NotNull}")
    @Min(value = 0, message = "{TestDto.passingScore.Min}")
    @Max(value = 100, message = "{TestDto.passingScore.Max}")
    private Integer passingScore;

    private Boolean isActive;
    @Valid
    private List<QuestionDto> questions = new ArrayList<>();
}
