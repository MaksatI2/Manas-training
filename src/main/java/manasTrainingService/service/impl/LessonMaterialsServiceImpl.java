package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.lesson.LessonMaterialDTO;
import manasTrainingService.entity.Lesson;
import manasTrainingService.entity.LessonMaterial;
import manasTrainingService.repositories.LessonMaterialRepository;
import manasTrainingService.service.LessonMaterialService;
import manasTrainingService.service.LessonService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LessonMaterialsServiceImpl implements LessonMaterialService {

    private final LessonMaterialRepository materialRepository;
    private final LessonService lessonService;

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
    public void addMaterial(LessonMaterialDTO material) {
        Lesson lesson = lessonService.getLessonModelById(material.getLessonId());

        LessonMaterial entity = LessonMaterial.builder()
                .lesson(lesson)
                .title(material.getTitle())
                .url(material.getUrl())
                .build();

        materialRepository.save(entity);
    }

    @Transactional
    @Override
    public void deleteMaterial(Integer materialId) {
        LessonMaterial material = materialRepository.findById(materialId)
                .orElseThrow(() -> new IllegalArgumentException("Material not found"));
        materialRepository.delete(material);
    }
}
