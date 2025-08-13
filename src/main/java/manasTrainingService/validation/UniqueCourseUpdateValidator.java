package manasTrainingService.validation;

import manasTrainingService.dto.edit.CourseEditDto;
import org.springframework.stereotype.Component;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import manasTrainingService.service.course.CourseAdminService;
import org.springframework.beans.factory.annotation.Autowired;

@Component
public class UniqueCourseUpdateValidator implements ConstraintValidator<UniqueCourseUpdate, CourseEditDto> {

    @Autowired
    private CourseAdminService courseService;

    @Override
    public boolean isValid(CourseEditDto dto, ConstraintValidatorContext context) {
        boolean valid = true;
        context.disableDefaultConstraintViolation();

        if (dto.getCode() != null && courseService.existsByCodeAndIdNot(dto.getCode().strip(), dto.getId())) {
            context.buildConstraintViolationWithTemplate("{UniqueCourseCode.message}")
                    .addPropertyNode("code").addConstraintViolation();
            valid = false;
        }

        if (dto.getTitle() != null && courseService.existsByTitleAndIdNot(dto.getTitle().strip(), dto.getId())) {
            context.buildConstraintViolationWithTemplate("{UniqueCourseTitle.message}")
                    .addPropertyNode("title").addConstraintViolation();
            valid = false;
        }

        return valid;
    }
}