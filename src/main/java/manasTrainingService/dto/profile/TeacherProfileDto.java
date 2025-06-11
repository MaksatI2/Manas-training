package manasTrainingService.dto.profile;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import manasTrainingService.entity.User;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeacherProfileDto {
    private User teacher;
    private String department;
    private String qualifications;
    private String bio;
    private String avatarUrl;
}