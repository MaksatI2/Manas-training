package manasTrainingService.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.lesson.ScheduleDTO;
import manasTrainingService.service.CourseInstanceService;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDate;

public class LessonDateInCourseRangeValidator implements ConstraintValidator<LessonDateInCourseRange, ScheduleDTO> {

    @Autowired
    private CourseInstanceService courseInstanceService;

    @Override
    public boolean isValid(ScheduleDTO dto, ConstraintValidatorContext context) {
        if (dto.getLessonDate() == null || dto.getCourseInstanceId() == null) {
            return true;
        }

        CourseInstanceDTO course = courseInstanceService.getCourseInstanceById(dto.getCourseInstanceId());
        if (course == null || course.getStartDate() == null || course.getEndDate() == null) {
            return true;
        }

        LocalDate lessonDate = dto.getLessonDate();
        if (lessonDate.isBefore(course.getStartDate()) || lessonDate.isAfter(course.getEndDate())) {
            context.disableDefaultConstraintViolation();
            context.buildConstraintViolationWithTemplate(
                            String.format("Дата урока (%s) должна быть в пределах курса: %s — %s",
                                    lessonDate,
                                    course.getStartDate(),
                                    course.getEndDate()))
                    .addPropertyNode("lessonDate")
                    .addConstraintViolation();
            return false;
        }

        return true;
    }
}
