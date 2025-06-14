package manasTrainingService.exceptions.handler;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import jakarta.validation.ValidationException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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

    @ExceptionHandler(MultipartException.class)
    public String handleMultipartException(Model model, HttpServletRequest request, MultipartException e) {
        log.error("MultipartException processing error: {}",e.getMessage());
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("details", request);
        return "error/error";
    }

    @ExceptionHandler(IllegalStateException.class)
    public String handleISE(Model model, HttpServletRequest request, IllegalStateException e) {
        log.error("IllegalStateException processing error: {}", e.getMessage());
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("details", request);
        return "error/error";
    }

    @ExceptionHandler(RuntimeException.class)
    public String handleRuntime(Model model, HttpServletRequest request, RuntimeException e) {
        log.error(e.getMessage());
        model.addAttribute("status", HttpStatus.CONFLICT.value());
        model.addAttribute("reason", HttpStatus.CONFLICT.getReasonPhrase());
        model.addAttribute("details", request);
        return "error/error";
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public String handleIAE(Model model, HttpServletRequest request, IllegalArgumentException e) {
        log.error(e.getMessage());
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("details", request);
        return "error/error";
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public String handleConstraintViolation(Model model, HttpServletRequest request, ConstraintViolationException ex) {
        log.error(ex.getMessage());
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("details", request);
        return "error/error";
    }

    @ExceptionHandler(NoSuchElementException.class)
    public String handleNSEE(Model model, HttpServletRequest request, NoSuchElementException e) {
        log.error(e.getMessage());
        model.addAttribute("status", HttpStatus.NOT_FOUND.value());
        model.addAttribute("reason", HttpStatus.NOT_FOUND.getReasonPhrase());
        model.addAttribute("details", request);
        return "error/error";
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public String handleDataIntegrityViolation(Model model, HttpServletRequest request, DataIntegrityViolationException e) {
        log.error(e.getMessage());
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("details", request);
        return "error/error";
    }

    @ExceptionHandler(AccessDeniedException.class)
    public String handleAccessDenied(Model model, HttpServletRequest request, AccessDeniedException e) {
        log.error(e.getMessage());
        model.addAttribute("status", HttpStatus.FORBIDDEN.value());
        model.addAttribute("reason", HttpStatus.FORBIDDEN.getReasonPhrase());
        model.addAttribute("details", request);
        return "error/error";
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public String handleValidation(Model model, HttpServletRequest request, MethodArgumentNotValidException e) {
        log.error(e.getMessage());
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("details", request);
        return "error/error";
    }

    @ExceptionHandler(EntityNotFoundException.class)
    public String handleEntityNotFound(EntityNotFoundException e, Model model) {
        log.error("Entity not found: {}", e.getMessage());
        model.addAttribute("status", "404");
        model.addAttribute("reason", "Ресурс не найден");
        model.addAttribute("errorMessage", e.getMessage());
        return "error/error";
    }

    @ExceptionHandler(ValidationException.class)
    public String handleValidation(ValidationException e, Model model) {
        log.error("Validation error: {}", e.getMessage());
        model.addAttribute("status", "400");
        model.addAttribute("reason", "Ошибка валидации");
        model.addAttribute("errorMessage", e.getMessage());
        return "error/400";
    }
}