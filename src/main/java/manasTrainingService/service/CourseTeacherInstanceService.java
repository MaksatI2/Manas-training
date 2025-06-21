package manasTrainingService.service;

import manasTrainingService.dto.teacher.CourseInstanceTeacherDTO;
import manasTrainingService.dto.teacher.TeacherCourseCardDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface CourseTeacherInstanceService {
    List<CourseInstanceTeacherDTO> getTeachersByCourseInstanceId(Integer courseInstanceId);

    @Transactional
    void addTeachers(Integer courseInstanceId, List<Integer> teacherIds);

    @Transactional
    void deleteTeacher(Integer courseInstanceId, Integer teacherId);

    List<TeacherCourseCardDTO> getTeacherCourses(Integer teacherId);

    void hasAccess(Integer courseId);

    @Transactional
    void togglePrimary(Integer courseInstanceId, Integer teacherId);
}
