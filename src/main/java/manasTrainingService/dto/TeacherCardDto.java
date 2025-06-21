package manasTrainingService.dto;

import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TeacherCardDto {
    private Long id;
    private String fullName;
    private String avatarUrl;
    private String department;
    private String email;
    private String phone;
}
