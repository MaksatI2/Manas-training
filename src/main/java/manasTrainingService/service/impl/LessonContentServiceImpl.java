package manasTrainingService.service.impl;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.lesson.LessonContentDTO;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.Lesson;
import manasTrainingService.entity.LessonContent;
import manasTrainingService.entity.TargetType;
import manasTrainingService.repositories.LessonContentRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.LessonContentService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class LessonContentServiceImpl implements LessonContentService {

    private final LessonContentRepository lessonContentRepository;
    private final ActivityLogService activityLogService;
    private final UserService userService;

    @Override
    public Optional<LessonContentDTO> getContentByLessonId(Integer lessonId) {
        return lessonContentRepository.findByLessonId(lessonId)
                .map(this::toDTO);
    }

    @Override
    @Transactional
    public void saveOrUpdateContent(Lesson lesson, LessonContentDTO contentDTO) {
        Optional<LessonContent> optionalContent = lessonContentRepository.findByLessonId(lesson.getId());

        LessonContent content = optionalContent.orElseGet(() -> {
            LessonContent newContent = new LessonContent();
            newContent.setLesson(lesson);
            return newContent;
        });

        content.setTitle(contentDTO.getTitle());
        content.setContent(contentDTO.getContent());

        LessonContent saved = lessonContentRepository.save(content);

        activityLogService.log(
                userService.getAuthorizedUser(),
                optionalContent.isPresent() ? ActionType.UPDATE : ActionType.CREATE,
                TargetType.LESSON_CONTENT,
                saved.getId()
        );
    }

    private LessonContentDTO toDTO(LessonContent content) {
        LessonContentDTO dto = new LessonContentDTO();
        dto.setTitle(content.getTitle());
        dto.setContent(content.getContent());
        return dto;
    }
}
