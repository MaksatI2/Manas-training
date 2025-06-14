package manasTrainingService.repositories;

import manasTrainingService.entity.Course;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseRepository extends JpaRepository<Course, Integer> {

    List<Course> findAllByCategoryId(Integer categoryId);

    Page<Course> findByCategoryId(Integer categoryId, Pageable pageable);

    Page<Course> findByTitleContainingIgnoreCaseOrCodeContainingIgnoreCaseAndCategoryId(
            String title, String code, Integer categoryId, Pageable pageable);

    boolean existsByCode(String code);

    @Query("SELECT COUNT(c) > 0 FROM Course c WHERE c.code = :code AND c.id <> :id")
    boolean existsByCodeAndIdNot(@Param("code") String code, @Param("id") Integer id);


    @Query("""
                SELECT c FROM Course c
                WHERE (
                    CAST(:search AS string) IS NULL OR 
                    (c.title IS NOT NULL AND LOWER(c.title) LIKE LOWER(CONCAT('%', CAST(:search AS string), '%'))) OR
                    (c.code IS NOT NULL AND LOWER(c.code) LIKE LOWER(CONCAT('%', CAST(:search AS string), '%')))
                )
                AND (:categoryId IS NULL OR c.category.id = :categoryId)
                AND (:isActive IS NULL OR c.isActive = :isActive)
                AND (:isIndividual IS NULL OR c.isIndividual = :isIndividual)
            """)
    Page<Course> searchFiltered(
            @Param("search") String search,
            @Param("categoryId") Integer categoryId,
            @Param("isActive") Boolean isActive,
            @Param("isIndividual") Boolean isIndividual,
            Pageable pageable
    );

    @Query("SELECT c FROM Course c WHERE (:categoryId IS NULL OR c.category.id = :categoryId) " +
            "AND (:search IS NULL OR c.title LIKE %:search% OR c.code LIKE %:search%) " +
            "AND (:isActive IS NULL OR c.isActive = :isActive) " +
            "AND (:isIndividual IS NULL OR c.isIndividual = :isIndividual)")
    Page<Course> findCourses(Integer categoryId, String search, Boolean isActive, Boolean isIndividual, Pageable pageable);

}
