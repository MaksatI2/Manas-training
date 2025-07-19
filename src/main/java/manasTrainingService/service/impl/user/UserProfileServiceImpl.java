package manasTrainingService.service.impl.user;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.statistics.UserProfileDetailsDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.User;
import manasTrainingService.service.user.OrganizationService;
import manasTrainingService.service.user.UserProfileService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserProfileServiceImpl implements UserProfileService {

    private final UserService userService;
    private final OrganizationService organizationService;

    @Override
    public UserProfileDetailsDto getProfileDetails(Integer userId) {
        User user = userService.getUserById(userId);
        String roleName = user.getRole().getName();
        UserProfileDetailsDto.UserProfileDetailsDtoBuilder builder = UserProfileDetailsDto.builder()
                .user(user);


        switch (roleName.toUpperCase()) {
            case "STUDENT" -> {
                if (user.getStudentProfile() != null) {
                    var student = user.getStudentProfile();
                    builder.organizationName(student.getOrganization().getUser().getName());
                    builder.specialization(student.getSpecialization());
                }
            }
            case "TEACHER" -> {
                if (user.getTeacherProfile() != null) {
                    var teacher = user.getTeacherProfile();
                    builder.department(teacher.getDepartment());
                    builder.qualifications(teacher.getQualifications());
                    builder.bio(teacher.getBio());
                }
            }
            case "ORGANIZATION" -> {
                Organization org = organizationService.getByUserId(user.getId());
                builder.organization(org);
            }
        }
        return builder.build();
    }
}
