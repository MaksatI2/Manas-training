
package manasTrainingService.util;

import lombok.RequiredArgsConstructor;
import manasTrainingService.config.JitsiConfig;
import org.springframework.stereotype.Component;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Component
@RequiredArgsConstructor
public class JitsiUrlBuilder {

    private final JitsiConfig jitsiConfig;

    public String buildMeetingUrl(String roomName) {
        String fullRoomName = jitsiConfig.getRoomPrefix() + roomName;
        return jitsiConfig.getBaseUrl() + URLEncoder.encode(fullRoomName, StandardCharsets.UTF_8);
    }
}