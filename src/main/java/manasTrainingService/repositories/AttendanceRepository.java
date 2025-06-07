package manasTrainingService.repositories;

import manasTrainingService.entity.Attendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, Integer> {
    List<Attendance> findAllByStudentId(Integer studentId);
    List<Attendance> findAllByScheduleId(Integer scheduleId);
    List<Attendance> findAllByStatus(Attendance.AttendanceStatus status);

}
