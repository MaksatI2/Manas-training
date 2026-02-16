package manasTrainingService.service.user;

import manasTrainingService.dto.application.EmployeeShortDto;
import manasTrainingService.dto.create.CreateOrganizationDto;
import manasTrainingService.dto.edit.OrganizationProfileEditDto;
import manasTrainingService.dto.organization.CreateStudentByOrganizationDto;
import manasTrainingService.dto.organization.StudentCourseInfoDto;
import manasTrainingService.dto.organization.StudentEditByOrganizationDto;
import manasTrainingService.dto.profile.OrganizationProfileDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.User;

import java.util.List;
import java.util.Optional;

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

    List<StudentCourseInfoDto> getStudentsCourseInfoForOrganization(User organizationUser);

    void editStudentProfileByOrganization(StudentEditByOrganizationDto dto);

    void removeStudentFromCourse(Integer enrollmentId, User organizationUser);

    void deleteStudentFromOrganization(Integer studentId, User organizationUser);

    void createStudentByOrganization(CreateStudentByOrganizationDto dto, User organizationUser);

    void attachStudentToOrganization(Integer studentId, User organizationUser);

    List<EmployeeShortDto> getMyEmployees(String email);

    OrganizationProfileDto getAuthorizedUserOrganizationByEmail(String email);

    List<EmployeeShortDto> getAllTeachersShortDto();


    Organization getByUserId(Integer userId);
}