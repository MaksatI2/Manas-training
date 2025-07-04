<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Урок #${lesson.id}", "url": "/lessons/${lesson.id}"},
    {"label": "Добавить материал", "url": ""}
    ] />
    <style>
        .upload-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
        }

        .upload-card {
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 2.5rem;
            border: 1px solid #e9ecef;
        }

        .upload-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 2rem;
            text-align: center;
        }

        .file-input-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
            width: 100%;
            margin-bottom: 1.5rem;
        }

        .file-input {
            position: absolute;
            left: -9999px;
            opacity: 0;
        }

        .file-input-label {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            border: 2px dashed #007bff;
            border-radius: 10px;
            background: #f8f9fa;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            color: #6c757d;
            font-size: 1.1rem;
        }

        .file-input-label:hover {
            border-color: #0056b3;
            background: #e3f2fd;
            color: #0056b3;
        }

        .file-input-label.drag-over {
            border-color: #28a745;
            background: #d4edda;
            color: #155724;
        }

        .file-input-icon {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            color: #007bff;
        }

        .file-preview {
            margin-top: 1rem;
            text-align: center;
            display: none;
        }

        .file-preview img {
            max-width: 200px;
            max-height: 200px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .file-info {
            margin-top: 1rem;
            padding: 1rem;
            background: #e9ecef;
            border-radius: 8px;
            display: none;
        }

        .submit-btn {
            background: linear-gradient(45deg, #007bff, #0056b3);
            border: none;
            border-radius: 10px;
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 1rem;
        }

        .submit-btn:hover {
            background: linear-gradient(45deg, #0056b3, #004494);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
        }

        .submit-btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .alert {
            border-radius: 10px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            border: none;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .requirements {
            background: #e3f2fd;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid #007bff;
        }

        .requirements h6 {
            color: #0056b3;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .requirements ul {
            margin: 0;
            padding-left: 1.5rem;
        }

        .requirements li {
            margin-bottom: 0.5rem;
            color: #495057;
        }

        .form-label {
            font-weight: 500;
            color: #2c3e50;
        }

        .form-control {
            border-radius: 8px;
            border: 1px solid #ced4da;
            padding: 0.75rem;
        }

        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }

        .cancel-btn {
            background: linear-gradient(45deg, #6c757d, #495057);
            border: none;
            border-radius: 10px;
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 1rem;
        }

        .cancel-btn:hover {
            background: linear-gradient(45deg, #495057, #343a40);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3);
        }
    </style>

    <div class="upload-container">
        <div class="upload-card">
            <h1 class="upload-title">
                <i class="fas fa-file-upload" style="margin-right: 0.5rem; color: #007bff;"></i>
                Добавить материал к уроку: ${lesson.title}
            </h1>

            <#if successMessage??>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle" style="margin-right: 0.5rem;"></i>
                    ${successMessage}
                </div>
            </#if>

            <#if errorMessage??>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle" style="margin-right: 0.5rem;"></i>
                    ${errorMessage}
                </div>
            </#if>

            <div class="requirements">
                <h6><i class="fas fa-info-circle" style="margin-right: 0.5rem;"></i>Требования к файлу:</h6>
                <ul>
                    <li>Формат: PDF, DOCX, PPTX, ZIP, RAR, MP4, JPG, JPEG, XLS, XLSX</li>
                    <li>Максимальный размер: 50 МБ</li>
                </ul>
            </div>

            <form method="post" action="/lessons/${lesson.id}/materials" enctype="multipart/form-data" id="uploadForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <@spring.formHiddenInput "material.lessonId" 'value="${lesson.id}"'/>

                <div class="mb-3">
                    <label for="materialTitle" class="form-label">Название *</label>
                    <@spring.formInput "material.title" 'class="form-control" id="materialTitle" maxlength="200" required' />
                    <div class="error-block"><@spring.showErrors "<br>" "text-danger small" /></div>
                </div>

                <div class="file-input-wrapper">
                    <input type="file" id="materialFile" name="file" class="file-input"
                           accept=".pdf,.docx,.pptx,.zip,.rar,.mp4,.jpg,.jpeg,.xls,.xlsx" required>
                    <label for="materialFile" class="file-input-label" id="fileLabel">
                        <div>
                            <div class="file-input-icon">
                                <i class="fas fa-cloud-upload-alt"></i>
                            </div>
                            <div>
                                <strong>Нажмите для выбора файла</strong><br>
                                или перетащите файл сюда
                            </div>
                        </div>
                    </label>
                </div>

                <div class="file-preview" id="filePreview"></div>
                <div class="file-info" id="fileInfo"></div>

                <div class="d-flex gap-2">
                    <button type="submit" class="submit-btn" id="submitBtn" disabled>
                        <i class="fas fa-upload" style="margin-right: 0.5rem;"></i>
                        Сохранить
                    </button>
                    <a href="<@spring.url '/lessons/${lesson.id}'/>" class="cancel-btn">
                        <i class="fas fa-times" style="margin-right: 0.5rem;"></i>
                        Отмена
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script src="/static/js/lesson-material.js">

    </script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</@page>