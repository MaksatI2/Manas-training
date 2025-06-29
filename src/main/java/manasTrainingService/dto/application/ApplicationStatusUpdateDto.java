package manasTrainingService.dto.application;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import manasTrainingService.entity.Status;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ApplicationStatusUpdateDto {
    @NotNull(message = "Новый статус обязателен")
    private Status newStatus;

    @Size(max = 500, message = "Комментарий не должен превышать 500 символов")
    private String comment;
}
