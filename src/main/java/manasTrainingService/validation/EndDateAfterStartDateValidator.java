package manasTrainingService.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import manasTrainingService.dto.CourseInstanceCreationDTO;
import manasTrainingService.dto.application.CourseApplicationCreateDto;
import manasTrainingService.dto.application.StudentCourseApplicationCreateDto;
import manasTrainingService.dto.instance.CourseInstanceUpdateDTO;

import java.time.LocalDate;

public class EndDateAfterStartDateValidator implements ConstraintValidator<EndDateAfterStartDate, Object> {

    @Override
    public boolean isValid(Object obj, ConstraintValidatorContext context) {
        if (obj == null) return true;

        LocalDate startDate = null;
        LocalDate endDate = null;


        if (obj instanceof CourseInstanceCreationDTO dto) {
            startDate = dto.getStartDate();
            endDate = dto.getEndDate();
        } else if (obj instanceof CourseInstanceUpdateDTO dto) {
            startDate = dto.getStartDate();
            endDate = dto.getEndDate();
        } else if (obj instanceof CourseApplicationCreateDto dto) {
            startDate = dto.getPreferredStartDate();
            endDate = dto.getPreferredEndDate();
        }
        else if (obj instanceof StudentCourseApplicationCreateDto dto) {
            startDate = dto.getPreferredStartDate();
            endDate = dto.getPreferredEndDate();
        } else {
            return true;
        }

        if (startDate == null || endDate == null) return true;

        boolean isValid = !endDate.isBefore(startDate);

        String fieldName;

        if (obj instanceof CourseInstanceCreationDTO || obj instanceof CourseInstanceUpdateDTO) {
            fieldName = "endDate";
        } else if (obj instanceof CourseApplicationCreateDto || obj instanceof StudentCourseApplicationCreateDto) {
            fieldName = "preferredEndDate";
        } else {
            return true;
        }

        if (!isValid) {
            context.disableDefaultConstraintViolation();
            context.buildConstraintViolationWithTemplate("Дата окончания должна быть после даты начала")
                    .addPropertyNode(fieldName)
                    .addConstraintViolation();
        }

        return isValid;
    }
}
