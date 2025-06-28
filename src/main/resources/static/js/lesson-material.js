document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('uploadForm');
    const titleInput = document.getElementById('title');
    const fileInput = document.getElementById('materialFile');
    const fileLabel = document.getElementById('fileLabel');
    const filePreview = document.getElementById('filePreview');
    const fileInfo = document.getElementById('fileInfo');
    const submitBtn = document.getElementById('submitBtn');

    if (!form || !titleInput || !fileInput || !fileLabel || !filePreview || !fileInfo || !submitBtn) {
        console.error('One or more elements not found:', {
            form: form,
            titleInput: titleInput,
            fileInput: fileInput,
            fileLabel: fileLabel,
            filePreview: filePreview,
            fileInfo: fileInfo,
            submitBtn: submitBtn
        });
        return;
    }

    const allowedExtensions = ['.pdf', '.docx', '.pptx', '.zip', '.rar', '.mp4', '.jpg', '.jpeg', '.xls', '.xlsx'];
    const maxFileSize = 50 * 1024 * 1024;

    let isFileValid = false;

    fileInput.addEventListener('change', function(e) {
        handleFileSelect(e.target.files[0]);
    });

    fileLabel.addEventListener('dragover', function(e) {
        e.preventDefault();
        fileLabel.classList.add('drag-over');
    });

    fileLabel.addEventListener('dragleave', function(e) {
        e.preventDefault();
        fileLabel.classList.remove('drag-over');
    });

    fileLabel.addEventListener('drop', function(e) {
        e.preventDefault();
        fileLabel.classList.remove('drag-over');
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            fileInput.files = files;
            handleFileSelect(files[0]);
        }
    });

    function handleFileSelect(file) {
        if (!file) {
            isFileValid = false;
            updateSubmitButton();
            return;
        }

        if (!validateFile(file)) {
            isFileValid = false;
            updateSubmitButton();
            return;
        }

        isFileValid = true;
        showFileInfo(file);
        showFilePreview(file);

        fileLabel.innerHTML = `
                    <div>
                        <div class="file-input-icon">
                            <i class="fas fa-check-circle" style="color: #28a745;"></i>
                        </div>
                        <div>
                            <strong>Файл выбран</strong><br>
                            Нажмите для выбора другого файла
                        </div>
                    </div>
                `;
        updateSubmitButton();
    }

    function validateFile(file) {
        const ext = '.' + file.name.split('.').pop().toLowerCase();
        if (!allowedExtensions.includes(ext)) {
            showError(`Недопустимый тип файла (${ext}). Поддерживаются: ${allowedExtensions.join(', ')}`);
            fileInput.value = '';
            return false;
        }

        if (file.size > maxFileSize) {
            showError('Размер файла превышает 50 МБ');
            fileInput.value = '';
            return false;
        }

        return true;
    }

    function showFileInfo(file) {
        const sizeInMB = (file.size / (1024 * 1024)).toFixed(2);
        fileInfo.innerHTML = `
                    <div>
                        <strong>Выбранный файл:</strong><br>
                        <i class="fas fa-file" style="margin-right: 0.5rem; color: #007bff;"></i>
                        ${file.name}<br>
                        <i class="fas fa-weight" style="margin-right: 0.5rem; color: #6c757d;"></i>
                        Размер: ${sizeInMB} МБ
                    </div>
                `;
        fileInfo.style.display = 'block';
    }

    function showFilePreview(file) {
        filePreview.style.display = 'none';
        if (['image/jpeg', 'image/jpg'].includes(file.type)) {
            const reader = new FileReader();
            reader.onload = function(e) {
                filePreview.innerHTML = `
                            <img src="${e.target.result}" alt="Превью файла" 
                                 style="max-width: 200px; max-height: 200px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
                        `;
                filePreview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        }
    }

    function showError(message) {
        filePreview.style.display = 'none';
        fileInfo.style.display = 'none';
        submitBtn.disabled = true;
        fileInput.value = '';

        const errorDiv = document.createElement('div');
        errorDiv.className = 'alert alert-danger';
        errorDiv.innerHTML = `
                    <i class="fas fa-exclamation-triangle" style="margin-right: 0.5rem;"></i>
                    ${message}
                `;

        const existingErrors = document.querySelectorAll('.alert-danger');
        existingErrors.forEach(error => error.remove());

        form.insertBefore(errorDiv, form.firstChild);

        fileLabel.innerHTML = `
                    <div>
                        <div class="file-input-icon">
                            <i class="fas fa-cloud-upload-alt"></i>
                        </div>
                        <div>
                            <strong>Нажмите для выбора файла</strong><br>
                            или перетащите файл сюда
                        </div>
                    </div>
                `;
    }

    function updateSubmitButton() {
        const isTitleValid = titleInput.value.trim() !== '';
        submitBtn.disabled = !(isTitleValid && isFileValid);
        console.log('Title Valid:', isTitleValid, 'File Valid:', isFileValid, 'Button Disabled:', submitBtn.disabled);
    }

    titleInput.addEventListener('input', updateSubmitButton);

    form.addEventListener('submit', function(e) {
        if (!fileInput.files[0]) {
            e.preventDefault();
            showError('Пожалуйста, выберите файл для загрузки');
            return;
        }
        if (!titleInput.value.trim()) {
            e.preventDefault();
            showError('Пожалуйста, введите название материала');
            return;
        }

        submitBtn.disabled = true;
        submitBtn.innerHTML = `
                    <i class="fas fa-spinner fa-spin" style="margin-right: 0.5rem;"></i>
                    Сохранение...
                `;
    });

    updateSubmitButton();
});