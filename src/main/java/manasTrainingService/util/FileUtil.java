package manasTrainingService.util;

import lombok.extern.slf4j.Slf4j;
import manasTrainingService.exceptions.nsee.ForbiddenFileTypeException;
import manasTrainingService.exceptions.nsee.FileProcessingException;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import java.util.Arrays;
import java.util.List;

@Slf4j
@Service
public class FileUtil {
    private static final String UPLOAD_DIR = "data/";
    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(".jpg", ".jpeg");
    private static final List<String> ALLOWED_MIME_TYPES = Arrays.asList("image/jpeg", "image/jpg");

    public String saveUploadFile(MultipartFile file, String subDir) {
        log.info("Начинаем сохранение файла: {}, размер: {} байт",
                file.getOriginalFilename(), file.getSize());

        validateFile(file);

        try {
            String uuid = UUID.randomUUID().toString();
            String fileName = uuid + "_" + file.getOriginalFilename();
            Path pathDir = Paths.get(UPLOAD_DIR + subDir);

            Files.createDirectories(pathDir);
            log.debug("Директория создана/проверена: {}", pathDir);

            Path filePath = Paths.get(pathDir.toString(), fileName);

            try (OutputStream outputStream = Files.newOutputStream(filePath)) {
                outputStream.write(file.getBytes());
                log.info("Файл успешно сохранен: {}", fileName);
            }

            return fileName;

        } catch (IOException e) {
            log.error("Ошибка при сохранении файла {}: {}", file.getOriginalFilename(), e.getMessage(), e);
            throw new FileProcessingException("Не удалось сохранить файл: " + e.getMessage());
        }
    }

    public void removeOldImage(String oldFile, String subDir) {
        if (oldFile == null || oldFile.trim().isEmpty()) {
            log.debug("Старый файл не указан, пропускаем удаление");
            return;
        }

        try {
            Path pathDir = Paths.get(UPLOAD_DIR + subDir);
            Path filePath = Paths.get(pathDir.toString(), oldFile);

            if (Files.exists(filePath)) {
                Files.delete(filePath);
                log.info("Старый файл удален: {}", oldFile);
            } else {
                log.debug("Старый файл не найден: {}", filePath);
            }

        } catch (IOException e) {
            log.error("Ошибка при удалении старого файла {}: {}", oldFile, e.getMessage(), e);
        }
    }

    private void validateFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Файл не может быть пустым");
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || originalFilename.trim().isEmpty()) {
            throw new IllegalArgumentException("Имя файла не может быть пустым");
        }

        if (!checkFileExtension(originalFilename)) {
            log.warn("Недопустимое расширение файла: {}", originalFilename);
            throw new ForbiddenFileTypeException("Поддерживаются только файлы с расширением: " +
                                                 String.join(", ", ALLOWED_EXTENSIONS));
        }

        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_MIME_TYPES.contains(contentType.toLowerCase())) {
            log.warn("Недопустимый MIME тип: {} для файла: {}", contentType, originalFilename);
            throw new ForbiddenFileTypeException("Поддерживаются только изображения в формате JPEG");
        }

        log.debug("Валидация файла прошла успешно: {}", originalFilename);
    }

    private boolean checkFileExtension(String fileName) {
        if (fileName == null) return false;

        String lowerCaseFileName = fileName.toLowerCase();
        return ALLOWED_EXTENSIONS.stream()
                .anyMatch(lowerCaseFileName::endsWith);
    }
}