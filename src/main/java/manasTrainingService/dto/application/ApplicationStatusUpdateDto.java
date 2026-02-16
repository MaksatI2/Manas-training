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
    @NotNull(message = "{applicationStatusUpdate.newStatus.notnull}")
    private Status newStatus;

    @Size(max = 500, message = "{applicationStatusUpdate.comment.size}")
    private String comment;
}
