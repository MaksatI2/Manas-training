package manasTrainingService.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseDto {

    private Integer id;

    @NotBlank(message = "Название обязательно")
    @Size(max = 200, message = "Максимум 200 символов")
    private String title;

    @NotBlank(message = "Код курса обязателен")
    @Size(max = 20, message = "Максимум 20 символов")
    private String code;

    @Size(max = 1000, message = "Максимум 1000 символов")
    private String description;

    @NotNull(message = "Продолжительность обязательна")
    @Min(value = 1, message = "Должно быть положительным числом")
    private Integer duration;

    private Boolean individual;

    private Boolean active;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private CourseCategoryDto category;

    @NotNull(message = "Категория обязательна")
    private Integer categoryId;

    @Builder.Default
    private Map<String, String> errors = new HashMap<>();

    public boolean hasErrors() {
        return errors != null && !errors.isEmpty();
    }

    public String getError(String fieldName) {
        return errors != null ? errors.get(fieldName) : null;
    }

    public void addError(String fieldName, String message) {
        if (errors == null) {
            errors = new HashMap<>();
        }
        errors.put(fieldName, message);
    }
}
