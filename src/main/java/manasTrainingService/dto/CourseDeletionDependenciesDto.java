package manasTrainingService.dto;

import java.util.List;

public record CourseDeletionDependenciesDto(
        List<ShortDto> applications,
        List<ShortDto> instances,
        List<ShortDto> teachers
) {
    public boolean hasAny() {
        return !applications.isEmpty() || !instances.isEmpty() || !teachers.isEmpty();
    }
}
