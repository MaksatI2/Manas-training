package manasTrainingService.dto.tests;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudentTestListItemDto {
    private Integer testInstanceId;
    private String courseTitle;
    private String courseInstanceTitle;
    private String testTitle;
    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private String timeRange;
    private Boolean isActive;
    private Boolean isAvailable;
    private Boolean isEnded;
    private Boolean hasAttempt;
    private Boolean canStart;
    private Integer attemptCount;
    private Boolean hasPassedAttempt;
}
