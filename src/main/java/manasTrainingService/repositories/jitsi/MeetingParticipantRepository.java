package manasTrainingService.repositories.jitsi;

import manasTrainingService.entity.MeetingParticipant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MeetingParticipantRepository extends JpaRepository<MeetingParticipant, Integer> {

    List<MeetingParticipant> findByMeetingId(Integer meetingId);

    @Query("SELECT mp FROM MeetingParticipant mp WHERE mp.leftAt IS NULL")
    List<MeetingParticipant> findAllActiveParticipants();

    @Query("SELECT mp FROM MeetingParticipant mp WHERE mp.meeting.id = :meetingId")
    List<MeetingParticipant> findAllByMeetingId(@Param("meetingId") Integer meetingId);

    @Query("SELECT mp FROM MeetingParticipant mp " +
           "WHERE mp.meeting.id = :meetingId AND mp.leftAt IS NULL")
    List<MeetingParticipant> findActiveMeetingParticipants(@Param("meetingId") Integer meetingId);

    @Query("SELECT mp FROM MeetingParticipant mp " +
           "WHERE mp.meeting.id = :meetingId AND mp.user.id = :userId AND mp.leftAt IS NULL")
    Optional<MeetingParticipant> findActiveParticipantByMeetingAndUser(
            @Param("meetingId") Integer meetingId,
            @Param("userId") Integer userId);

    @Query("SELECT mp FROM MeetingParticipant mp " +
           "WHERE mp.meeting.id = :meetingId AND mp.participantId = :participantId AND mp.leftAt IS NULL")
    Optional<MeetingParticipant> findActiveParticipantByMeetingAndParticipantId(
            @Param("meetingId") Integer meetingId,
            @Param("participantId") String participantId);

    @Query("SELECT COUNT(mp) FROM MeetingParticipant mp " +
           "WHERE mp.meeting.id = :meetingId AND mp.leftAt IS NULL")
    Integer countActiveParticipants(@Param("meetingId") Integer meetingId);

    @Query("SELECT mp FROM MeetingParticipant mp " +
           "WHERE mp.user.id = :userId AND mp.leftAt IS NULL")
    List<MeetingParticipant> findActiveParticipantsByUser(@Param("userId") Integer userId);
}