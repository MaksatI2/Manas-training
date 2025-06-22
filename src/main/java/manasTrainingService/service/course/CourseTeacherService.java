package manasTrainingService.service.course;

import manasTrainingService.dto.teacher.CourseTeacherDTO;

import java.util.List;

public interface CourseTeacherService {
    List<CourseTeacherDTO> getEligibleTeachersForCourseInstance(Integer courseInstanceId);
}
