package manasTrainingService.service;

import manasTrainingService.dto.teacher.CourseTeacherDTO;

import java.util.List;

public interface CourseTeacherService {
    List<CourseTeacherDTO> getEligibleTeachersForCourseInstance(Integer courseInstanceId);
}
