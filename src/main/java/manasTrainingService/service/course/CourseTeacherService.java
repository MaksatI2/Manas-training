package manasTrainingService.service.course;

import manasTrainingService.dto.teacher.CourseTeacherDTO;

import java.util.List;

public interface CourseTeacherService {
    List<CourseTeacherDTO> getEligibleTeachersForCourseInstance(Integer courseInstanceId);

    List<CourseTeacherDTO> getCoursesByTeacherId(Integer teacherId);

    void updateTeacherCourses(Integer teacherId, List<Integer> courseIds);
}
