package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.lesson.LessonMaterialDTO;
import manasTrainingService.entity.*;
import manasTrainingService.repositories.LessonMaterialRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.LessonMaterialService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.user.UserService;
import manasTrainingService.util.FileUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LessonMaterialsServiceImpl implements LessonMaterialService {

    private final LessonMaterialRepository materialRepository;
    private final LessonService lessonService;
    private final FileUtil fileUtil;
    private final ActivityLogService activityLogService;
    private final UserService userService;

    @Override
    public List<LessonMaterialDTO> getMaterialsByLessonId(Integer lessonId) {
        return materialRepository.findByLessonId(lessonId).stream()
                .map(material -> LessonMaterialDTO.builder()
                        .id(material.getId())
                        .lessonId(lessonId)
                        .title(material.getTitle())
                        .url(material.getUrl())
                        .build())
                .collect(Collectors.toList());
    }

    @Transactional
    @Override
    public void addMaterial(LessonMaterialDTO dto) {
        MultipartFile file = dto.getFile();
        String fileName = fileUtil.saveUploadFile(file, "lesson-materials", FileType.DOCUMENT);

        Lesson lesson = lessonService.getLessonModelById(dto.getLessonId());

        LessonMaterial material = LessonMaterial.builder()
                .lesson(lesson)
                .title(dto.getTitle())
                .url(fileName)
                .build();

        LessonMaterial saved = materialRepository.save(material);

        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.CREATE,
                TargetType.LESSON_MATERIAL,
                saved.getId()
        );
    }

    @Transactional
    @Override
    public void deleteMaterial(Integer materialId) {
        LessonMaterial material = materialRepository.findById(materialId)
                .orElseThrow(() -> new IllegalArgumentException("Material not found"));
        materialRepository.delete(material);

        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.DELETE,
                TargetType.LESSON_MATERIAL,
                materialId
        );
    }
}
