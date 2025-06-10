package manasTrainingService.exceptions.handler;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.http.HttpStatus;

@Controller
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);

        int statusCode = HttpStatus.INTERNAL_SERVER_ERROR.value();
        String reason = "Internal Server Error";

        if (status != null) {
            try {
                statusCode = Integer.parseInt(status.toString());
                reason = HttpStatus.valueOf(statusCode).getReasonPhrase();
            } catch (Exception ignored) {}
        }

        model.addAttribute("status", statusCode);
        model.addAttribute("reason", reason);
        model.addAttribute("details", request);
        return "error/error";
    }
}
