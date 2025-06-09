package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CreateOrganizationDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.exceptions.OrganizationCodeNotFound;
import manasTrainingService.repositories.OrganizationRepository;
import manasTrainingService.service.OrganizationService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrganizationServiceImpl implements OrganizationService {

    private final OrganizationRepository organizationRepository;

    @Override
    public void createOrganization(CreateOrganizationDto dto){
        Organization organization = Organization.builder()
                .user(dto.getUser())
                .code(generateOrganizationCode())
                .build();
        organizationRepository.save(organization);
    }

    @Override
    public Organization getOrganizationByCode(String code){
        return organizationRepository.findByCode(code)
                .orElseThrow(() -> new OrganizationCodeNotFound("Организация с таким кодом не найдена"));
    }

    private String generateOrganizationCode() {
        int maxAttempts = 10000;
        for (int i = 1; i <= maxAttempts; i++) {
            String code = String.format("ORG%04d", i);
            if (!organizationRepository.findByCode(code).isPresent()) {
                return code;
            }
        }
        throw new IllegalStateException("Не удалось сгенерировать уникальный код организации");
    }

}
