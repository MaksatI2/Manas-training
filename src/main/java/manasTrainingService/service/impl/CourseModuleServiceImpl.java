package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseModuleCreationDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.exceptions.nsee.ModuleNotFoundException;
import manasTrainingService.repositories.CourseModuleRepository;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.CourseModuleService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseModuleServiceImpl implements CourseModuleService {

    private final CourseModuleRepository courseModuleRepository;
    private final CourseInstanceService courseInstanceService;

    @Transactional
    @Override
    public void createCourseModules(Integer courseInstanceId, List<CourseModuleCreationDTO> dtos) {
        CourseInstance courseInstance = courseInstanceService.getCourseInstanceModelById(courseInstanceId);

        List<CourseModule> modules = dtos.stream()
                .map(dto -> CourseModule.builder()
                        .courseInstance(courseInstance)
                        .title(dto.getTitle())
                        .durationHours(dto.getDurationHours())
                        .description(dto.getDescription())
                        .orderIndex(dto.getOrderIndex())
                        .isActive(dto.getIsActive())
                        .build())
                .collect(Collectors.toList());

        courseModuleRepository.saveAll(modules);
    }

    @Override
    public List<CourseModule> getModulesByCourseInstanceId(Integer courseInstanceId) {
        return courseModuleRepository.findByCourseInstanceId(courseInstanceId);
    }

    @Transactional
    public void deleteCourseModule(Integer moduleId) {
        if (!courseModuleRepository.existsById(moduleId)) {
            throw new IllegalArgumentException("CourseModule not found with id: " + moduleId);
        }
        courseModuleRepository.deleteById(moduleId);
    }

    @Override
    public CourseModule getCourseModuleById(Integer moduleId) {
        return courseModuleRepository.findById(moduleId).orElseThrow(() -> new ModuleNotFoundException("Модуль не был найден"));
    }

    @Override
    public CourseModuleDTO getCourseModuleDTOById(Integer moduleId) {
        return convertToDto(courseModuleRepository.findById(moduleId).orElseThrow(() -> new ModuleNotFoundException("Модуль не был найден")));
    }

    @Transactional(readOnly = true)
    @Override
    public List<CourseModuleDTO> findByCourseInstanceId(Integer courseInstanceId) {
        return courseModuleRepository.findByCourseInstanceIdOrderByOrderIndexAsc(courseInstanceId)
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    private CourseModuleDTO convertToDto(CourseModule module) {
        return CourseModuleDTO.builder()
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
                .build();
    }
}
