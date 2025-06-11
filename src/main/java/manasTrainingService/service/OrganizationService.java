package manasTrainingService.service;

import manasTrainingService.dto.create.CreateOrganizationDto;
import manasTrainingService.dto.OrganizationProfileDto;
import manasTrainingService.dto.OrganizationProfileEditDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.User;

public interface OrganizationService {
    void createOrganization(CreateOrganizationDto dto);

    void editOrganizationInformation(OrganizationProfileEditDto organizationProfileEditDto);

    OrganizationProfileEditDto getOrganizationUserInformationForEdit(User user);

    Organization getOrganizationByCode(String code);

    Organization getOrganizationById(int id);

    OrganizationProfileDto getAuthorizedUserOrganization(User user);

    String getOrganizationName(Organization organization);
    String getOrganizationNameByCode(String code);
    String getOrganizationNameById(int id);
}