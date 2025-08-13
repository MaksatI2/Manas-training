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

    @NotNull(message = "{applicationComment.applicationId.notnull}")
    private Integer applicationId;

    @NotBlank(message = "{applicationComment.comment.notblank}")
    private String comment;

    private String authorName;
    private LocalDateTime createdAt;
    private String formattedCreatedAt;
}
