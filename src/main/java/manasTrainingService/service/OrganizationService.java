package manasTrainingService.service;

import manasTrainingService.dto.CreateOrganizationDto;
import manasTrainingService.entity.Organization;

public interface OrganizationService {
    void createOrganization(CreateOrganizationDto dto);

    Organization getOrganizationByCode(String code);
}