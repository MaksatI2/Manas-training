package manasTrainingService.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Documented
@Constraint(validatedBy = UniqueCourseInstanceTitleCreateValidator.class)
@Target({ ElementType.TYPE })
@Retention(RetentionPolicy.RUNTIME)
public @interface UniqueCourseInstanceTitleCreate {
    String message() default "{UniqueCourseInstanceTitleCreate.message}";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
