package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.create.CreateOrganizationDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.exceptions.nsee.OrganizationCodeNotFound;
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

    @Override
    public Organization getOrganizationById(int id){
        return organizationRepository.findById(id)
                .orElseThrow(() -> new OrganizationCodeNotFound("Организация с таким ID не найдена"));
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

    @Override
    public String getOrganizationName(Organization organization) {
        if (organization != null && organization.getUser() != null) {
            return organization.getUser().getName();
        }
        return null;
    }

    @Override
    public String getOrganizationNameByCode(String code) {
        Organization organization = getOrganizationByCode(code);
        return getOrganizationName(organization);
    }

    @Override
    public String getOrganizationNameById(int id) {
        Organization organization = getOrganizationById(id);
        return getOrganizationName(organization);
    }

}
