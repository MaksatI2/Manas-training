package manasTrainingService.service.impl.course;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseInstanceCreationDTO;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.instance.CourseInstanceUpdateDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;
import manasTrainingService.exceptions.nsee.course.CourseNotFoundException;
import manasTrainingService.repositories.course.CourseInstanceRepository;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.LessonService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseInstanceServiceImpl implements CourseInstanceService {
    private final CourseInstanceRepository courseInstanceRepository;
    private final CourseService courseService;
    private final LessonService lessonService;

    @Override
    public Integer createCourseInstance(CourseInstanceCreationDTO dto) {
        Course course = courseService.getCourseById(dto.getCourseId());
        CourseInstance courseInstance = CourseInstance.builder()
                .course(course)
                .title(dto.getTitle())
                .startDate(dto.getStartDate().atStartOfDay())
                .endDate(dto.getEndDate().atStartOfDay())
                .isActive(dto.getIsActive())
                .build();
        return courseInstanceRepository.save(courseInstance).getId();
    }

    @Override
    public List<CourseInstanceDTO> findAll() {
        return courseInstanceRepository.findAll().stream()
                .map(this::convertToDtoForList)
                .collect(Collectors.toList());
    }


    private CourseInstanceDTO convertToDtoForList(CourseInstance courseInstance) {
        return CourseInstanceDTO.builder()
                .id(courseInstance.getId())
                .title(courseInstance.getTitle())
                .startDate(courseInstance.getStartDate().toLocalDate())
                .endDate(courseInstance.getEndDate().toLocalDate())
                .durationHours(courseInstance.getCourse().getDurationHours())
                .isActive(courseInstance.getIsActive())
                .build();
    }

    @Override
    public CourseInstanceDTO getCourseInstanceById(Integer id) {
        CourseInstance course =  courseInstanceRepository.findById(id)
                .orElseThrow(() -> new CourseNotFoundException("Поток курса не был найден"));
        return convertToDto(course);
    }

    @Override
    public CourseInstance getCourseInstanceModelById(Integer id) {
        return courseInstanceRepository.findById(id)
                .orElseThrow(() -> new CourseNotFoundException("Поток курса не был найден"));
    }

    private CourseInstanceDTO convertToDto(CourseInstance courseInstance) {
        var moduleDtos = courseInstance.getModules().stream()
                .filter(CourseModule::getIsActive)
                .sorted(Comparator.comparing(CourseModule::getOrderIndex))
                .map(module -> CourseModuleDTO.builder()
                        .id(module.getId())
                        .title(module.getTitle())
                        .durationHours(module.getDurationHours())
                        .description(module.getDescription())
                        .orderIndex(module.getOrderIndex())
                        .lessons(module.getLessons().stream()
                                .map(lesson -> LessonDTO.builder()
                                        .id(lesson.getId())
                                        .title(lesson.getTitle())
                                        .description(lesson.getDescription())
                                        .build())
                                .collect(Collectors.toList()))
                        .build())
                .collect(Collectors.toList());

        return CourseInstanceDTO.builder()
                .id(courseInstance.getId())
                .title(courseInstance.getTitle())
                .startDate(courseInstance.getStartDate().toLocalDate())
                .endDate(courseInstance.getEndDate().toLocalDate())
                .isActive(courseInstance.getIsActive())
                .modules(moduleDtos)
                .durationHours(courseInstance.getCourse().getDurationHours())
                .courseId(courseInstance.getCourse().getId())
                .build();
    }

    @Override
    public CourseInstanceDTO getCourseInstanceByLessonId(Integer lessonId) {
        Lesson lesson = lessonService.getLessonModelById(lessonId);
        CourseInstance instance = lesson.getModule().getCourseInstance();
        return convertToDto(instance);
    }

    @Override
    public CourseInstanceUpdateDTO getUpdateDtoById(Integer id) {
        CourseInstance instance = courseInstanceRepository.findById(id)
                .orElseThrow(() -> new CourseNotFoundException("Поток курса не найден"));

        return CourseInstanceUpdateDTO.builder()
                .id(instance.getId())
                .title(instance.getTitle())
                .startDate(instance.getStartDate().toLocalDate())
                .endDate(instance.getEndDate().toLocalDate())
                .isActive(instance.getIsActive())
                .build();
    }

    @Override
    public void updateCourseInstance(Integer id, CourseInstanceUpdateDTO dto) {
        CourseInstance instance = courseInstanceRepository.findById(id)
                .orElseThrow(() -> new CourseNotFoundException("Поток курса не найден"));

        instance.setTitle(dto.getTitle());
        instance.setStartDate(dto.getStartDate().atStartOfDay());
        instance.setEndDate(dto.getEndDate().atTime(23, 59));
        instance.setIsActive(Boolean.TRUE.equals(dto.getIsActive()));
        instance.setUpdatedAt(LocalDateTime.now());

        courseInstanceRepository.save(instance);
    }

    @Override
    public void deleteCourseInstance(Integer id) {
        CourseInstance instance = courseInstanceRepository.findById(id)
                .orElseThrow(() -> new CourseNotFoundException("Поток курса не найден"));
        if (!instance.getModules().isEmpty()) {
            throw new IllegalArgumentException("Невозможно удаление курса, у него есть модули");
        }

        courseInstanceRepository.deleteById(id);
    }

}