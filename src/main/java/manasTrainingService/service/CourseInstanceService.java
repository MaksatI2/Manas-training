package manasTrainingService.service;

import manasTrainingService.dto.CourseInstanceDTO;
import manasTrainingService.entity.CourseInstance;

import java.util.List;

public interface CourseInstanceService {
    Integer createCourseInstance(CourseInstanceDTO dto);

    List<CourseInstanceDTO> findAll();
}
