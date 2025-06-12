package manasTrainingService.controller;

import jakarta.validation.constraints.Min;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/courses")
public class CourseController {

    @Autowired
    private CourseService courseService;

    @GetMapping
    public ResponseEntity<Page<CourseDto>> getCourses(
            @RequestParam(defaultValue = "1") @Min(1) int page,
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false) String search) {
        Pageable pageable = PageRequest.of(page - 1, 12);
        Page<CourseDto> courses = courseService.getCourses(pageable, categoryId, search);
        return ResponseEntity.ok(courses);
    }

    @GetMapping("/{id}")
    public ResponseEntity<CourseDto> getCourseById(@PathVariable Integer id) {
        CourseDto course = courseService.getCourseById(id);
        return ResponseEntity.ok(course);
    }

    @GetMapping("/categories")
    public ResponseEntity<List<CourseCategoryDto>> getCategories() {
        List<CourseCategoryDto> categories = courseService.getCategories();
        return ResponseEntity.ok(categories);
    }
}