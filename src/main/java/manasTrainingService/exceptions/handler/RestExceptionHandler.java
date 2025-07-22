package manasTrainingService.exceptions.handler;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.ConstraintViolationException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.exceptions.model.ErrorResponseBody;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.service.ErrorService;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MultipartException;

import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

@Slf4j
@RestControllerAdvice(annotations = RestController.class)
@RequiredArgsConstructor
@Order(Ordered.HIGHEST_PRECEDENCE)
public class RestExceptionHandler {
    private final ErrorService errorService;

    @ExceptionHandler(NoAccessException.class)
    public ResponseEntity<ErrorResponseBody> handleNoAccessException(NoAccessException e) {
        log.error("Access denied: {}", e.getMessage());
        return new ResponseEntity<>(
                ErrorResponseBody.builder()
                        .title("Доступ запрещён")
                        .response(Map.of("errors", List.of(e.getMessage() != null ? e.getMessage() : "У вас нет доступа к этому ресурсу.")))
                        .build(),
                HttpStatus.FORBIDDEN
        );
    }

    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ErrorResponseBody> handleEntityNotFoundException(EntityNotFoundException e) {
        log.error("Entity not found: {}", e.getMessage());
        return new ResponseEntity<>(
                ErrorResponseBody.builder()
                        .title("Ресурс не найден")
                        .response(Map.of("errors", List.of(e.getMessage() != null ? e.getMessage() : "Запрошенный ресурс не найден.")))
                        .build(),
                HttpStatus.NOT_FOUND
        );
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponseBody> handleIllegalArgumentException(IllegalArgumentException e) {
        log.error("Invalid argument: {}", e.getMessage());
        return new ResponseEntity<>(
                ErrorResponseBody.builder()
                        .title("Недопустимый аргумент")
                        .response(Map.of("errors", List.of(e.getMessage() != null ? e.getMessage() : "Ошибка в предоставленных данных.")))
                        .build(),
                HttpStatus.BAD_REQUEST
        );
    }

    @ExceptionHandler(MultipartException.class)
    public ResponseEntity<ErrorResponseBody> handleMultipartException(MultipartException e) {
        log.error("Multipart request processing error: {}", e.getMessage());
        return new ResponseEntity<>(errorService.makeResponse(e), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<ErrorResponseBody> handleISE(IllegalStateException e) {
        log.error("IllegalStateException processing error: {}", e.getMessage());
        return new ResponseEntity<>(errorService.makeResponse(e), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ErrorResponseBody> handleRuntime(RuntimeException e) {
        log.error("Runtime error: {}", e.getMessage());
        return new ResponseEntity<>(errorService.makeResponse(e), HttpStatus.CONFLICT);
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ErrorResponseBody> handleConstraintViolation(ConstraintViolationException ex) {
        log.error("Constraint violation: {}", ex.getMessage());
        return new ResponseEntity<>(errorService.makeResponse(ex.getConstraintViolations()), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(NoSuchElementException.class)
    public ResponseEntity<ErrorResponseBody> handleNSEE(NoSuchElementException e) {
        log.error("Resource not found: {}", e.getMessage());
        return new ResponseEntity<>(errorService.makeResponse(e), HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ErrorResponseBody> handleDataIntegrityViolation(DataIntegrityViolationException e) {
        log.error("Data integrity violation: {}", e.getMessage());
        return new ResponseEntity<>(errorService.makeResponse(e), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ErrorResponseBody> handleAccessDenied(AccessDeniedException e) {
        log.error("Access denied: {}", e.getMessage());
        return new ResponseEntity<>(errorService.makeResponse(e), HttpStatus.FORBIDDEN);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponseBody> handleValidation(MethodArgumentNotValidException e) {
        log.error("Validation error: {}", e.getMessage());
        return new ResponseEntity<>(errorService.makeResponse(e.getBindingResult()), HttpStatus.BAD_REQUEST);
    }
}