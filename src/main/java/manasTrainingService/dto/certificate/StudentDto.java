package manasTrainingService.dto.certificate;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StudentDto {
    private Integer id;
    private String name;
    private String lastName;
    private String email;
    private int completedCoursesCount;
}