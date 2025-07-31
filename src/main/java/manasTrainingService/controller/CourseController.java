package manasTrainingService.controller;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.tests.TestInstanceDto;
import manasTrainingService.entity.Course;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.service.LessonAccessService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.impl.LessonAccessServiceImpl;
import manasTrainingService.service.test.TestInstanceService;
import manasTrainingService.service.test.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/courses")
@RequiredArgsConstructor
public class CourseController {

    @Autowired
    private CourseService courseService;
    @Autowired
    private TestService testService;
    @Autowired
    private TestInstanceService testInstanceService;
    @Autowired
    private CourseInstanceService courseInstanceService;
    @Autowired
    private LessonAccessService lessonAccessService;

    @GetMapping
    public String getCourseList(Model model) {
        try {
            List<CourseDto> courses = courseService.getAllCourses();
            List<CourseCategoryDto> categories = courseService.getCategories();
            model.addAttribute("courses", courses);
            model.addAttribute("categories", categories);
            return "courses/course_list";
        } catch (EntityNotFoundException e) {
            model.addAttribute("errorMessage", "Ошибка при загрузке курсов");
            return "error/error";
        }
    }

    @GetMapping("/{id}")
    public String getCourseDetails(@PathVariable Integer id, Model model, Authentication authentication) {
        try {
            CourseDto course = courseService.getById(id);
            model.addAttribute("course", course);
            boolean canEnroll = authentication != null && authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_STUDENT") || a.getAuthority().equals("ROLE_ORGANIZATION"));
            model.addAttribute("canEnroll", canEnroll);
            return "courses/course-view";
        } catch (EntityNotFoundException e) {
            model.addAttribute("errorMessage", "Курс не найден");
            return "error/error";
        }
    }

    @GetMapping("/{id}/tests")
    public String getCourseTests(@PathVariable Integer id, Model model) {
        CourseInstanceDTO courseInstanceDTO = courseInstanceService.getCourseInstanceById(id);
        CourseDto courseDto = courseService.getById(courseInstanceDTO.getCourseId());
        if (!lessonAccessService.canAccessCourseTests()){
            throw new NoAccessException("У вас нет досупа к этой странице");
        }
        model.addAttribute("tests", testService.getAllTestsByCourseId(courseDto.getId()));
        model.addAttribute("course", courseDto);
        model.addAttribute("instance", courseInstanceDTO);
        return "tests/course-tests";
    }
}