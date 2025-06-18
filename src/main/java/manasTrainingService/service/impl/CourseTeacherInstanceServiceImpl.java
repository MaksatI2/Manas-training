package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.teacher.CourseInstanceTeacherDTO;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseInstanceTeacher;
import manasTrainingService.exceptions.nsee.UserNotFoundException;
import manasTrainingService.repositories.CourseInstanceTeacherRepository;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.CourseTeacherInstanceService;
import manasTrainingService.service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import manasTrainingService.entity.User;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseTeacherInstanceServiceImpl implements CourseTeacherInstanceService {

    private final CourseInstanceTeacherRepository repository;
    private final CourseInstanceService courseInstanceService;
    private final UserService userService;

    @Override
    public List<CourseInstanceTeacherDTO> getTeachersByCourseInstanceId(Integer courseInstanceId) {
        return repository.findByCourseInstanceId(courseInstanceId).stream()
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
                throw new IllegalArgumentException("Teacher already assigned to this course instance");
            }

            CourseInstanceTeacher entity = CourseInstanceTeacher.builder()
                    .courseInstance(courseInstance)
                    .teacher(teacher)
                    .isPrimary(false)
                    .build();

            repository.save(entity);
        }
    }

    @Transactional
    @Override
    public void deleteTeacher(Integer courseInstanceId, Integer teacherId) {
        CourseInstanceTeacher teacher = repository.findByCourseInstanceIdAndTeacherId(courseInstanceId, teacherId)
                .orElseThrow(() -> new UserNotFoundException("Teacher assignment not found"));
        repository.delete(teacher);
    }
}
