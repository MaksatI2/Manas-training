package manasTrainingService.exceptions.handler;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.exceptions.nsee.NoAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.NoSuchElementException;

@Slf4j
@Controller
@RequiredArgsConstructor
public class CustomErrorController implements org.springframework.boot.web.servlet.error.ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute("jakarta.servlet.error.status_code");
        Object message = request.getAttribute("jakarta.servlet.error.message");
        Object exception = request.getAttribute("jakarta.servlet.error.exception");

        Integer statusCode = status != null ? (Integer) status : HttpStatus.INTERNAL_SERVER_ERROR.value();
        String reason = HttpStatus.valueOf(statusCode).getReasonPhrase();
        String errorMessage = message != null && !message.toString().isEmpty() ? message.toString() : getDefaultMessage(statusCode);
        String viewName = getViewName(statusCode, exception);

        log.error("Error occurred: status={}, message={}, exception={}",
                statusCode,
                errorMessage,
                exception != null ? exception.getClass().getSimpleName() : "none");

        model.addAttribute("status", statusCode);
        model.addAttribute("reason", reason);
        model.addAttribute("message", errorMessage);
        model.addAttribute("details", request);

        return viewName;
    }

    private String getViewName(Integer statusCode, Object exception) {
        if (exception instanceof NoAccessException || exception instanceof org.springframework.security.access.AccessDeniedException) {
            return "error/403";
        } else if (exception instanceof EntityNotFoundException || exception instanceof NoSuchElementException) {
            return "error/404";
        } else if (exception instanceof IllegalArgumentException ||
                exception instanceof jakarta.validation.ConstraintViolationException ||
                exception instanceof org.springframework.web.bind.MethodArgumentNotValidException ||
                exception instanceof org.springframework.web.multipart.MultipartException) {
            return "error/400";
        }

        return switch (statusCode) {
            case 400 -> "error/400";
            case 403 -> "error/403";
            case 404 -> "error/404";
            default -> "error/500";
        };
    }

    private String getDefaultMessage(Integer statusCode) {
        return switch (statusCode) {
            case 400 -> "Ошибка в предоставленных данных. Пожалуйста, проверьте введенные данные и попробуйте снова.";
            case 403 -> "У вас пока нет доступа к этому разделу. Дождитесь подтверждения или обратитесь к администратору.";
            case 404 -> "Мы не нашли такого пользователя или учебного материала. Проверьте данные или уточните в службе поддержки.";
            default -> "На сервере возникла техническая ошибка. Команда техподдержки уже решает проблему.";
        };
    }
}