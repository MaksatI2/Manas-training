package manasTrainingService.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.lesson.ScheduleDTO;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.util.DateUtil;
import org.hibernate.validator.constraintvalidation.HibernateConstraintValidatorContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
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
        LocalDate courseStart = course.getStartDate();
        LocalDate courseEnd = course.getEndDate();

        if (lessonDate.isBefore(courseStart) || lessonDate.isAfter(courseEnd)) {
            context.disableDefaultConstraintViolation();
            context.unwrap(HibernateConstraintValidatorContext.class)
                    .addMessageParameter("startDate", DateUtil.format(courseStart))
                    .addMessageParameter("endDate", DateUtil.format(courseEnd))
                    .buildConstraintViolationWithTemplate("{LessonDateInCourseRange.message}")
                    .addPropertyNode("lessonDate")
                    .addConstraintViolation();

            return false;
        }


        return true;
    }
}
