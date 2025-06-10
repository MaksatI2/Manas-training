package manasTrainingService.util;

import lombok.SneakyThrows;
import manasTrainingService.exceptions.nsee.ForbiddenFileTypeException;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class FileUtil {
    private static String UPLOAD_DIR = "data/";

    @SneakyThrows
    public String saveUploadFile(MultipartFile file, String subDir) {
        if(!checkContentType(file.getOriginalFilename())) {
            throw new ForbiddenFileTypeException();
        }
        String uuid = UUID.randomUUID().toString();
        String fileName = uuid + "_" + file.getOriginalFilename();
        Path pathDir  = Paths.get(UPLOAD_DIR + subDir);
        Files.createDirectories(pathDir);
        Path filePath = Paths.get(pathDir + "/" +fileName);
        if(!Files.exists(filePath)) {
            Files.createFile(filePath);
        }
        try (OutputStream outputStream = Files.newOutputStream(filePath)) {
            outputStream.write(file.getBytes());
        }catch (IOException e){
            e.printStackTrace();
        }
        return fileName;
    }

    public void removeOldImage(String oldFile, String subDir) {
        Path pathDir  = Paths.get(UPLOAD_DIR + subDir);
        Path filePath = Paths.get(pathDir + "/" + oldFile);
        if(!Files.exists(filePath)) {
            return;
        }
        try {
            Files.deleteIfExists(filePath);
        }catch (IOException e){
            e.printStackTrace();
        }
    }

    private boolean checkContentType(String fileName){
        return fileName != null && (
                fileName.endsWith(".jpg") ||
                        fileName.endsWith(".jpeg"));
    }
}
