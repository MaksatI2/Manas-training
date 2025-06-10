package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.dto.ImageDto;
import manasTrainingService.exceptions.nsee.UserNotFoundException;
import manasTrainingService.repositories.UserRepository;
import manasTrainingService.service.ImageService;
import manasTrainingService.service.UserService;
import manasTrainingService.util.FileUtil;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ImageServiceImpl implements ImageService {

    private final FileUtil fileUtil;
    private final UserService userService;
    private final UserRepository userRepository;

    @Override
    public String saveImage(ImageDto imageDto) {
        String oldImage = userRepository.findById(imageDto.getUserId()).orElseThrow(() -> new UserNotFoundException("Пользователь не найден")).getAvatarUrl();
        fileUtil.removeOldImage(oldImage, "images/");
        String filename = fileUtil.saveUploadFile(imageDto.getImage(), "images/");
        userService.addAvatarUrl(imageDto.getUserId(), filename);
        return filename;
    }
}
