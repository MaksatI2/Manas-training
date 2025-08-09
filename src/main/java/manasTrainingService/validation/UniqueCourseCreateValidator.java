package manasTrainingService.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import manasTrainingService.dto.create.CreateCourseDto;
import manasTrainingService.service.course.CourseAdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class UniqueCourseCreateValidator implements ConstraintValidator<UniqueCourseCreate, CreateCourseDto> {

    @Autowired
    private CourseAdminService courseService;

    @Override
    public boolean isValid(CreateCourseDto dto, ConstraintValidatorContext context) {
        boolean valid = true;
        context.disableDefaultConstraintViolation();

        if (dto.getCode() != null && courseService.existsByCode(dto.getCode().strip())) {
            context.buildConstraintViolationWithTemplate("Код курса уже используется")
                .addPropertyNode("code").addConstraintViolation();
            valid = false;
        }

        if (dto.getTitle() != null && courseService.existsByTitle(dto.getTitle().strip())) {
            context.buildConstraintViolationWithTemplate("Название курса уже используется")
                .addPropertyNode("title").addConstraintViolation();
            valid = false;
        }

        return valid;
    }
}