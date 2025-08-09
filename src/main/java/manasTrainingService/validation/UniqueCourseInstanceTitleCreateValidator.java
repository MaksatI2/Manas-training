package manasTrainingService.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import manasTrainingService.dto.CourseInstanceCreationDTO;
import manasTrainingService.service.course.CourseInstanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class UniqueCourseInstanceTitleCreateValidator implements ConstraintValidator<UniqueCourseInstanceTitleCreate, CourseInstanceCreationDTO> {

    @Autowired
    private CourseInstanceService courseInstanceService;

    @Override
    public boolean isValid(CourseInstanceCreationDTO dto, ConstraintValidatorContext context) {
        if (dto == null || dto.getTitle() == null) {
            return true;
        }

        boolean valid = true;
        context.disableDefaultConstraintViolation();

        if (courseInstanceService.existsByTitle(dto.getTitle())) {
            context.buildConstraintViolationWithTemplate("Название экземпляра курса уже используется")
                .addPropertyNode("title")
                .addConstraintViolation();
            valid = false;
        }
        return valid;
    }
}