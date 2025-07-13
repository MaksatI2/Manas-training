package manasTrainingService.service.impl.user;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.entity.CourseApplication;
import manasTrainingService.entity.User;
import manasTrainingService.service.user.EmailService;
import manasTrainingService.util.StatusUtil;
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
        String message = "<p>Здравствуйте, " + user.getName() + "!</p>" + "<p>Пожалуйста, подтвердите регистрацию:</p>" + "<p><a href=\"" + link + "\">Подтвердить Email</a></p>";

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
            throw new RuntimeException("Ошибка при отправке письма на " + to, e);
        }
    }

    @Override
    public void sendStudentWelcomeEmail(String email, String name, String rawPassword) {
        String subject = "Добро пожаловать в Manas Training Center!";
        String message = """
                <p>Здравствуйте, <strong>%s</strong>!</p>
                <p>Вы были зарегистрированы как студент в системе <strong>Manas Training Center</strong>.</p>
                <p><strong>Ваш временный пароль:</strong> <code>%s</code></p>
                <p>Пожалуйста, войдите в систему и <strong>смените пароль</strong> после первого входа.</p>
                <p>Ссылка на вход: <a href="%s/auth/login">%s/auth/login</a></p>
                """.formatted(name, rawPassword, baseUrl, baseUrl);

        sendEmail(email, subject, message);
    }

    @Override
    public void sendApplicationStatusUpdateEmail(CourseApplication app) {
        String subject = "Изменение статуса заявки №" + app.getId();
        String message = """
                <p>Здравствуйте, %s!</p>
                <p>Статус вашей заявки на курс <strong>%s</strong> был изменён на: <strong>%s</strong>.</p>
                """.formatted(
                app.getSubmittedBy().getName(),
                app.getCourse().getTitle(),
                StatusUtil.localize(app.getStatus())
        );

        sendEmail(app.getSubmittedBy().getEmail(), subject, message);
    }

    @Override
    public void sendNewCommentNotification(CourseApplication app, String comment, User author) {
        String subject = "Новый комментарий к вашей заявке №" + app.getId();
        String message = """
                <p>Здравствуйте, %s!</p>
                <p>К вашей заявке на курс <strong>%s</strong> добавлен комментарий от %s:</p>
                <blockquote>%s</blockquote>
                """.formatted(
                app.getSubmittedBy().getName(),
                app.getCourse().getTitle(),
                author.getName() + " " + author.getLastName(),
                comment
        );

        sendEmail(app.getSubmittedBy().getEmail(), subject, message);
    }


}
