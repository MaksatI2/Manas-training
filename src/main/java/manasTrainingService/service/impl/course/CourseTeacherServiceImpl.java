package manasTrainingService.service.impl.course;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.ShortDto;
import manasTrainingService.dto.teacher.CourseTeacherDTO;
import manasTrainingService.entity.*;
import manasTrainingService.repositories.course.CourseTeacherRepository;
import manasTrainingService.service.ActivityLogService;
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
    private final ActivityLogService activityLogService;

    @Override
    public List<CourseTeacherDTO> getEligibleTeachersForCourseInstance(Integer courseInstanceId) {
        Integer courseId = courseInstanceService.getCourseInstanceById(courseInstanceId).getCourseId();

        List<CourseTeacher> eligibleTeachers = repository.findEligibleTeachers(courseId, courseInstanceId);

        return eligibleTeachers.stream()
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
        repository.findAllByTeacherId(teacherId).forEach(ct ->
                activityLogService.log(
                        userService.getAuthorizedUser(),
                        ActionType.DELETE,
                        TargetType.COURSE_TEACHER,
                        ct.getId()
                )
        );
        repository.deleteByTeacherId(teacherId);

        User teacher = userService.getUserById(teacherId);
        for (Integer courseId : courseIds) {
            Course course = courseService.getCourseById(courseId);
            CourseTeacher ct = CourseTeacher.builder()
                    .teacher(teacher)
                    .course(course)
                    .build();
            CourseTeacher saved = repository.save(ct);
            activityLogService.log(
                    userService.getAuthorizedUser(),
                    ActionType.CREATE,
                    TargetType.COURSE_TEACHER,
                    saved.getId()
            );
        }

    }

    @Override
    public List<ShortDto> getByCourseId(Integer courseId) {
        return repository.findByCourseId(courseId)
                .stream()
                .map(ct -> new ShortDto(ct.getId(), ct.getTeacher().getName()))
                .toList();
    }


}
