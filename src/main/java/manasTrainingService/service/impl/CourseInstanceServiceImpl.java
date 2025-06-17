package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseInstanceDTO;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.repositories.CourseInstanceRepository;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.CourseService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseInstanceServiceImpl implements CourseInstanceService {
    private final CourseInstanceRepository courseInstanceRepository;
    private final CourseService courseService;

    @Override
    public Integer createCourseInstance(CourseInstanceDTO dto) {
        Course course = courseService.getCourseById(dto.getCourseId());
        CourseInstance courseInstance = CourseInstance.builder()
                .course(course)
                .title(dto.getTitle())
                .startDate(dto.getStartDate().atStartOfDay())
                .endDate(dto.getEndDate().atStartOfDay())
                .isActive(dto.getIsActive())
                .build();
        return courseInstanceRepository.save(courseInstance).getId();
    }

    @Override
    public List<CourseInstanceDTO> findAll() {
        return courseInstanceRepository.findAll().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    private CourseInstanceDTO convertToDto(CourseInstance courseInstance) {
        return CourseInstanceDTO.builder()
                .id(courseInstance.getId())
                .courseId(courseInstance.getCourse().getId())
                .title(courseInstance.getTitle())
                .startDate(courseInstance.getStartDate().toLocalDate())
                .endDate(courseInstance.getEndDate().toLocalDate())
                .isActive(courseInstance.getIsActive())
                .build();
    }
}