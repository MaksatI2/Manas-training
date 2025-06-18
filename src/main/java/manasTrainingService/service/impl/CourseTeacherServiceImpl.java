package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.teacher.CourseTeacherDTO;
import manasTrainingService.repositories.CourseTeacherRepository;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.CourseTeacherService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class CourseTeacherServiceImpl implements CourseTeacherService {

    private final CourseTeacherRepository repository;
    private final CourseInstanceService courseInstanceService;

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
}
