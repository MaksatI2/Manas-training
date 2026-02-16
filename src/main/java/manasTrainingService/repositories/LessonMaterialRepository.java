package manasTrainingService.repositories;

import manasTrainingService.entity.LessonMaterial;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LessonMaterialRepository extends JpaRepository<LessonMaterial, Integer> {
    List<LessonMaterial> findByLessonId(Integer lessonId);
    void deleteById(Integer materialId);
    Optional<LessonMaterial> findById(Integer materialId);
}
