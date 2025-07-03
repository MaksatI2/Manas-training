package manasTrainingService.service.impl.course;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.teacher.CourseTeacherDTO;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseTeacher;
import manasTrainingService.entity.User;
import manasTrainingService.repositories.course.CourseTeacherRepository;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.course.CourseTeacherService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class CourseTeacherServiceImpl implements CourseTeacherService {

    private final CourseTeacherRepository repository;
    private final CourseInstanceService courseInstanceService;
    private final UserService userService;
    private final CourseService courseService;

    @Override
    public List<CourseTeacherDTO> getEligibleTeachersForCourseInstance(Integer courseInstanceId) {
        Integer courseId = courseInstanceService.getCourseInstanceById(courseInstanceId).getCourseId();

        return repository.findByCourseId(courseId).stream()
                .map(teacher -> CourseTeacherDTO.builder()
                        .id(teacher.getId())
                        .teacherId(teacher.getTeacher().getId())
                        .teacherName(teacher.getTeacher().getName() + " " + teacher.getTeacher().getLastName())
                        .createdAt(teacher.getCreatedAt())
                        .build())
                .collect(Collectors.toList());
    }

    @Override
    public List<CourseTeacherDTO> getCoursesByTeacherId(Integer teacherId) {
        return repository.findAllByTeacherId(teacherId).stream()
                .map(ct -> CourseTeacherDTO.builder()
                        .id(ct.getId())
                        .teacherId(ct.getTeacher().getId())
                        .teacherName(ct.getTeacher().getName() + " " + ct.getTeacher().getLastName())
                        .createdAt(ct.getCreatedAt())
                        .courseId(ct.getCourse().getId())
                        .courseTitle(ct.getCourse().getTitle())
                        .courseCode(ct.getCourse().getCode())
                        .isActive(ct.getCourse().getIsActive())
                        .assignedAt(ct.getCreatedAt())
                        .build())
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void updateTeacherCourses(Integer teacherId, List<Integer> courseIds) {
        repository.deleteByTeacherId(teacherId);

        List<CourseTeacher> list = repository.findAllByTeacherId(teacherId);
        User teacher = userService.getUserById(teacherId);

        for (Integer courseId : courseIds) {
            Course course = courseService.getCourseById(courseId);
            CourseTeacher ct = CourseTeacher.builder()
                    .teacher(teacher)
                    .course(course)
                    .build();
            repository.save(ct);

        }

    }


}
