package manasTrainingService.controller.rest;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseDeletionDependenciesDto;
import manasTrainingService.dto.statistics.TeacherMonthlyHoursDTO;
import manasTrainingService.service.ScheduleService;
import manasTrainingService.service.course.CourseAdminService;
import org.springframework.boot.context.properties.bind.DefaultValue;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.time.Year;
import java.util.List;

@RestController()
@RequestMapping("/admin/courses/api")
@RequiredArgsConstructor
public class AdminCourseRestController {

    private final CourseAdminService courseAdminService;
    private final ScheduleService scheduleService;

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

    @GetMapping("/teacher-hours")
    @ResponseBody
    public List<TeacherMonthlyHoursDTO> getTeacherHourStats(
            @RequestParam(value = "month", required = false) String monthStr,
            @RequestParam(value = "year", required = false) String yearStr) {

        return scheduleService.getMonthlyTeacherHourStats(monthStr, yearStr);
    }


    @GetMapping("/years")
    @ResponseBody
    public List<Integer> getAvailableYears() {
        return scheduleService.getAvailableYears();
    }
}
