package manasTrainingService.service.impl.user;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.dto.ImageDto;
import manasTrainingService.exceptions.nsee.user.UserNotFoundException;
import manasTrainingService.exceptions.nsee.ImageValidationException;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.user.ImageService;
import manasTrainingService.service.user.UserService;
import manasTrainingService.util.FileUtil;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Service
@RequiredArgsConstructor
public class ImageServiceImpl implements ImageService {

    private final FileUtil fileUtil;
    private final UserService userService;
    private final UserRepository userRepository;

    @Override
    public String saveImage(ImageDto imageDto) {
        log.info("Начинаем сохранение изображения для пользователя с ID: {}", imageDto.getUserId());

        validateImage(imageDto.getImage());

        try {
            String oldImage = userRepository.findById(imageDto.getUserId())
                    .orElseThrow(() -> new UserNotFoundException("Пользователь не найден"))
                    .getAvatarUrl();

            if (oldImage != null && !oldImage.isEmpty()) {
                fileUtil.removeOldImage(oldImage, "images/");
                log.info("Старое изображение удалено: {}", oldImage);
            }

            String filename = fileUtil.saveUploadFile(imageDto.getImage(), "images/");
            userService.addAvatarUrl(imageDto.getUserId(), filename);

            log.info("Изображение успешно сохранено: {}", filename);
            return filename;

        } catch (Exception e) {
            log.error("Ошибка при сохранении изображения для пользователя {}: {}",
                    imageDto.getUserId(), e.getMessage(), e);
            throw e;
        }
    }

    private void validateImage(MultipartFile image) {
        if (image == null) {
            throw new ImageValidationException("Изображение не может быть null");
        }

        if (image.isEmpty()) {
            throw new ImageValidationException("Пожалуйста, выберите изображение для загрузки");
        }

        if (image.getSize() == 0) {
            throw new ImageValidationException("Файл изображения пустой");
        }

        long maxSize = 5 * 1024 * 1024;
        if (image.getSize() > maxSize) {
            throw new ImageValidationException("Размер изображения не должен превышать 5 МБ");
        }

        String contentType = image.getContentType();
        if (contentType == null || (!contentType.equals("image/jpeg") && !contentType.equals("image/jpg"))) {
            throw new ImageValidationException("Поддерживаются только изображения в формате JPEG/JPG");
        }

        log.info("Валидация изображения прошла успешно. Размер: {} байт, тип: {}",
                image.getSize(), contentType);
    }
}