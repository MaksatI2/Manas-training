package manasTrainingService.service.impl.course;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.teacher.CourseInstanceTeacherDTO;
import manasTrainingService.dto.teacher.TeacherCourseCardDTO;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseInstanceTeacher;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.exceptions.nsee.user.UserNotFoundException;
import manasTrainingService.repositories.course.CourseInstanceTeacherRepository;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseTeacherInstanceService;
import manasTrainingService.service.test.TestService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseTeacherInstanceServiceImpl implements CourseTeacherInstanceService {

    private final CourseInstanceTeacherRepository repository;
    private final CourseInstanceService courseInstanceService;
    private final UserService userService;
    private final TestService testService;

    @Override
    public List<CourseInstanceTeacherDTO> getTeachersByCourseInstanceId(Integer courseInstanceId) {
        return repository.findByCourseInstanceIdAndIsPrimaryTrue(courseInstanceId).stream()
                .map(teacher -> CourseInstanceTeacherDTO.builder()
                        .id(teacher.getId())
                        .teacherId(teacher.getTeacher().getId())
                        .teacherName(teacher.getTeacher().getName() + " "+ teacher.getTeacher().getLastName())
                        .isPrimary(teacher.getIsPrimary())
                        .createdAt(teacher.getCreatedAt())
                        .build())
                .collect(Collectors.toList());
    }

    @Transactional
    @Override
    public void addTeachers(Integer courseInstanceId, List<Integer> teacherIds) {
        CourseInstance courseInstance = courseInstanceService.getCourseInstanceModelById(courseInstanceId);

        for (Integer teacherId : teacherIds) {
            User teacher = userService.getUserById(teacherId);

            if (repository.existsByCourseInstanceIdAndTeacherId(courseInstanceId, teacherId)) {
                throw new IllegalArgumentException("Учитель уже был назначен на этот курс");
            }

            CourseInstanceTeacher entity = CourseInstanceTeacher.builder()
                    .courseInstance(courseInstance)
                    .teacher(teacher)
                    .isPrimary(true)
                    .build();

            repository.save(entity);
        }
    }

    @Transactional
    @Override
    public void deleteTeacher(Integer courseInstanceId, Integer teacherId) {
        CourseInstanceTeacher teacher = repository.findByCourseInstanceIdAndTeacherId(courseInstanceId, teacherId)
                .orElseThrow(() -> new UserNotFoundException("Назначение учителя не было найдено"));
        repository.delete(teacher);
    }

    @Override
    public List<TeacherCourseCardDTO> getTeacherCourses(Integer teacherId) {
        return repository.findByTeacherIdAndIsPrimaryTrue(teacherId).stream()
                .map(relation -> {
                    CourseInstance ci = relation.getCourseInstance();
                    return TeacherCourseCardDTO.builder()
                            .courseInstanceId(ci.getId())
                            .courseTitle(ci.getCourse().getTitle())
                            .instanceTitle(ci.getTitle())
                            .startDate(ci.getStartDate())
                            .endDate(ci.getEndDate())
                            .isPrimary(relation.getIsPrimary())
                            .courseTest(testService.getTestByCourseId(ci.getCourse().getId()))
                            .build();
                })
                .collect(Collectors.toList());
    }

    @Override
    public void hasAccess(Integer courseId) {
        User user = userService.getAuthorizedUser();
        if (!repository.existsByCourseInstanceIdAndTeacherIdAndIsPrimaryTrue(courseId, user.getId())) {
            throw new NoAccessException("У вас нет доступа к курсу");
        };
    }

    @Transactional
    @Override
    public void togglePrimary(Integer courseInstanceId, Integer teacherId) {
        CourseInstanceTeacher instance = repository
                .findByCourseInstanceIdAndTeacherId(courseInstanceId, teacherId)
                .orElseThrow(() -> new UserNotFoundException("Преподаватель не найден"));

        boolean currentPrimary = Boolean.TRUE.equals(instance.getIsPrimary());
        instance.setIsPrimary(!currentPrimary);
        repository.save(instance);
    }


}
