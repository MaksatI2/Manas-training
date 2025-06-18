package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.LessonCreateRequest;
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
    public Integer createLesson(LessonCreateRequest request, CourseModule module) {
        int usedMinutes = lessonRepository.getTotalUsedMinutes(module.getId());
        if (usedMinutes + request.getDurationMinutes() > module.getDurationHours() * 60) {
            throw new IllegalArgumentException("Превышено допустимое время модуля. " + (module.getDurationHours() * 60 - usedMinutes ));
        }
        Lesson lesson = Lesson.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .durationMinutes(request.getDurationMinutes())
                .module(module)
                .build();

        lessonRepository.save(lesson);

        return module.getCourseInstance().getId();
    }

    @Override
    public List<Lesson> getLessonsByModuleId(Integer moduleId) {
        return lessonRepository.findByModuleId(moduleId);
    }

    @Override
    public int getMinutesLeft(CourseModule module) {
        return module.getDurationHours() * 60 - lessonRepository.getTotalUsedMinutes(module.getId()) ;
    }
}
