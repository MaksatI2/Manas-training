package manasTrainingService.repositories;

import manasTrainingService.entity.CourseCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CourseCategoryRepository extends JpaRepository<CourseCategory, Integer> {

    Optional<CourseCategory> findByName(String name);


    boolean existsByName(String name);

    @Query("SELECT COUNT(c) > 0 FROM CourseCategory c WHERE LOWER(c.name) = LOWER(:name) AND c.id <> :id")
    boolean existsByNameAndIdNot(@Param("name") String name, @Param("id") Integer id);


    List<CourseCategory> findByNameContainingIgnoreCase(String name);

    Page<CourseCategory> findByNameContainingIgnoreCase(String name, Pageable pageable);

    List<CourseCategory> findAllByNameContainingIgnoreCase(String name);


}
