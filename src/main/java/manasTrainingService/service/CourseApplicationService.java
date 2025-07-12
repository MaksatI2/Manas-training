package manasTrainingService.service;

import manasTrainingService.dto.ShortDto;
import manasTrainingService.dto.application.ApplicationCommentDto;
import manasTrainingService.dto.application.ApplicationStatusUpdateDto;
import manasTrainingService.dto.application.CourseApplicationCreateDto;
import manasTrainingService.dto.application.CourseApplicationViewDto;

import java.util.List;

public interface CourseApplicationService {
    void createApplicationForOrganization(CourseApplicationCreateDto dto, String email);

    List<CourseApplicationViewDto> getApplicationsForOrganization(String email);

    CourseApplicationViewDto getApplicationDetails(Integer applicationId, String email);

    List<CourseApplicationViewDto> getAllApplicationsForAdmin();

    CourseApplicationViewDto getApplicationDetailsForAdmin(Integer applicationId);

    void updateApplicationStatus(Integer applicationId, ApplicationStatusUpdateDto dto, String adminEmail);

    void addCommentToApplication(Integer applicationId, String comment, String authorEmail);

    List<ApplicationCommentDto> getCommentsForApplication(Integer applicationId);

    List<ShortDto> getByCourseId(Integer courseId);
}
