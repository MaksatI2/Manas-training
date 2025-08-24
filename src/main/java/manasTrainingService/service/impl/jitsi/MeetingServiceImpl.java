package manasTrainingService.service.impl.jitsi;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.dto.jitsi.ActiveMeetingDTO;
import manasTrainingService.dto.jitsi.EndMeetingRequestDTO;
import manasTrainingService.dto.jitsi.MeetingResponseDTO;
import manasTrainingService.dto.jitsi.StartMeetingRequestDTO;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.ScheduleNotFouneException;
import manasTrainingService.exceptions.nsee.jitsi.MeetingAccessDeniedException;
import manasTrainingService.exceptions.nsee.jitsi.MeetingAlreadyActiveException;
import manasTrainingService.exceptions.nsee.jitsi.MeetingEndedException;
import manasTrainingService.exceptions.nsee.jitsi.MeetingNotFoundException;
import manasTrainingService.repositories.ScheduleRepository;
import manasTrainingService.repositories.jitsi.MeetingParticipantRepository;
import manasTrainingService.repositories.jitsi.MeetingRepository;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.jitsi.MeetingService;
import manasTrainingService.service.user.UserService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class MeetingServiceImpl implements MeetingService {

    private final MeetingRepository meetingRepository;
    private final MeetingParticipantRepository meetingParticipantRepository;
    private final ScheduleRepository scheduleRepository;
    private final UserService userService;
    private final EnrollmentService enrollmentService;
    private final SimpMessagingTemplate messagingTemplate;

    @Value("${jitsi.domain:localhost}")
    private String jitsiDomain;

    @Value("${jitsi.port:8443}")
    private String jitsiPort;

    @Value("${jitsi.protocol:https}")
    private String jitsiProtocol;

    @Value("${jitsi.room.prefix:ManasTraining}")
    private String roomPrefix;

    @Transactional
    @Override
    public MeetingResponseDTO startMeeting(StartMeetingRequestDTO request) {
        Schedule schedule = scheduleRepository.findById(request.getScheduleId())
                .orElseThrow(() -> new ScheduleNotFouneException("Расписание не найдено"));

        User teacher = userService.getUserById(request.getTeacherId());

        if (!schedule.getTeacher().getId().equals(teacher.getId())) {
            throw new MeetingAccessDeniedException("Вы не можете начать урок, который ведёт другой преподаватель");
        }

        if (meetingRepository.existsByScheduleIdAndEndedAtIsNull(schedule.getId())) {
            throw new MeetingAlreadyActiveException("Встреча для этого урока уже активна");
        }

        String meetingId = generateUniqueMeetingId();
        String roomName = generateRoomName(schedule);

        Meeting meeting = Meeting.builder()
                .schedule(schedule)
                .meetingId(meetingId)
                .roomName(roomName)
                .startedAt(LocalDateTime.now())
                .createdAt(LocalDateTime.now())
                .build();

        meeting = meetingRepository.save(meeting);

        addTeacherAsParticipant(meeting, teacher);

        scheduleRepository.save(schedule);

        log.info("Meeting started: scheduleId={}, meetingId={}, teacherId={}, roomName={}",
                schedule.getId(), meeting.getId(), teacher.getId(), roomName);

        return mapToMeetingResponseDTO(meeting);
    }

    @Transactional
    @Override
    public void endMeeting(EndMeetingRequestDTO request) {
        Meeting meeting = meetingRepository.findById(request.getMeetingId())
                .orElseThrow(() -> new MeetingNotFoundException("Встреча не найдена"));

        if (!meeting.getSchedule().getTeacher().getId().equals(request.getTeacherId())) {
            throw new MeetingAccessDeniedException("Вы не можете завершить встречу другого преподавателя");
        }

        if (meeting.getEndedAt() != null) {
            throw new MeetingEndedException("Встреча уже завершена");
        }

        // 1. Сначала отправляем уведомление о завершении всем участникам
        log.info("Sending end meeting notification to all participants for meeting: {}", meeting.getId());
        try {
            messagingTemplate.convertAndSend("/topic/meetings/" + meeting.getId(), "MEETING_ENDING");
            // Небольшая пауза для обработки уведомления клиентами
            Thread.sleep(1000);
        } catch (Exception e) {
            log.error("Failed to send meeting ending notification", e);
        }

        // 2. Завершаем всех активных участников
        endAllActiveParticipants(meeting);

        // 3. Обновляем статус встречи
        meeting.setEndedAt(LocalDateTime.now());
        meetingRepository.save(meeting);

        // 4. Отправляем финальное уведомление
        try {
            messagingTemplate.convertAndSend("/topic/meetings/" + meeting.getId(), "ENDED");
            log.info("Final ENDED notification sent for meeting: {}", meeting.getId());
        } catch (Exception e) {
            log.error("Failed to send final ENDED notification", e);
        }

        log.info("Meeting ended: meetingId={}, teacherId={}", meeting.getId(), request.getTeacherId());
    }

    @Override
    public MeetingResponseDTO getMeetingByScheduleId(Integer scheduleId) {
        Meeting meeting = meetingRepository.findActiveMeetingByScheduleId(scheduleId)
                .orElse(null);

        return meeting != null ? mapToMeetingResponseDTO(meeting) : null;
    }

    @Override
    public MeetingResponseDTO getMeetingById(Integer meetingId) {
        Meeting meeting = meetingRepository.findById(meetingId)
                .orElse(null);

        return meeting != null ? mapToMeetingResponseDTO(meeting) : null;
    }

    @Override
    public boolean isMeetingActive(Integer scheduleId) {
        return meetingRepository.existsByScheduleIdAndEndedAtIsNull(scheduleId);
    }

    @Override
    public boolean canUserAccessMeeting(Integer userId, String userRole, Integer meetingId) {
        Meeting meeting = meetingRepository.findById(meetingId).orElse(null);
        if (meeting == null) {
            return false;
        }

        if ("ADMIN".equals(userRole)) {
            return true;
        }

        if ("TEACHER".equals(userRole)) {
            return meeting.getSchedule().getTeacher().getId().equals(userId);
        }

        if ("STUDENT".equals(userRole)) {
            Integer courseInstanceId = meeting.getSchedule().getCourseInstance().getId();
            List<CourseEnrollment> enrollments = enrollmentService
                    .findAllEnrollmentsForCourseInstance(courseInstanceId);

            return enrollments.stream()
                    .anyMatch(enrollment -> enrollment.getStudent().getId().equals(userId));
        }

        return false;
    }

    private void addTeacherAsParticipant(Meeting meeting, User teacher) {
        String participantId = UUID.randomUUID().toString();
        String teacherName = teacher.getName() + " " + teacher.getLastName();

        MeetingParticipant teacherParticipant = MeetingParticipant.builder()
                .meeting(meeting)
                .user(teacher)
                .participantName(teacherName)
                .participantId(participantId)
                .joinedAt(LocalDateTime.now())
                .isModerator(true)
                .build();

        meetingParticipantRepository.save(teacherParticipant);

        log.info("Teacher added as participant: meetingId={}, teacherId={}, participantId={}",
                meeting.getId(), teacher.getId(), participantId);
    }

    private void endAllActiveParticipants(Meeting meeting) {
        List<MeetingParticipant> activeParticipants = meetingParticipantRepository
                .findActiveMeetingParticipants(meeting.getId());

        LocalDateTime endTime = LocalDateTime.now();

        for (MeetingParticipant participant : activeParticipants) {
            participant.setLeftAt(endTime);
            long durationSeconds = java.time.Duration.between(participant.getJoinedAt(), endTime).getSeconds();
            participant.setDurationSeconds((int) durationSeconds);

            log.info("Ending participation for user: {} (participantId: {})",
                    participant.getUser() != null ? participant.getUser().getId() : "guest",
                    participant.getParticipantId());
        }

        meetingParticipantRepository.saveAll(activeParticipants);

        log.info("Ended participation for {} active participants in meeting: {}",
                activeParticipants.size(), meeting.getId());
    }

    private String generateUniqueMeetingId() {
        return UUID.randomUUID().toString();
    }

    private String generateRoomName(Schedule schedule) {
        return String.format("%s_Meeting_%d_%s_%d",
                roomPrefix,
                schedule.getId(),
                schedule.getLessonDate().toString().replace("-", ""),
                System.currentTimeMillis() % 10000);
    }

    public String getJitsiDomain() {
        return jitsiDomain;
    }

    public String getJitsiPort() {
        return jitsiPort;
    }

    public String getJitsiProtocol() {
        return jitsiProtocol;
    }

    private MeetingResponseDTO mapToMeetingResponseDTO(Meeting meeting) {
        Integer participantCount = meetingRepository.countActiveMeetingParticipants(meeting.getId());

        return MeetingResponseDTO.builder()
                .lessonId(meeting.getSchedule().getLesson().getId())
                .meetingId(meeting.getId())
                .roomName(meeting.getRoomName())
                .status(meeting.getEndedAt() == null ? "ACTIVE" : "ENDED")
                .startedAt(meeting.getStartedAt())
                .lessonTitle(meeting.getSchedule().getTitle())
                .teacherName(meeting.getSchedule().getTeacher().getName() + " " +
                             meeting.getSchedule().getTeacher().getLastName())
                .participantCount(participantCount)
                .build();
    }

    private ActiveMeetingDTO mapToActiveMeetingDTO(Meeting meeting) {
        Schedule schedule = meeting.getSchedule();
        Integer participantCount = meetingRepository.countActiveMeetingParticipants(meeting.getId());

        return ActiveMeetingDTO.builder()
                .id(meeting.getId())
                .scheduleId(schedule.getId())
                .roomName(meeting.getRoomName())
                .lessonTitle(schedule.getTitle())
                .courseTitle(schedule.getCourseInstance().getCourse().getTitle())
                .teacherName(schedule.getTeacher().getName() + " " + schedule.getTeacher().getLastName())
                .startedAt(meeting.getStartedAt())
                .participantCount(participantCount)
                .build();
    }
}