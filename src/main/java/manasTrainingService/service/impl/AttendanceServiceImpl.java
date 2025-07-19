package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.repositories.AttendanceRepository;
import manasTrainingService.service.AttendanceService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AttendanceServiceImpl implements AttendanceService {

    private final AttendanceRepository attendanceRepository;

    @Override
    public Integer sumAbsentHoursByStudentAndCourseInstance(Integer studentId, Integer courseInstanceId) {
        return attendanceRepository.sumAbsentHoursByStudentAndCourseInstance(studentId, courseInstanceId);
    }
}
