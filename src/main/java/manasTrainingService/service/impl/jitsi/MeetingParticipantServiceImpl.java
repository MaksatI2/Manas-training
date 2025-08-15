package manasTrainingService.service.impl.jitsi;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.dto.jitsi.JoinMeetingRequestDTO;
import manasTrainingService.dto.jitsi.MeetingParticipantDTO;
import manasTrainingService.entity.Meeting;
import manasTrainingService.entity.MeetingParticipant;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.jitsi.MeetingEndedException;
import manasTrainingService.exceptions.nsee.jitsi.MeetingNotFoundException;
import manasTrainingService.repositories.jitsi.MeetingParticipantRepository;
import manasTrainingService.repositories.jitsi.MeetingRepository;
import manasTrainingService.service.jitsi.MeetingParticipantService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class MeetingParticipantServiceImpl implements MeetingParticipantService {

    private final MeetingParticipantRepository participantRepository;
    private final MeetingRepository meetingRepository;
    private final UserService userService;

    @Transactional
    @Override
    public MeetingParticipantDTO joinMeeting(JoinMeetingRequestDTO request) {
        Meeting meeting = meetingRepository.findById(request.getMeetingId())
                .orElseThrow(() -> new MeetingNotFoundException("Встреча не найдена"));

        if (meeting.getEndedAt() != null) {
            throw new MeetingEndedException("Встреча завершена");
        }

        User user = null;
        String participantName = request.getParticipantName();

        if (request.getUserId() != null) {
            user = userService.getUserById(request.getUserId());

            Optional<MeetingParticipant> existingParticipant = participantRepository
                    .findActiveParticipantByMeetingAndUser(meeting.getId(), user.getId());

            if (existingParticipant.isPresent()) {
                log.info("User is already in meeting: meetingId={}, userId={}",
                        meeting.getId(), user.getId());
                return mapToMeetingParticipantDTO(existingParticipant.get());
            }
        }

        if (user != null) {
            String systemUserName = buildFullName(user.getName(), user.getLastName());

            if (participantName == null || participantName.trim().isEmpty()) {
                participantName = systemUserName;
            } else {
                participantName = systemUserName;
                log.info("Using system name '{}' instead of provided name '{}' for user {}",
                        systemUserName, request.getParticipantName(), user.getId());
            }
        } else {
            if (participantName == null || participantName.trim().isEmpty()) {
                participantName = "Гость";
            }
        }

        String participantId = UUID.randomUUID().toString();

        boolean isModerator = user != null &&
                              meeting.getSchedule().getTeacher().getId().equals(user.getId());

        MeetingParticipant participant = MeetingParticipant.builder()
                .meeting(meeting)
                .user(user)
                .participantName(participantName)
                .participantId(participantId)
                .joinedAt(LocalDateTime.now())
                .isModerator(isModerator)
                .build();

        participant = participantRepository.save(participant);

        log.info("User joined meeting: meetingId={}, userId={}, participantName={}, isModerator={}",
                meeting.getId(), request.getUserId(), participantName, isModerator);

        return mapToMeetingParticipantDTO(participant);
    }

    @Transactional
    @Override
    public void leaveMeeting(Integer meetingId, Integer userId) {
        MeetingParticipant participant = participantRepository
                .findActiveParticipantByMeetingAndUser(meetingId, userId)
                .orElseThrow(() -> new IllegalArgumentException("Активный участник не найден"));

        LocalDateTime leftAt = LocalDateTime.now();
        participant.setLeftAt(leftAt);

        long durationSeconds = java.time.Duration.between(participant.getJoinedAt(), leftAt).getSeconds();
        participant.setDurationSeconds((int) durationSeconds);

        participantRepository.save(participant);

        log.info("User left meeting: meetingId={}, userId={}, participantName={}, duration={} seconds",
                meetingId, userId, participant.getParticipantName(), durationSeconds);
    }

    @Transactional
    @Override
    public void leaveMeetingByParticipantId(Integer meetingId, String participantId) {
        MeetingParticipant participant = participantRepository
                .findActiveParticipantByMeetingAndParticipantId(meetingId, participantId)
                .orElseThrow(() -> new IllegalArgumentException("Активный участник не найден"));

        LocalDateTime leftAt = LocalDateTime.now();
        participant.setLeftAt(leftAt);

        long durationSeconds = java.time.Duration.between(participant.getJoinedAt(), leftAt).getSeconds();
        participant.setDurationSeconds((int) durationSeconds);

        participantRepository.save(participant);

        log.info("Participant left meeting: meetingId={}, participantId={}, participantName={}, duration={} seconds",
                meetingId, participantId, participant.getParticipantName(), durationSeconds);
    }

    private String buildFullName(String firstName, String lastName) {
        StringBuilder fullName = new StringBuilder();

        if (firstName != null && !firstName.trim().isEmpty()) {
            fullName.append(firstName.trim());
        }

        if (lastName != null && !lastName.trim().isEmpty()) {
            if (fullName.length() > 0) {
                fullName.append(" ");
            }
            fullName.append(lastName.trim());
        }

        return fullName.length() > 0 ? fullName.toString() : "Пользователь";
    }

    private MeetingParticipantDTO mapToMeetingParticipantDTO(MeetingParticipant participant) {
        return MeetingParticipantDTO.builder()
                .id(participant.getId())
                .meetingId(participant.getMeeting().getId())
                .userId(participant.getUser() != null ? participant.getUser().getId() : null)
                .participantName(participant.getParticipantName())
                .participantId(participant.getParticipantId())
                .joinedAt(participant.getJoinedAt())
                .leftAt(participant.getLeftAt())
                .durationSeconds(participant.getDurationSeconds())
                .isModerator(participant.getIsModerator())
                .build();
    }
}