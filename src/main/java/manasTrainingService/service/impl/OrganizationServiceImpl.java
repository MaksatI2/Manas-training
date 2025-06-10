package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CreateOrganizationDto;
import manasTrainingService.dto.OrganizationProfileDto;
import manasTrainingService.dto.OrganizationProfileEditDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.OrganizationCodeNotFound;
import manasTrainingService.exceptions.nsee.OrganizationNotFoundException;
import manasTrainingService.repositories.OrganizationRepository;
import manasTrainingService.service.OrganizationService;
import manasTrainingService.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrganizationServiceImpl implements OrganizationService {

    private final OrganizationRepository organizationRepository;
    private UserService userService;

    @Autowired
    public void setUserService(@Lazy UserService userService) {
        this.userService = userService;
    }

    @Override
    public void createOrganization(CreateOrganizationDto dto){
        Organization organization = Organization.builder()
                .user(dto.getUser())
                .code(generateOrganizationCode())
                .build();
        organizationRepository.save(organization);
    }

    @Override
    public void editOrganizationInformation(OrganizationProfileEditDto organizationProfileEditDto){
        Organization organization = organizationRepository.findByUserId(organizationProfileEditDto.getUserId())
                .orElseThrow(() -> new OrganizationNotFoundException("Организация не найдена"));
        organization.setDescription(organizationProfileEditDto.getOrganizationName());
        userService.editManagerInformation(organizationProfileEditDto);
    }

    @Override
    public OrganizationProfileEditDto getOrganizationUserInformationForEdit(User user){
        return OrganizationProfileEditDto.builder()
                .userId(user.getId())
                .name(user.getName())
                .surname(user.getLastName())
                .phone(user.getPhone())
                .organizationName(organizationRepository.findByUserId(user.getId()).get().getDescription())
                .build();
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

    @Override
    public OrganizationProfileDto getAuthorizedUserOrganization(User user){
        return OrganizationProfileDto.builder()
                .user(user)
                .organization(organizationRepository.findByUserId(user.getId()).orElseThrow(() -> new OrganizationNotFoundException("Организация не найдена")))
                .build();
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
