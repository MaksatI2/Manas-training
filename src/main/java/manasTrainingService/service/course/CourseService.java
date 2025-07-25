package manasTrainingService.service.course;

import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.CourseOption;
import manasTrainingService.dto.TeacherCardDto;
import manasTrainingService.entity.Course;
import manasTrainingService.entity.User;

import java.util.List;

public interface CourseService {

    List<CourseDto> getAllCourses();

    CourseDto getById(Integer id);

    List<CourseCategoryDto> getCategories();

    Course getCourseById(Integer id);

    List<CourseDto> getAvailableCoursesForOrganization(User organizationUser);

    List<TeacherCardDto> getTeachersByCourse(Integer courseId);

    long getTotalCourses();

    List<CourseOption> getAvailableCourseOptionsForCalendar();
}