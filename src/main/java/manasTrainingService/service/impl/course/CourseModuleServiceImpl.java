package manasTrainingService.service.impl.course;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseModuleApiDto;
import manasTrainingService.dto.instance.CourseModuleCreationDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.CourseModuleUpdateDTO;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;
import manasTrainingService.exceptions.nsee.ModuleNotFoundException;
import manasTrainingService.repositories.course.CourseModuleRepository;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseModuleService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
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

        int existingModulesHours = courseInstance.getModules().stream()
                .mapToInt(m -> m.getDurationHours() != null ? m.getDurationHours() : 0)
                .sum();

        int newModulesHours = dtos.stream()
                .mapToInt(dto -> dto.getDurationHours() != null ? dto.getDurationHours() : 0)
                .sum();

        int totalHoursAfterAdd = existingModulesHours + newModulesHours;

        validateTotalDuration(courseInstance, null, totalHoursAfterAdd);

        int currentMaxOrder = courseInstance.getModules().stream()
                .mapToInt(CourseModule::getOrderIndex)
                .max()
                .orElse(-1);

        List<CourseModule> modules = new ArrayList<>();
        for (int i = 0; i < dtos.size(); i++) {
            CourseModuleCreationDTO dto = dtos.get(i);
            CourseModule module = CourseModule.builder()
                    .courseInstance(courseInstance)
                    .title(dto.getTitle())
                    .durationHours(dto.getDurationHours())
                    .description(dto.getDescription())
                    .orderIndex(currentMaxOrder + i + 1)
                    .isActive(true)
                    .build();
            modules.add(module);
        }

        courseModuleRepository.saveAll(modules);
    }

    @Transactional
    public void deleteCourseModule(Integer moduleId) {
        if (!courseModuleRepository.existsById(moduleId)) {
            throw new IllegalArgumentException("Модуль не был найден: " + moduleId);
        }
        courseModuleRepository.deleteById(moduleId);
    }

    @Override
    public CourseModule getCourseModuleById(Integer moduleId) {
        return courseModuleRepository.findById(moduleId).orElseThrow(() -> new ModuleNotFoundException("Модуль не был найден"));
    }

    private CourseModuleDTO convertToDto(CourseModule module) {
        return CourseModuleDTO.builder()
                .id(module.getId())
                .title(module.getTitle())
                .durationHours(module.getDurationHours())
                .description(module.getDescription())
                .orderIndex(module.getOrderIndex())
                .courseInstanceId(module.getCourseInstance().getId())
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

    @Override
    public List<CourseModuleApiDto> getModuleApiDtosByCourseInstanceId(Integer courseInstanceId) {
        return courseModuleRepository.findByCourseInstanceIdOrderByOrderIndexAsc(courseInstanceId).stream()
                .map(module -> {
                    CourseModuleApiDto dto = new CourseModuleApiDto();
                    dto.setTitle(module.getTitle());
                    dto.setDurationHours(module.getDurationHours());
                    dto.setOrderIndex(module.getOrderIndex());
                    return dto;
                })
                .collect(Collectors.toList());
    }

    @Override
    public void deleteByIdIfNoLessons(Integer moduleId) {
        CourseModule module = getCourseModuleById(moduleId);
        if (!module.getLessons().isEmpty()) {
            throw new IllegalStateException("У модуля есть уроки");
        }
        courseModuleRepository.deleteById(moduleId);
    }

    @Override
    public CourseModuleUpdateDTO getModuleForUpdate(Integer moduleId) {
        CourseModule module = getCourseModuleById(moduleId);
        CourseModuleUpdateDTO updateDTO = new CourseModuleUpdateDTO();
        updateDTO.setTitle(module.getTitle());
        updateDTO.setDurationHours(module.getDurationHours());
        updateDTO.setDescription(module.getDescription());
        return updateDTO;
    }

    @Override
    public void updateModule(Integer moduleId, CourseModuleUpdateDTO dto) {
        CourseModule module = getCourseModuleById(moduleId);
        CourseInstance courseInstance = module.getCourseInstance();
        List<Lesson> lessons = module.getLessons();
        int totalLessonMinutes = lessons.stream()
                .mapToInt(Lesson::getDurationMinutes)
                .sum();

        int newModuleMinutes = dto.getDurationHours() * 60;

        if (totalLessonMinutes > newModuleMinutes) {
            throw new IllegalStateException(
                    "Изменение невозможно " +
                            "новая продолжительность модуля (" + newModuleMinutes + " мин) меньше общего времени уроков " + totalLessonMinutes + "."
            );
        }

        int totalOtherModulesHours = courseInstance.getModules().stream()
                .filter(m -> !m.getId().equals(moduleId))
                .mapToInt(m -> m.getDurationHours() != null ? m.getDurationHours() : 0)
                .sum();
        int totalAfterUpdate = totalOtherModulesHours + (dto.getDurationHours() != null ? dto.getDurationHours() : 0);

        validateTotalDuration(courseInstance, moduleId, totalAfterUpdate);

        module.setTitle(dto.getTitle());
        module.setDurationHours(dto.getDurationHours());
        module.setDescription(dto.getDescription());
        courseModuleRepository.save(module);
    }

    private void validateTotalDuration(CourseInstance courseInstance, Integer updatingModuleId, int totalNewDuration) {
        int maxAllowedHours = courseInstance.getCourse().getDurationHours();
        if (totalNewDuration > maxAllowedHours) {
            throw new IllegalStateException(
                    "Общее количество часов модулей (" + totalNewDuration + ") " +
                            "превышает лимит курса (" + maxAllowedHours + ")."
            );
        }
    }

    @Override
    public CourseModuleDTO getCourseModuleDTOById(Integer moduleId) {
        return convertToDto(courseModuleRepository.findById(moduleId).orElseThrow(() -> new ModuleNotFoundException("Модуль не был найден")));
    }
}
