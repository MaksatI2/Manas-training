package manasTrainingService.dto.instance;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CoursePlanDTO {
    private Integer courseInstanceId;
    private List<CourseModuleDTO> modules;
}