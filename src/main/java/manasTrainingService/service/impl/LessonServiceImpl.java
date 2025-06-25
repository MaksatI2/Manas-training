package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.LessonCreateRequest;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.dto.lesson.LessonEditDto;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;
import manasTrainingService.exceptions.nsee.LessonNotFoundException;
import manasTrainingService.repositories.LessonRepository;
import manasTrainingService.service.LessonService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    public LessonDTO getLessonById(Integer lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId).orElseThrow(() -> new LessonNotFoundException("Урок не был найден"));
        return LessonDTO.builder()
                .title(lesson.getTitle())
                .description(lesson.getDescription())
                .durationMinutes(lesson.getDurationMinutes())
                .id(lesson.getId())
                .moduleId(lesson.getModule().getId())
                .build();
    }

    @Override
    public Lesson getLessonModelById(Integer lessonId) {
        return lessonRepository.findById(lessonId).orElseThrow(() -> new LessonNotFoundException("Урок не был найден"));
    }

    @Override
    public int getMinutesLeft(CourseModule module) {
        return module.getDurationHours() * 60 - lessonRepository.getTotalUsedMinutes(module.getId()) ;
    }

    @Override
    @Transactional
    public void deleteById(Integer lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new LessonNotFoundException("Урок не найден"));

        lesson.getSchedules().size();
        lesson.getMaterials().size();

        lessonRepository.delete(lesson);

    }


    @Override
    public LessonEditDto getLessonEditDto(Integer id) {
        Lesson lesson = getLessonModelById(id);
        return LessonEditDto.builder()
                .title(lesson.getTitle())
                .description(lesson.getDescription())
                .durationMinutes(lesson.getDurationMinutes())
                .build();
    }

    @Override
    public void updateLesson(Integer id, LessonEditDto dto) {
        Lesson lesson = getLessonModelById(id);

        CourseModule module = lesson.getModule();
        int usedMinutes = lessonRepository.getTotalUsedMinutes(module.getId());
        int moduleLimit = module.getDurationHours() * 60;
        int maxAllowed = moduleLimit - usedMinutes + lesson.getDurationMinutes();

        if (dto.getDurationMinutes() > maxAllowed) {
            throw new IllegalArgumentException("Превышено допустимое время модуля. Доступно максимум: " + maxAllowed + " минут.");
        }

        lesson.setTitle(dto.getTitle());
        lesson.setDescription(dto.getDescription());
        lesson.setDurationMinutes(dto.getDurationMinutes());
        lessonRepository.save(lesson);
    }

}
