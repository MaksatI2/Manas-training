package manasTrainingService.entity;

import java.util.Arrays;
import java.util.List;

public enum FileType {
    IMAGE(Arrays.asList(".jpg", ".jpeg"), Arrays.asList("image/jpeg", "image/jpg")),
    DOCUMENT(
            Arrays.asList(
                    ".pdf", ".docx", ".pptx", ".zip", ".rar", ".mp4",
                    ".jpg", ".jpeg",
                    ".xls", ".xlsx"
            ),
            Arrays.asList(
                    "application/pdf",
                    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                    "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                    "application/zip",
                    "application/x-rar-compressed",
                    "video/mp4",
                    "image/jpeg", "image/jpg",
                    "application/vnd.ms-excel",
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            )
    );
    private final List<String> allowedExtensions;
    private final List<String> allowedMimeTypes;

    FileType(List<String> extensions, List<String> mimeTypes) {
        this.allowedExtensions = extensions;
        this.allowedMimeTypes = mimeTypes;
    }

    public List<String> getAllowedExtensions() {
        return allowedExtensions;
    }

    public List<String> getAllowedMimeTypes() {
        return allowedMimeTypes;
    }
}
