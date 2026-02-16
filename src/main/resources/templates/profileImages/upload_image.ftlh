<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<@page>
    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>
    <style>
        .upload-container {
            max-width: 600px;
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
    </style>

    <div class="upload-container">
        <div class="upload-card">
            <h1 class="upload-title">
                <i class="fas fa-camera" style="margin-right: 0.5rem; color: #007bff;"></i>
                <@spring.message code='profile.image.upload.title'/>
            </h1>


            <div class="requirements">
                <h6><i class="fas fa-info-circle"
                       style="margin-right: 0.5rem;"></i><@spring.message code='profile.image.upload.requirementsTitle'/>
                </h6>
                <ul>
                    <li><@spring.message code='profile.image.upload.requirements.format'/></li>
                    <li><@spring.message code='profile.image.upload.requirements.maxSize'/></li>
                    <li><@spring.message code='profile.image.upload.requirements.recommended'/></li>
                </ul>
            </div>

            <form method="post" action="/image/upload" enctype="multipart/form-data" id="uploadForm">
                <div class="file-input-wrapper">
                    <input type="file" id="image" name="image" class="file-input" accept="image/jpeg,image/jpg"
                           required>
                    <label for="image" class="file-input-label" id="fileLabel">
                        <div>
                            <div class="file-input-icon">
                                <i class="fas fa-cloud-upload-alt"></i>
                            </div>
                            <div>
                                <strong><@spring.message code='profile.image.upload.selectPrompt'/></strong><br>
                                <@spring.message code='profile.image.upload.dragPrompt'/>
                            </div>
                        </div>
                    </label>
                </div>

                <div class="file-preview" id="filePreview"></div>
                <div class="file-info" id="fileInfo"></div>

                <#if _csrf??>
                    <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                           value="${(_csrf.token)!'csrf-token'}"/>
                </#if>
                <input type="hidden" name="userId" value="${userId}">

                <button type="submit" class="submit-btn" id="submitBtn" disabled>
                    <i class="fas fa-upload" style="margin-right: 0.5rem;"></i>
                    <@spring.message code='profile.image.upload.uploadButton'/>
                </button>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const fileInput = document.getElementById('image');
            const fileLabel = document.getElementById('fileLabel');
            const filePreview = document.getElementById('filePreview');
            const fileInfo = document.getElementById('fileInfo');
            const submitBtn = document.getElementById('submitBtn');
            const form = document.getElementById('uploadForm');

            fileInput.addEventListener('change', function (e) {
                handleFileSelect(e.target.files[0]);
            });

            fileLabel.addEventListener('dragover', function (e) {
                e.preventDefault();
                fileLabel.classList.add('drag-over');
            });

            fileLabel.addEventListener('dragleave', function (e) {
                e.preventDefault();
                fileLabel.classList.remove('drag-over');
            });

            fileLabel.addEventListener('drop', function (e) {
                e.preventDefault();
                fileLabel.classList.remove('drag-over');
                const files = e.dataTransfer.files;
                if (files.length > 0) {
                    fileInput.files = files;
                    handleFileSelect(files[0]);
                }
            });

            function handleFileSelect(file) {
                if (!file) return;
                if (!validateFile(file)) return;

                showFileInfo(file);
                showFilePreview(file);

                submitBtn.disabled = false;
                fileLabel.innerHTML = `
            <div>
                <div class="file-input-icon">
                    <i class="fas fa-check-circle" style="color: #28a745;"></i>
                </div>
                <div>
                    <strong><@spring.message code='profile.image.upload.fileSelected'/></strong><br>
                    <@spring.message code='profile.image.upload.selectAnother'/>
                </div>
            </div>
        `;
            }

            function validateFile(file) {
                const maxSize = 5 * 1024 * 1024;
                const allowedTypes = ['image/jpeg', 'image/jpg'];

                if (!allowedTypes.includes(file.type)) {
                    showError("<@spring.message code='profile.image.upload.error.invalidType'/>");
                    return false;
                }

                if (file.size > maxSize) {
                    showError("<@spring.message code='profile.image.upload.error.maxSize'/>");
                    return false;
                }

                return true;
            }

            function showFileInfo(file) {
                const sizeInMB = (file.size / (1024 * 1024)).toFixed(2);
                fileInfo.innerHTML = `
            <div>
                <strong><@spring.message code='profile.image.upload.selectedFile'/></strong><br>
                <i class="fas fa-file-image" style="margin-right: 0.5rem; color: #007bff;"></i>
                ` + file.name + `<br>
                <i class="fas fa-weight" style="margin-right: 0.5rem; color: #6c757d;"></i>
                <@spring.message code='profile.image.upload.size'/>: ` + sizeInMB + ` МБ
            </div>
        `;
                fileInfo.style.display = 'block';
            }

            function showFilePreview(file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    filePreview.innerHTML = '<img src="' + e.target.result + '" alt="<@spring.message code="profile.image.upload.previewAlt"/>" style="max-width: 200px; max-height: 200px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">';
                    filePreview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            }

            function showError(message) {
                filePreview.style.display = 'none';
                fileInfo.style.display = 'none';
                submitBtn.disabled = true;
                fileInput.value = '';

                const errorDiv = document.createElement('div');
                errorDiv.className = 'alert alert-danger';
                errorDiv.innerHTML = '<i class="fas fa-exclamation-triangle" style="margin-right: 0.5rem;"></i>' + message;

                const existingErrors = document.querySelectorAll('.alert-danger');
                existingErrors.forEach(error => error.remove());

                form.insertBefore(errorDiv, form.firstChild);

                fileLabel.innerHTML = `
            <div>
                <div class="file-input-icon">
                    <i class="fas fa-cloud-upload-alt"></i>
                </div>
                <div>
                    <strong><@spring.message code='profile.image.upload.selectPrompt'/></strong><br>
                    <@spring.message code='profile.image.upload.dragPrompt'/>
                </div>
            </div>
        `;
            }

            if (!fileInput.files[0]) {
                e.preventDefault();
                showError("<@spring.message code='profile.image.upload.error.noFile'/>");
                return;
            }

            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin" style="margin-right: 0.5rem;"></i><@spring.message code="profile.image.upload.uploading"/>';
        });
    </script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</@page>
