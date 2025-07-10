package manasTrainingService.service.impl;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.lesson.LessonContentDTO;
import manasTrainingService.entity.Lesson;
import manasTrainingService.entity.LessonContent;
import manasTrainingService.repositories.LessonContentRepository;
import manasTrainingService.service.LessonContentService;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class LessonContentServiceImpl implements LessonContentService {

    private final LessonContentRepository lessonContentRepository;

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

        lessonContentRepository.save(content);
    }

    private LessonContentDTO toDTO(LessonContent content) {
        LessonContentDTO dto = new LessonContentDTO();
        dto.setTitle(content.getTitle());
        dto.setContent(content.getContent());
        return dto;
    }
}
