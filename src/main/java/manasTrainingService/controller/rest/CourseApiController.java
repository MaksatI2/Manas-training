package manasTrainingService.controller.rest;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseSummaryDto;
import manasTrainingService.dto.TeacherCardDto;
import manasTrainingService.service.course.CourseService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/courses")
@RequiredArgsConstructor
public class CourseApiController {

    private final CourseService courseService;

    @GetMapping("/{id}/teachers")
    public List<TeacherCardDto> getTeachersByCourse(@PathVariable Integer id) {
        return courseService.getTeachersByCourse(id);
    }

    @GetMapping("/category/{categoryId}")
    public List<CourseSummaryDto> getCoursesByCategory(@PathVariable Integer categoryId) {
        return courseService.getCoursesByCategory(categoryId);
    }
}
