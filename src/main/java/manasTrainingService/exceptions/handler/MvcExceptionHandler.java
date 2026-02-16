package manasTrainingService.exceptions.handler;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import jakarta.validation.ValidationException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.exceptions.nsee.NoAccessException;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MultipartException;

import java.util.NoSuchElementException;

@Slf4j
@ControllerAdvice(annotations = Controller.class)
@RequiredArgsConstructor
@Order(Ordered.LOWEST_PRECEDENCE)
public class MvcExceptionHandler {
    private final MessageSource messageSource;

    @ExceptionHandler({AccessDeniedException.class, NoAccessException.class})

    public String handleForbidden(Model model, HttpServletRequest request, Exception e) {
        log.error("Access denied: {}", e.getMessage());
        model.addAttribute("status", HttpStatus.FORBIDDEN.value());
        model.addAttribute("reason", HttpStatus.FORBIDDEN.getReasonPhrase());
        String defaultMessage = messageSource.getMessage(
                "access.denied.default", null,
                "У вас пока нет доступа к этому разделу. Дождитесь подтверждения или обратитесь к администратору.",
                LocaleContextHolder.getLocale()
        );

        model.addAttribute("message", e.getMessage() != null ? e.getMessage() : defaultMessage);
        model.addAttribute("details", request);
        return "error/403";
    }


    @ExceptionHandler({EntityNotFoundException.class, NoSuchElementException.class})
    public String handleEntityNotFoundException(Model model, HttpServletRequest request, Exception e) {
        log.error("Entity not found: {}", e.getMessage());
        model.addAttribute("status", HttpStatus.NOT_FOUND.value());
        model.addAttribute("reason", HttpStatus.NOT_FOUND.getReasonPhrase());
        String defaultMessage = messageSource.getMessage(
                "error.entity.notfound",
                null,
                "Мы не нашли нужной страницы. Проверьте данные.",
                LocaleContextHolder.getLocale()
        );

        model.addAttribute("message", e.getMessage() != null ? e.getMessage() : defaultMessage);        model.addAttribute("details", request);
        return "error/404";
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public String handleIllegalArgumentException(Model model, HttpServletRequest request, IllegalArgumentException e) {
        log.error("Invalid argument: {}", e.getMessage());
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("message", e.getMessage() != null ? e.getMessage() : "Ошибка в предоставленных данных. Пожалуйста, проверьте введенные данные и попробуйте снова.");
        model.addAttribute("details", request);
        return "error/400";
    }

    @ExceptionHandler(MultipartException.class)
    public String handleMultipartException(Model model, HttpServletRequest request, MultipartException e) {
        log.error("MultipartException processing error: {}", e.getMessage());
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("message", "Ошибка при загрузке файла. Проверьте формат или размер файла.");
        model.addAttribute("details", request);
        return "error/400";
    }

    @ExceptionHandler(IllegalStateException.class)
    public String handleISE(Model model, HttpServletRequest request, IllegalStateException e) {
        log.error("IllegalStateException processing error: {}", e.getMessage());
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("message", "Встречено недопустимое состояние. Попробуйте снова или обратитесь в поддержку.");
        model.addAttribute("details", request);
        return "error/400";
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public String handleConstraintViolation(Model model, HttpServletRequest request, ConstraintViolationException ex) {
        log.error("Constraint violation: {}", ex.getMessage());
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("message", "Ошибка валидации данных. Проверьте введенные данные.");
        model.addAttribute("details", request);
        return "error/400";
    }



    @ExceptionHandler(DataIntegrityViolationException.class)
    public String handleDataIntegrityViolation(Model model, HttpServletRequest request, DataIntegrityViolationException e) {
        log.error("Data integrity violation: {}", e.getMessage());
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("message", "Ошибка данных. Возможно, данные уже существуют или некорректны.");
        model.addAttribute("details", request);
        return "error/400";
    }


    @ExceptionHandler(MethodArgumentNotValidException.class)
    public String handleValidation(Model model, HttpServletRequest request, MethodArgumentNotValidException e) {
        log.error("Validation error: {}", e.getMessage());
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("message", "Ошибка валидации данных. Проверьте введенные данные.");
        model.addAttribute("details", request);
        return "error/400";
    }

    @ExceptionHandler(Exception.class)
    public String handleGeneralException(Model model, HttpServletRequest request, Exception e) {
        log.error("Internal server error: {}", e.getMessage());
        model.addAttribute("status", HttpStatus.INTERNAL_SERVER_ERROR.value());
        model.addAttribute("reason", HttpStatus.INTERNAL_SERVER_ERROR.getReasonPhrase());
        model.addAttribute("message", "На сервере возникла техническая ошибка. Команда техподдержки уже решает проблему.");
        model.addAttribute("details", request);
        return "error/500";
    }
}