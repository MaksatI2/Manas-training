package manasTrainingService.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import manasTrainingService.dto.CourseInstanceCreationDTO;

public class EndDateAfterStartDateValidator implements ConstraintValidator<EndDateAfterStartDate, CourseInstanceCreationDTO> {

    @Override
    public boolean isValid(CourseInstanceCreationDTO dto, ConstraintValidatorContext context) {
        if (dto.getStartDate() == null || dto.getEndDate() == null) {
            return true;
        }

        boolean isValid = !dto.getEndDate().isBefore(dto.getStartDate());

        if (!isValid) {
            context.disableDefaultConstraintViolation();
            context.buildConstraintViolationWithTemplate("Дата конца должна быть после начала")
                   .addPropertyNode("endDate")
                   .addConstraintViolation();
        }

        return isValid;
    }
}
