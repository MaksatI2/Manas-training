package manasTrainingService.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = EndDateAfterStartDateValidator.class)
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface EndDateAfterStartDate {
    String message() default "Дата конца должна быть позже начала";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
