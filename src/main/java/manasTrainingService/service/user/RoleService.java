package manasTrainingService.service.user;

import manasTrainingService.entity.Role;

import java.util.List;

public interface RoleService {
    Role getCompanyTypeId();

    Role getStudentRoleId();

    Role getTeacherRoleId();

    List<String> getAllRoles();
}