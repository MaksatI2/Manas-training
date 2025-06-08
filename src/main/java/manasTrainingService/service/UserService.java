package manasTrainingService.service;

import manasTrainingService.dto.OrganizationRegisterDto;
import manasTrainingService.dto.StudentRegisterDto;

public interface UserService {
    void registerOrganization(OrganizationRegisterDto organizationRegisterDto);

    void registerStudent(StudentRegisterDto studentRegisterDto);
}