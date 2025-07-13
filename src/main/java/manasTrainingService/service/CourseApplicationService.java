package manasTrainingService.service;

import manasTrainingService.dto.application.*;
import manasTrainingService.dto.ShortDto;

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

    void updateApplicationForOrganization(Integer id, CourseApplicationCreateDto dto, String email);

    List<CourseApplicationViewDto> getAllApplicationsByStudent(String email);

    void createApplicationFromStudent(StudentCourseApplicationCreateDto dto, String email);

    void updateApplicationFromStudent(Integer id, StudentCourseApplicationCreateDto dto, String email);

    void deleteApplicationById(Integer id, String email);

}
