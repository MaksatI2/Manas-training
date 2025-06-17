package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.CoursePlanDTO;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;
import manasTrainingService.exceptions.nsee.ModuleNotFoundException;
import manasTrainingService.repositories.CourseModuleRepository;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.CourseModuleService;
import manasTrainingService.service.LessonService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CourseModuleServiceImpl implements CourseModuleService {

    private final CourseModuleRepository courseModuleRepository;
    private final CourseInstanceService courseInstanceService;
    private final LessonService lessonService;

//    @Override
//    public void createCourseModules(CoursePlanDTO planDTO) {
//        CourseInstance courseInstance = courseInstanceService.getCourseInstanceById(planDTO.getCourseInstanceId());
//        Integer currentTotalDuration = courseModuleRepository.sumDurationHoursByCourseInstanceId(planDTO.getCourseInstanceId());
//        if (currentTotalDuration == null) currentTotalDuration = 0;
//
//        Integer newModulesDuration = planDTO.getModules().stream()
//                .mapToInt(CourseModuleDTO::getDurationHours)
//                .sum();
//
//        if (currentTotalDuration + newModulesDuration > courseInstance.getCourse().getDurationHours()) {
//            throw new IllegalArgumentException("Total module duration exceeds course duration");
//        }
//
//        for (CourseModuleDTO moduleDTO : planDTO.getModules()) {
//            CourseModule module = CourseModule.builder()
//                    .courseInstance(courseInstance)
//                    .title(moduleDTO.getTitle())
//                    .description(moduleDTO.getDescription())
//                    .durationHours(moduleDTO.getDurationHours())
//                    .orderIndex(moduleDTO.getOrderIndex())
//                    .build();
//            module = courseModuleRepository.save(module);
//
//            for (LessonDTO lessonDTO : moduleDTO.getLessons()) {
//                lessonService.createLesson(lessonDTO, module);
//            }
//        }
//    }

    @Override
    public List<CourseModule> getModulesByCourseInstanceId(Integer courseInstanceId) {
        return courseModuleRepository.findByCourseInstanceId(courseInstanceId);
    }

    @Override
    public CourseModule getCourseModuleById(Integer moduleId) {
        return courseModuleRepository.findById(moduleId).orElseThrow(() -> new ModuleNotFoundException("Модуль не был найден"));
    }
}
