package manasTrainingService.dto.certificate;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CertificateShareDto {
    private Boolean isPublic;
    private String publicUrl;
    private String publicToken;
}
