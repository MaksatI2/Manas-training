package manasTrainingService.repositories;

import manasTrainingService.entity.Attendance;
import manasTrainingService.entity.Status;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, Integer> {
    List<Attendance> findAllByStudentId(Integer studentId);
    List<Attendance> findAllByScheduleId(Integer scheduleId);
    List<Attendance> findAllByStatus(Status status);

    @Query("""
    SELECT SUM(s.durationHours)
    FROM Attendance a
    JOIN a.schedule s
    WHERE a.student.id = :studentId
    AND s.courseInstance.id = :courseInstanceId
    AND s.isActive = true
    AND a.status = 'ABSENT'
""")
    Integer sumAbsentHoursByStudentAndCourseInstance(@Param("studentId") Integer studentId,
                                                     @Param("courseInstanceId") Integer courseInstanceId);

}
