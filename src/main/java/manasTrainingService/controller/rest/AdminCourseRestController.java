package manasTrainingService.controller.rest;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseDeletionDependenciesDto;
import manasTrainingService.service.course.CourseAdminService;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController()
@RequestMapping("/admin/courses/api")
@RequiredArgsConstructor
public class AdminCourseRestController {

    private final CourseAdminService courseAdminService;

    @GetMapping("/{id}/dependencies")
    @ResponseBody
    public CourseDeletionDependenciesDto getDependencies(@PathVariable Integer id) {
        return courseAdminService.getDeletionDependencies(id);
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public void deleteCourse(@PathVariable Integer id) {
        courseAdminService.deleteCourse(id);
    }
}
