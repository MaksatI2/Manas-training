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
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Service
@RequiredArgsConstructor
public class ImageServiceImpl implements ImageService {

    private final FileUtil fileUtil;
    private final UserService userService;
    private final UserRepository userRepository;
    private final MessageSource messageSource;

    @Override
    public String saveImage(ImageDto imageDto) {
        log.info("Начинаем сохранение изображения для пользователя с ID: {}", imageDto.getUserId());

        validateImage(imageDto.getImage());

        try {
            String oldImage = userRepository.findById(imageDto.getUserId())
                    .orElseThrow(() -> new UserNotFoundException(
                            messageSource.getMessage(
                                    "user.not.found",
                                    null,
                                    "Пользователь не найден",
                                    LocaleContextHolder.getLocale()
                            )
                    ))
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
            throw new ImageValidationException(messageSource.getMessage(
                    "image.null",
                    null,
                    "Изображение не может быть null",
                    LocaleContextHolder.getLocale()
            ));
        }

        if (image.isEmpty()) {
            throw new ImageValidationException(messageSource.getMessage(
                    "image.empty",
                    null,
                    "Пожалуйста, выберите изображение для загрузки",
                    LocaleContextHolder.getLocale()
            ));
        }

        if (image.getSize() == 0) {
            throw new ImageValidationException(messageSource.getMessage(
                    "image.file.empty",
                    null,
                    "Файл изображения пустой",
                    LocaleContextHolder.getLocale()
            ));
        }

        long maxSize = 5 * 1024 * 1024;
        if (image.getSize() > maxSize) {
            throw new ImageValidationException(messageSource.getMessage(
                    "image.too.large",
                    new Object[]{maxSize / (1024 * 1024)},
                    "Размер изображения не должен превышать {0} МБ",
                    LocaleContextHolder.getLocale()
            ));
        }

        String contentType = image.getContentType();
        if (contentType == null || (!contentType.equals("image/jpeg") && !contentType.equals("image/jpg"))) {
            throw new ImageValidationException(messageSource.getMessage(
                    "image.invalid.format",
                    null,
                    "Поддерживаются только изображения в формате JPEG/JPG",
                    LocaleContextHolder.getLocale()
            ));
        }


        log.info("Валидация изображения прошла успешно. Размер: {} байт, тип: {}",
                image.getSize(), contentType);
    }
}