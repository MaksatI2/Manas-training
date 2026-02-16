package manasTrainingService.repositories.jitsi;

import manasTrainingService.entity.ParticipantPing;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ParticipantPingRepository extends JpaRepository<ParticipantPing, Integer> {

    @Query("SELECT pp FROM ParticipantPing pp WHERE pp.meetingParticipant.id = :participantId ORDER BY pp.pingTime DESC")
    List<ParticipantPing> findByMeetingParticipantIdOrderByPingTimeDesc(@Param("participantId") Integer participantId);

    @Query("SELECT pp FROM ParticipantPing pp " +
           "WHERE pp.meetingParticipant.meeting.id = :meetingId " +
           "AND pp.pingTime >= :fromTime " +
           "ORDER BY pp.pingTime DESC")
    List<ParticipantPing> findPingsByMeetingAndTime(@Param("meetingId") Integer meetingId,
                                                    @Param("fromTime") LocalDateTime fromTime);
}