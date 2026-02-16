package manasTrainingService.dto.certificate;

import lombok.*;
import manasTrainingService.entity.User;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StudentCertificatesDto {
    private User student;
    private List<CourseCertificateStatusDto> statusList;
}