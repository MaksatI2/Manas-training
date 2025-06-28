package manasTrainingService.dto.tests;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
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
    @NotBlank(message = "Название теста обязательно для заполнения")
    private String title;
    @NotBlank(message = "Краткое описание теста обязательно для заполнения")
    private String description;
    @NotNull(message = "Укажите минимальныйпроходной балл")
    @Min(value = 0, message = "Проходной балл не может быть меньше нуля")
    @Max(value = 100, message = "Проходной балл не может быть больше 100")
    private Integer passingScore;

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

    private Boolean isActive;
    @Valid
    private List<QuestionDto> questions = new ArrayList<>();
}
