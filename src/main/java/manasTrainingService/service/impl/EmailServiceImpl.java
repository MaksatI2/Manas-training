package manasTrainingService.service.impl;

import manasTrainingService.service.EmailService;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.entity.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailServiceImpl implements EmailService {

    private final JavaMailSender mailSender;

    @Value("${app.email.from:noreply@manastraining.kg}")
    private String from;

    @Value("${app.base-url:http://localhost:8089}")
    private String baseUrl;

    @Override
    public void sendVerificationEmail(User user, String token) {
        String subject = "Подтверждение регистрации";
        String link = baseUrl + "/auth/verify-email?token=" + token;
        String message = "<p>Здравствуйте, " + user.getName() + "!</p>" + "<p>Пожалуйста, подтвердите свою регистрацию по ссылке ниже:</p>" + "<p><a href=\"" + link + "\">Подтвердить Email</a></p>" + "<p>Если вы не регистрировались, просто проигнорируйте это письмо.</p>";

        sendEmail(user.getEmail(), subject, message);
    }

    @Override
    public void sendPasswordResetEmail(User user, String token) {
        String subject = "Сброс пароля";
        String link = baseUrl + "/auth/reset-password?token=" + token;
        String message = "<p>Здравствуйте, " + user.getName() + "!</p>" + "<p>Для сброса пароля перейдите по ссылке ниже:</p>" + "<p><a href=\"" + link + "\">Сбросить пароль</a></p>" + "<p>Если вы не запрашивали сброс, просто проигнорируйте это письмо.</p>";

        sendEmail(user.getEmail(), subject, message);
    }

    private void sendEmail(String to, String subject, String htmlContent) {
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
        }
    }
}
