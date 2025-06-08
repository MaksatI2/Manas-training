package manasTrainingService.exceptions.advice;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.exceptions.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.ui.Model;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.NoSuchElementException;

@Slf4j
@ControllerAdvice
@RequiredArgsConstructor
public class GlobalControllerAdvice {


    @ExceptionHandler(NoSuchElementException.class)
    public String notFound(HttpServletRequest request, Model model) {
        model.addAttribute("status", HttpStatus.NOT_FOUND.value());
        model.addAttribute("reason", HttpStatus.NOT_FOUND.getReasonPhrase());
        model.addAttribute("details", request);
        return "errors/error";
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public String handleValidationException(MethodArgumentNotValidException e,
                                            HttpServletRequest request, Model model) {
        log.error("Ошибка валидации: {}", e.getMessage());
        prepareErrorModel(model, HttpStatus.BAD_REQUEST, request);
        model.addAttribute("message", "Ошибка валидации данных");
        return "errors/error";
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public String handleTypeMismatch(MethodArgumentTypeMismatchException e,
                                     HttpServletRequest request, Model model) {
        String errorMessage = String.format(
                "Ошибка преобразования параметра '%s'", e.getName());
        log.error(errorMessage);
        prepareErrorModel(model, HttpStatus.BAD_REQUEST, request);
        model.addAttribute("message", errorMessage);
        return "errors/error";
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public String handleConstraintViolation(ConstraintViolationException e,
                                            HttpServletRequest request, Model model) {
        log.error("Ошибка валидации параметров: {}", e.getMessage());
        prepareErrorModel(model, HttpStatus.BAD_REQUEST, request);
        model.addAttribute("message", "Ошибка валидации параметров");
        return "errors/error";
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public String handleHttpMessageNotReadable(HttpMessageNotReadableException e,
                                               HttpServletRequest request, Model model) {
        log.error("Ошибка чтения запроса: {}", e.getMessage());
        String message = "Неверный формат запроса";
        prepareErrorModel(model, HttpStatus.BAD_REQUEST, request);
        model.addAttribute("message", message);
        return "errors/error";
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public String handleMissingParams(MissingServletRequestParameterException e,
                                      HttpServletRequest request, Model model) {
        String message = String.format("Отсутствует обязательный параметр: '%s'", e.getParameterName());
        log.error(message);
        prepareErrorModel(model, HttpStatus.BAD_REQUEST, request);
        model.addAttribute("message", message);
        return "errors/error";
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public String handleMethodNotSupported(HttpRequestMethodNotSupportedException e,
                                           HttpServletRequest request, Model model) {
        log.error("Метод не поддерживается: {}", e.getMessage());
        prepareErrorModel(model, HttpStatus.METHOD_NOT_ALLOWED, request);
        model.addAttribute("message", "Метод не поддерживается");
        return "errors/error";
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public String handleIllegalArgument(HttpServletRequest request, Model model) {
        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", HttpStatus.BAD_REQUEST.getReasonPhrase());
        model.addAttribute("details",request);
        return "errors/error";
    }

    @ExceptionHandler(Exception.class)
    public String handleAllOtherExceptions(Exception e, HttpServletRequest request, Model model) {
        log.error("Общая ошибка: {}", e.getMessage(), e);
        prepareErrorModel(model, HttpStatus.INTERNAL_SERVER_ERROR, request);
        model.addAttribute("message", "Внутренняя ошибка сервера");
        return "errors/error";
    }

    @ExceptionHandler(NoHandlerFoundException.class)
    public String handleNoHandlerFound(
                                       HttpServletRequest request,
                                       Model model) {
        log.error("Запрошенный URL не найден: {}", request.getRequestURI());
        prepareErrorModel(model, HttpStatus.NOT_FOUND, request);
        return "errors/error";
    }

    @ExceptionHandler(UserNotFoundException.class)
    public String userNotFoundException(
            HttpServletRequest request,
            Model model) {
        log.error("Пользователь не найден: {}", request.getRequestURI());
        prepareErrorModel(model, HttpStatus.NOT_FOUND, request);
        return "errors/error";
    }

    @ExceptionHandler(UsernameNotFoundException.class)
    public String userNameNotFoundException(
            HttpServletRequest request,
            Model model) {
        log.error("Пользователь с таким именем не найден: {}", request.getRequestURI());
        prepareErrorModel(model, HttpStatus.NOT_FOUND, request);
        return "errors/error";
    }

    @ExceptionHandler(RoleNotFoundException.class)
    public String roleNotFoundException(
            HttpServletRequest request,
            Model model) {
        log.error("Тип аккаунта не найден: {}", request.getRequestURI());
        prepareErrorModel(model, HttpStatus.NOT_FOUND, request);
        return "errors/error";
    }

    @ExceptionHandler(UserAlreadyExistsException.class)
    public String handleUserAlreadyExists(UserAlreadyExistsException e,
                                          HttpServletRequest request, Model model) {
        log.error("Пользователь уже существует: {}", e.getMessage());
        prepareErrorModel(model, HttpStatus.BAD_REQUEST, request);
        model.addAttribute("message", e.getMessage());
        return "errors/error";
    }

    @ExceptionHandler(OrganizationEmailAlreadyExistsException.class)
    public String organizationEmailAlreadyExistsException(UserAlreadyExistsException e,
                                          HttpServletRequest request, Model model) {
        log.error("Организация с такой почтой уже существует: {}", e.getMessage());
        prepareErrorModel(model, HttpStatus.BAD_REQUEST, request);
        model.addAttribute("message", e.getMessage());
        return "errors/error";
    }

    @ExceptionHandler(OrganizationPhoneAlreadyExistsException.class)
    public String organizationPhoneAlreadyExistsException(UserAlreadyExistsException e,
                                                          HttpServletRequest request, Model model) {
        log.error("Данный номер телефона уже существует: {}", e.getMessage());
        prepareErrorModel(model, HttpStatus.BAD_REQUEST, request);
        model.addAttribute("message", e.getMessage());
        return "errors/error";
    }

    @ExceptionHandler(OrganizationNameAlreadyExistsException.class)
    public String organizationNameAlreadyExistsException(UserAlreadyExistsException e,
                                                          HttpServletRequest request, Model model) {
        log.error("Организация с таким названием уже существует: {}", e.getMessage());
        prepareErrorModel(model, HttpStatus.BAD_REQUEST, request);
        model.addAttribute("message", e.getMessage());
        return "errors/error";
    }

    @ExceptionHandler(StudentEmailAlreadyExistsException.class)
    public String studentEmailAlreadyExistsException(UserAlreadyExistsException e,
                                                         HttpServletRequest request, Model model) {
        log.error("Студент с такой почтой уже существует: {}", e.getMessage());
        prepareErrorModel(model, HttpStatus.BAD_REQUEST, request);
        model.addAttribute("message", e.getMessage());
        return "errors/error";
    }

    @ExceptionHandler(StudentPhoneAlreadyExistsException.class)
    public String studentPhoneAlreadyExistsException(UserAlreadyExistsException e,
                                                     HttpServletRequest request, Model model) {
        log.error("Студент с таким номером уже существует: {}", e.getMessage());
        prepareErrorModel(model, HttpStatus.BAD_REQUEST, request);
        model.addAttribute("message", e.getMessage());
        return "errors/error";
    }

    @ExceptionHandler(OrganizationCodeNotFound.class)
    public String organizationCodeNotFound(
            HttpServletRequest request,
            Model model) {
        log.error("Организация с таким кодом не найдена: {}", request.getRequestURI());
        prepareErrorModel(model, HttpStatus.NOT_FOUND, request);
        return "errors/error";
    }

    private void prepareErrorModel(Model model, HttpStatus status, HttpServletRequest request) {
        model.addAttribute("status", status.value());
        model.addAttribute("reason", status.getReasonPhrase());
        model.addAttribute("details", request);
    }

}