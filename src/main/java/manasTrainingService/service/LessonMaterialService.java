package manasTrainingService.service;

import manasTrainingService.dto.lesson.LessonMaterialDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface LessonMaterialService {
    List<LessonMaterialDTO> getMaterialsByLessonId(Integer lessonId);

    @Transactional
    void addMaterial(LessonMaterialDTO material);

    @Transactional
    void deleteMaterial(Integer materialId);
}
