package manasTrainingService.service;

import manasTrainingService.dto.ImageDto;
import org.springframework.http.ResponseEntity;

public interface ImageService {
    String saveImage(ImageDto avatarDto);
}
