package manasTrainingService.service.impl.user;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.entity.CourseApplication;
import manasTrainingService.entity.User;
import manasTrainingService.service.user.EmailService;
import manasTrainingService.util.StatusUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailServiceImpl implements EmailService {

    private final JavaMailSender mailSender;
    private final AsyncEmailSenderService asyncEmailSender;


    @Value("${app.email.from:noreply@manastraining.kg}")
    private String from;

    @Value("${app.base-url:http://localhost:8089}")
    private String baseUrl;

    @Override
    public void sendVerificationEmail(User user, String token) {
        String subject = "Подтверждение регистрации";
        String link = baseUrl + "/auth/verify-email?token=" + token;

        String message = """
    <html>
    <body style="font-family: Arial, sans-serif; background-color: #f7f9fc; padding: 20px;">
        <div style="max-width: 600px; margin: auto; background: white; border-radius: 8px; padding: 20px; border: 1px solid #e0e0e0;">
            <h2 style="color: #333;">Здравствуйте, %s!</h2>
            <p style="color: #555; font-size: 15px;">
                Спасибо за регистрацию в <strong>Manas Training Service</strong>!<br>
                Чтобы завершить процесс, пожалуйста, подтвердите ваш адрес электронной почты.
            </p>
            <p style="text-align: center; margin: 30px 0;">
                <a href="%s" style="background-color: #007BFF; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-size: 16px;">
                    ✅ Подтвердить Email
                </a>
            </p>
            <p style="color: #888; font-size: 13px;">
                Если кнопка не работает, скопируйте и вставьте эту ссылку в адресную строку браузера:<br>
                <a href="%s" style="color: #007BFF;">%s</a>
            </p>
            <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
            <p style="color: #999; font-size: 12px;">
                Это письмо отправлено автоматически. Пожалуйста, не отвечайте на него.
            </p>
        </div>
    </body>
    </html>
    """.formatted(user.getName(), link, link, link);

        asyncEmailSender.sendEmail(user.getEmail(), subject, message);
    }



    @Override
    public void sendPasswordResetEmail(User user, String token) {
        String subject = "Сброс пароля";
        String link = baseUrl + "/auth/reset-password?token=" + token;

        String message = """
        <html>
        <body style="font-family: Arial, sans-serif; background-color: #f7f9fc; padding: 20px;">
            <div style="max-width: 600px; margin: auto; background: white; border-radius: 8px; padding: 20px; border: 1px solid #e0e0e0;">
                <h2 style="color: #333;">Здравствуйте, %s!</h2>
                <p style="color: #555; font-size: 15px;">
                    Вы запросили сброс пароля для своей учётной записи в <strong>Manas Training Center</strong>.<br>
                    Для продолжения нажмите кнопку ниже:
                </p>
                <p style="text-align: center; margin: 30px 0;">
                    <a href="%s" style="background-color: #007BFF; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-size: 16px;">
                        🔒 Сбросить пароль
                    </a>
                </p>
                <p style="color: #888; font-size: 13px;">
                    Если кнопка не работает, используйте эту ссылку:<br>
                    <a href="%s" style="color: #007BFF;">%s</a>
                </p>
                <p style="color: #888; font-size: 13px;">
                    Если вы не запрашивали сброс, просто проигнорируйте это письмо.
                </p>
                <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                <p style="color: #999; font-size: 12px;">
                    Это письмо отправлено автоматически. Пожалуйста, не отвечайте на него.
                </p>
            </div>
        </body>
        </html>
        """.formatted(user.getName(), link, link, link);

        asyncEmailSender.sendEmail(user.getEmail(), subject, message);
    }

    @Override
    public void sendStudentWelcomeEmail(String email, String name, String rawPassword) {
        String subject = "Добро пожаловать в Manas Training Center!";

        String loginUrl = baseUrl + "/auth/login";

        String message = """
        <html>
        <body style="font-family: Arial, sans-serif; background-color: #f7f9fc; padding: 20px;">
            <div style="max-width: 600px; margin: auto; background: white; border-radius: 8px; padding: 20px; border: 1px solid #e0e0e0;">
                <h2 style="color: #333;">Здравствуйте, %s!</h2>
                <p style="color: #555; font-size: 15px;">
                    Вы были успешно зарегистрированы как студент в системе <strong>Manas Training Center</strong>.
                </p>
                <p style="color: #555; font-size: 15px;">
                    <strong>Ваш временный пароль:</strong> <code style="background: #eef3fc; padding: 3px 6px; border-radius: 4px;">%s</code>
                </p>
                <p style="color: #555; font-size: 15px;">
                    Пожалуйста, войдите в систему и <strong>смените пароль</strong> после первого входа.
                </p>
                <p style="text-align: center; margin: 30px 0;">
                    <a href="%s" style="background-color: #007BFF; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-size: 16px;">
                        🔑 Войти в систему
                    </a>
                </p>
                <p style="color: #888; font-size: 13px;">
                    Если кнопка не работает, используйте эту ссылку:<br>
                    <a href="%s" style="color: #007BFF;">%s</a>
                </p>
                <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                <p style="color: #999; font-size: 12px;">
                    Это письмо отправлено автоматически. Пожалуйста, не отвечайте на него.
                </p>
            </div>
        </body>
        </html>
        """.formatted(name, rawPassword, loginUrl, loginUrl, loginUrl);

        asyncEmailSender.sendEmail(email, subject, message);
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

        asyncEmailSender.sendEmail(app.getSubmittedBy().getEmail(), subject, message);
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

        asyncEmailSender.sendEmail(app.getSubmittedBy().getEmail(), subject, message);
    }


}
