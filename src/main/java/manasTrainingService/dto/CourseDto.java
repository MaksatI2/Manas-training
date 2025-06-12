package manasTrainingService.dto;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseDto {
    private Integer id;
    private String title;
    private String code;
    private String description;
    private Integer duration;
    private CourseCategoryDto category;
}