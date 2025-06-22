package manasTrainingService.controller.api;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseModuleApiDto;
import manasTrainingService.service.course.CourseModuleService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/courses")
@RequiredArgsConstructor
public class ApiCourseModuleController {

    private final CourseModuleService courseModuleService;

    @GetMapping("/{courseId}/modules")
    public ResponseEntity<List<CourseModuleApiDto>> getModulesByCourse(@PathVariable Integer courseId) {
        List<CourseModuleApiDto> modules = courseModuleService.getModuleApiDtosByCourseInstanceId(courseId);
        return ResponseEntity.ok(modules);
    }
}
