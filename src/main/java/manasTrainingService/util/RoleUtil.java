package manasTrainingService.util;

import java.util.HashMap;
import java.util.Map;

public class RoleUtil {

    private static final Map<String, String> RUSSIAN_ROLE_NAMES = new HashMap<>();

    static {
        RUSSIAN_ROLE_NAMES.put("ADMIN", "Администратор");
        RUSSIAN_ROLE_NAMES.put("TEACHER", "Преподаватель");
        RUSSIAN_ROLE_NAMES.put("STUDENT", "Студент");
        RUSSIAN_ROLE_NAMES.put("ORGANIZATION", "Организация");
    }

    public static String localize(String roleName) {
        return RUSSIAN_ROLE_NAMES.getOrDefault(roleName, "Неизвестно");
    }

    public static Map<String, String> getAll() {
        return RUSSIAN_ROLE_NAMES;
    }
}
