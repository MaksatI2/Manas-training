package manasTrainingService.repositories.jitsi;

import manasTrainingService.entity.Meeting;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MeetingRepository extends JpaRepository<Meeting, Integer> {

    Optional<Meeting> findByScheduleId(Integer scheduleId);

    Optional<Meeting> findByMeetingId(String meetingId);

    @Query("SELECT m FROM Meeting m WHERE m.schedule.id = :scheduleId AND m.endedAt IS NULL")
    Optional<Meeting> findActiveMeetingByScheduleId(@Param("scheduleId") Integer scheduleId);

    @Query("SELECT m FROM Meeting m WHERE m.endedAt IS NULL")
    List<Meeting> findAllActiveMeetings();

    @Query("SELECT m FROM Meeting m WHERE m.schedule.teacher.id = :teacherId AND m.endedAt IS NULL")
    List<Meeting> findActiveTeacherMeetings(@Param("teacherId") Integer teacherId);

    @Query("SELECT m FROM Meeting m " +
           "JOIN m.schedule s " +
           "JOIN s.courseInstance ci " +
           "JOIN ci.enrollments e " +
           "WHERE e.student.id = :studentId AND m.endedAt IS NULL")
    List<Meeting> findActiveStudentMeetings(@Param("studentId") Integer studentId);

    @Query("SELECT COUNT(mp) FROM MeetingParticipant mp " +
           "WHERE mp.meeting.id = :meetingId AND mp.leftAt IS NULL")
    Integer countActiveMeetingParticipants(@Param("meetingId") Integer meetingId);

    boolean existsByScheduleIdAndEndedAtIsNull(Integer scheduleId);
}