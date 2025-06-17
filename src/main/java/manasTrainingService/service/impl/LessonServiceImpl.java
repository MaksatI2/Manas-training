package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;
import manasTrainingService.repositories.LessonRepository;
import manasTrainingService.service.LessonService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class LessonServiceImpl implements LessonService {

    private final LessonRepository lessonRepository;

    @Override
    public Lesson createLesson(LessonDTO dto, CourseModule module) {
        Integer currentTotalDuration = lessonRepository.sumDurationMinutesByModuleId(dto.getModuleId());
        if (currentTotalDuration == null) currentTotalDuration = 0;

        if (currentTotalDuration + dto.getDurationMinutes() > module.getDurationHours() * 60) {
            throw new IllegalArgumentException("Total lesson duration exceeds module duration");
        }

        Lesson lesson = Lesson.builder()
                .module(module)
                .title(dto.getTitle())
                .description(dto.getDescription())
                .durationMinutes(dto.getDurationMinutes())
                .build();
        return lessonRepository.save(lesson);
    }

    @Override
    public List<Lesson> getLessonsByModuleId(Integer moduleId) {
        return lessonRepository.findByModuleId(moduleId);
    }
}
