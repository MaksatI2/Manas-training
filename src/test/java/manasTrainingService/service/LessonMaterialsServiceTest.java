package manasTrainingService.service;

import manasTrainingService.dto.lesson.LessonMaterialDTO;
import manasTrainingService.entity.Lesson;
import manasTrainingService.entity.LessonMaterial;
import manasTrainingService.repositories.LessonMaterialRepository;
import manasTrainingService.service.impl.LessonMaterialsServiceImpl;
import manasTrainingService.service.user.UserService;
import manasTrainingService.util.FileUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mockito;
import org.springframework.context.MessageSource;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class LessonMaterialsServiceTest {

    private LessonMaterialRepository materialRepository;
    private LessonService lessonService;
    private FileUtil fileUtil;
    private ActivityLogService activityLogService;
    private UserService userService;
    private MessageSource messageSource;

    private LessonMaterialsServiceImpl lessonMaterialsService;

    @BeforeEach
    void setUp() {
        materialRepository = Mockito.mock(LessonMaterialRepository.class);
        lessonService = Mockito.mock(LessonService.class);
        fileUtil = Mockito.mock(FileUtil.class);
        activityLogService = Mockito.mock(ActivityLogService.class);
        userService = Mockito.mock(UserService.class);
        messageSource = Mockito.mock(MessageSource.class);


        lessonMaterialsService = new LessonMaterialsServiceImpl(
                materialRepository,
                lessonService,
                fileUtil,
                activityLogService,
                userService,
                messageSource
        );
    }

    @Test
    void getMaterialsByLessonId_shouldReturnListOfDTOs() {
        Integer lessonId = 1;
        List<LessonMaterial> materials = Arrays.asList(
                LessonMaterial.builder().id(10).title("Title1").url("url1").build(),
                LessonMaterial.builder().id(20).title("Title2").url("url2").build()
        );

        when(materialRepository.findByLessonId(lessonId)).thenReturn(materials);

        List<LessonMaterialDTO> result = lessonMaterialsService.getMaterialsByLessonId(lessonId);

        assertEquals(2, result.size());
        assertEquals("Title1", result.get(0).getTitle());
        assertEquals("url2", result.get(1).getUrl());
        verify(materialRepository).findByLessonId(lessonId);
    }

    @Test
    void addMaterial_shouldSaveMaterial() {
        when(fileUtil.saveUploadFile(any(MultipartFile.class), anyString(), any()))
                .thenReturn("new-url");
        MultipartFile file = new MockMultipartFile(
                "file",
                "example.txt",
                "text/plain",
                "Содержимое файла".getBytes()
        );
        LessonMaterialDTO dto = LessonMaterialDTO.builder()
                .lessonId(1)
                .title("New Title")
                .url("new-url")
                .file(file)
                .build();


        Lesson lesson = Lesson.builder().id(1).build();
        LessonMaterial materialToReturn = LessonMaterial.builder()
                .id(123)
                .title("New Title")
                .url("new-url")
                .lesson(lesson)
                .build();
        when(lessonService.getLessonModelById(dto.getLessonId())).thenReturn(lesson);
        when(materialRepository.save(any(LessonMaterial.class))).thenReturn(materialToReturn);

        lessonMaterialsService.addMaterial(dto);

        ArgumentCaptor<LessonMaterial> captor = ArgumentCaptor.forClass(LessonMaterial.class);
        verify(materialRepository).save(captor.capture());

        LessonMaterial saved = captor.getValue();
        assertEquals("New Title", saved.getTitle());
        assertEquals("new-url", saved.getUrl());
        assertEquals(lesson, saved.getLesson());
    }

    @Test
    void deleteMaterial_shouldDeleteWhenFound() {
        Integer materialId = 5;
        LessonMaterial material = LessonMaterial.builder().id(materialId).build();
        when(materialRepository.findById(materialId)).thenReturn(Optional.of(material));

        lessonMaterialsService.deleteMaterial(materialId);

        verify(materialRepository).delete(material);
    }

    @Test
    void deleteMaterial_shouldThrowExceptionWhenNotFound() {
        Integer materialId = 99;
        when(materialRepository.findById(materialId)).thenReturn(Optional.empty());

        // Замокаем messageSource, чтобы возвращал нужное сообщение
        when(messageSource.getMessage(eq("material.not.found"), any(), any()))
                .thenReturn("Material not found");

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            lessonMaterialsService.deleteMaterial(materialId);
        });

        assertEquals("Material not found", ex.getMessage());
        verify(materialRepository, never()).delete(any());
    }
}
