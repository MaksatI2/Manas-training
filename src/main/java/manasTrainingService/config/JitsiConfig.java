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

    private String baseUrl = "https://manastraining.kg/meet/";
    private String roomPrefix = "ManasTraining";
    private int maxParticipants = 100;
    private boolean enableRecording = false;
    private String apiKey;
    private String apiSecret;

    private String domain = "manastraining.kg";
    private String protocol = "https";
    private int port = 443;

    private Web web = new Web();

    private boolean enableJwt = false;
    private String jwtSecret;
    private String jwtIssuer = "manas-training-center";
    private String jwtAudience = "jitsi";
    private int jwtExpirationHours = 24;

    @Getter
    @Setter
    public static class Web {
        private String url = "https://manastraining.kg";
    }

    public String getMeetingUrl(String roomName) {
        return baseUrl + roomName;
    }

    public String getWebSocketUrl() {
        return "wss://" + domain + "/xmpp-websocket";
    }

    public String getBoshUrl() {
        return "https://" + domain + "/http-bind";
    }
}