package manasTrainingService.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "jitsi")
@Getter
@Setter
public class JitsiConfig {

    private String baseUrl = "https://meet.jit.si/";
    private String roomPrefix = "manas-training-center";
    private int maxParticipants = 100;
    private boolean enableRecording = false;
    private String apiKey;
    private String apiSecret;

    private boolean enableJwt = false;
    private String jwtSecret;
    private String jwtIssuer = "manas-training-center";
    private String jwtAudience = "jitsi";
    private int jwtExpirationHours = 24;
}