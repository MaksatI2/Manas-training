package manasTrainingService.service;

import manasTrainingService.dto.teacher.CourseInstanceTeacherDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface CourseTeacherInstanceService {
    List<CourseInstanceTeacherDTO> getTeachersByCourseInstanceId(Integer courseInstanceId);

    @Transactional
    void addTeachers(Integer courseInstanceId, List<Integer> teacherIds);

    @Transactional
    void deleteTeacher(Integer courseInstanceId, Integer teacherId);
}
