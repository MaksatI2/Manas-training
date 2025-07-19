package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.LessonCreateRequest;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.dto.lesson.LessonEditDto;
import manasTrainingService.dto.quiz.LessonQuizDto;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;
import manasTrainingService.entity.TargetType;
import manasTrainingService.exceptions.nsee.LessonNotFoundException;
import manasTrainingService.repositories.LessonRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.quiz.LessonQuizService;
import manasTrainingService.service.user.UserService;
import org.hibernate.Hibernate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.swing.text.html.Option;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class LessonServiceImpl implements LessonService {

    private final LessonRepository lessonRepository;
    private final ActivityLogService activityLogService;
    private final UserService userService;

    @Override
    public Integer createLesson(LessonCreateRequest request, CourseModule module) {

        Lesson lesson = Lesson.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .module(module)
                .build();

        Lesson saved = lessonRepository.save(lesson);

        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.CREATE,
                TargetType.LESSON,
                saved.getId()
        );

        return module.getCourseInstance().getId();
    }

    @Override
    public LessonDTO getLessonById(Integer lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId).orElseThrow(() -> new LessonNotFoundException("Урок не был найден"));
        LessonQuizDto quizDto = null;
        if (lesson.getLessonQuiz() != null) {
            quizDto = LessonQuizDto.builder()
                    .id(lesson.getLessonQuiz().getId())
                    .title(lesson.getLessonQuiz().getTitle())
                    .description(lesson.getLessonQuiz().getDescription())
                    .isActive(lesson.getLessonQuiz().getIsActive())
                    .build();
        }
        return LessonDTO.builder()
                .title(lesson.getTitle())
                .description(lesson.getDescription())
                .id(lesson.getId())
                .quiz(quizDto)
                .moduleId(lesson.getModule().getId())
                .build();
    }

    @Override
    public Lesson getLessonModelById(Integer lessonId) {
        return lessonRepository.findById(lessonId).orElseThrow(() -> new LessonNotFoundException("Урок не был найден"));
    }


    @Override
    @Transactional
    public void deleteById(Integer lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new LessonNotFoundException("Урок не найден"));

        Hibernate.initialize(lesson.getSchedules());
        Hibernate.initialize(lesson.getMaterials());
        Hibernate.initialize(lesson.getLessonQuiz());

        CourseModule module = lesson.getModule();
        module.getLessons().remove(lesson);

        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.DELETE,
                TargetType.LESSON,
                lessonId
        );

        lessonRepository.delete(lesson);
    }


    @Override
    public LessonEditDto getLessonEditDto(Integer id) {
        Lesson lesson = getLessonModelById(id);
        return LessonEditDto.builder()
                .title(lesson.getTitle())
                .description(lesson.getDescription())
                .build();
    }

    @Override
    public void updateLesson(Integer id, LessonEditDto dto) {
        Lesson lesson = getLessonModelById(id);


        lesson.setTitle(dto.getTitle());
        lesson.setDescription(dto.getDescription());

        Lesson saved = lessonRepository.save(lesson);

        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.LESSON,
                saved.getId()
        );
    }

}
