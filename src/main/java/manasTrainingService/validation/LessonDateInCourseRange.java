package manasTrainingService.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Documented
@Constraint(validatedBy = LessonDateInCourseRangeValidator.class)
@Target({ ElementType.TYPE })
@Retention(RetentionPolicy.RUNTIME)
public @interface LessonDateInCourseRange {
    String message() default "Дата урока должна быть в пределах курса";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
