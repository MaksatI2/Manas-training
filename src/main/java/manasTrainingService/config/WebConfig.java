package manasTrainingService.config;

import org.apache.catalina.valves.RemoteIpValve;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/data/**").addResourceLocations("file:data/");
        registry.addResourceHandler("/js/**").addResourceLocations("classpath:/static/js/");
        registry.addResourceHandler("/css/**").addResourceLocations("classpath:/static/css/");
        registry.addResourceHandler("/images/**").addResourceLocations("classpath:/static/images/");
    }

    @Bean
    public WebServerFactoryCustomizer<TomcatServletWebServerFactory> tomcatCustomizer() {
        return factory -> {
            RemoteIpValve valve = new RemoteIpValve();
            valve.setRemoteIpHeader("x-forwarded-for");
            valve.setProtocolHeader("x-forwarded-proto");
            valve.setHostHeader("x-forwarded-host");
            valve.setPortHeader("x-forwarded-port");
            valve.setProtocolHeaderHttpsValue("https");
            valve.setInternalProxies("10\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}|" +
                                     "192\\.168\\.\\d{1,3}\\.\\d{1,3}|" +
                                     "169\\.254\\.\\d{1,3}\\.\\d{1,3}|" +
                                     "127\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}|" +
                                     "172\\.1[6-9]{1}\\.\\d{1,3}\\.\\d{1,3}|" +
                                     "172\\.2[0-9]{1}\\.\\d{1,3}\\.\\d{1,3}|" +
                                     "172\\.3[0-1]{1}\\.\\d{1,3}\\.\\d{1,3}");
            factory.addEngineValves(valve);
        };
    }
}
