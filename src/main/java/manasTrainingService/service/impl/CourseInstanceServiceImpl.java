package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseInstanceCreationDTO;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.exceptions.nsee.CourseNotFoundException;
import manasTrainingService.repositories.CourseInstanceRepository;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.CourseService;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseInstanceServiceImpl implements CourseInstanceService {
    private final CourseInstanceRepository courseInstanceRepository;
    private final CourseService courseService;

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
                .orElseThrow(() -> new CourseNotFoundException("Course instance not found"));
        return convertToDto(course);
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
                                        .durationMinutes(lesson.getDurationMinutes())
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
                .build();
    }
}