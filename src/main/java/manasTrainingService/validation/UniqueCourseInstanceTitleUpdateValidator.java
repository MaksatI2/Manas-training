package manasTrainingService.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import manasTrainingService.dto.instance.CourseInstanceUpdateDTO;
import manasTrainingService.service.course.CourseInstanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class UniqueCourseInstanceTitleUpdateValidator implements ConstraintValidator<UniqueCourseInstanceTitleUpdate, CourseInstanceUpdateDTO> {

    @Autowired
    private CourseInstanceService courseInstanceService;

    @Override
    public boolean isValid(CourseInstanceUpdateDTO dto, ConstraintValidatorContext context) {
        if (dto == null || dto.getTitle() == null || dto.getId() == null) {
            return true;
        }

        boolean valid = true;
        context.disableDefaultConstraintViolation();

        if (courseInstanceService.existsByTitleAndIdNot(dto.getTitle(), dto.getId())) {
            context.buildConstraintViolationWithTemplate("Название экземпляра курса уже используется")
                .addPropertyNode("title")
                .addConstraintViolation();
            valid = false;
        }
        return valid;
    }
}