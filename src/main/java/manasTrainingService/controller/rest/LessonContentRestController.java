package manasTrainingService.controller.rest;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.lesson.LessonContentDTO;
import manasTrainingService.entity.Lesson;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.service.LessonAccessService;
import manasTrainingService.service.LessonContentService;
import manasTrainingService.service.LessonService;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/lessons")
public class LessonContentRestController {

    private final LessonService lessonService;
    private final LessonContentService lessonContentService;
    private final LessonAccessService lessonAccessService;
    private final MessageSource messageSource;

    @GetMapping("/{lessonId}/content")
    public ResponseEntity<LessonContentDTO> getLessonContent(@PathVariable Integer lessonId, Authentication authentication) {
        Lesson lesson = lessonService.getLessonModelById(lessonId);
        if (!lessonAccessService.canAccessLesson(lesson)) {
            String msg = messageSource.getMessage(
                    "LessonContentRestController.access.denied",
                    null,
                    LocaleContextHolder.getLocale()
            );
            throw new NoAccessException(msg);        }

        LessonContentDTO dto = lessonContentService.getContentByLessonId(lessonId)
                .orElse(new LessonContentDTO());

        return ResponseEntity.ok(dto);
    }

    @PostMapping("/{lessonId}/content")
    public ResponseEntity<?> updateLessonContent(
            @PathVariable Integer lessonId,
            @RequestBody LessonContentDTO contentDTO,
            Authentication authentication) {
        Lesson lesson = lessonService.getLessonModelById(lessonId);

        if (!lessonAccessService.canAccessLessonStaff(lesson)) {
            String msg = messageSource.getMessage(
                    "LessonContentRestController.edit.denied",
                    null,
                    LocaleContextHolder.getLocale()
            );
            return ResponseEntity.status(403).body(msg);

        }

        lessonContentService.saveOrUpdateContent(lesson, contentDTO);
        return ResponseEntity.ok().build();
    }
}
