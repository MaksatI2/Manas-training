package manasTrainingService.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import manasTrainingService.dto.CourseInstanceCreationDTO;
import manasTrainingService.dto.instance.CourseInstanceUpdateDTO;

import java.time.LocalDate;

public class EndDateAfterStartDateValidator implements ConstraintValidator<EndDateAfterStartDate, Object> {

    @Override
    public boolean isValid(Object obj, ConstraintValidatorContext context) {
        if (obj == null) return true;

        LocalDate startDate = null;
        LocalDate endDate = null;

        if (obj instanceof CourseInstanceCreationDTO) {
            CourseInstanceCreationDTO dto = (CourseInstanceCreationDTO) obj;
            startDate = dto.getStartDate();
            endDate = dto.getEndDate();
        } else if (obj instanceof CourseInstanceUpdateDTO) {
            CourseInstanceUpdateDTO dto = (CourseInstanceUpdateDTO) obj;
            startDate = dto.getStartDate();
            endDate = dto.getEndDate();
        } else {
            return true; //На будущее, если вам понадобится для валидации
        }

        if (startDate == null || endDate == null) return true;

        boolean isValid = !endDate.isBefore(startDate);

        if (!isValid) {
            context.disableDefaultConstraintViolation();
            context.buildConstraintViolationWithTemplate("Дата конца должна быть после начала")
                    .addPropertyNode("endDate")
                    .addConstraintViolation();
        }

        return isValid;
    }

}
