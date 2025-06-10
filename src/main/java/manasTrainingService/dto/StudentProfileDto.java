package manasTrainingService.dto;

import jakarta.persistence.Column;
import lombok.*;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.User;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StudentProfileDto {
    private User student;
    private Organization organization;
    private String organizationName;
    private String specialization;
}