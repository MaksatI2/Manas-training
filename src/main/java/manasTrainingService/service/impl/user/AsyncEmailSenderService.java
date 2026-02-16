package manasTrainingService.service.impl.user;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class AsyncEmailSenderService {

    private final JavaMailSender mailSender;

    @Value("${app.email.from:noreply@manastraining.kg}")
    private String from;

    @org.springframework.beans.factory.annotation.Value("${app.base-url:http://localhost:8089}")
    private String baseUrl;

    public AsyncEmailSenderService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    @Async
    public void sendEmail(String to, String subject, String htmlContent) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(from);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlContent, true);

            mailSender.send(message);
            log.info("Письмо отправлено на: {}", to);
        } catch (MessagingException e) {
            log.error("Ошибка при отправке письма на: " + to, e);
            throw new RuntimeException("Ошибка при отправке письма на " + to, e);
        }
    }
}
