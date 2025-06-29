package manasTrainingService.dto.application;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ApplicationCommentDto {
    private Integer id;

    @NotNull(message = "ID заявки обязателен")
    private Integer applicationId;

    @NotBlank(message = "Комментарий не может быть пустым")
    private String comment;

    private String authorName;
    private LocalDateTime createdAt;
    private String formattedCreatedAt;
}
