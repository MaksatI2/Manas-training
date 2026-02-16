document.addEventListener('DOMContentLoaded', function () {
    const t = (k, params = {}) => {
        const s = (window.APP_MESSAGES && window.APP_MESSAGES[k]) || k;
        return s.replace(/{(\w+)}/g, (_, p) => (params[p] != null ? params[p] : ''));
    };

    const form = document.getElementById('uploadForm');
    const titleInput = document.getElementById('title');
    const fileInput = document.getElementById('materialFile');
    const fileLabel = document.getElementById('fileLabel');
    const filePreview = document.getElementById('filePreview');
    const fileInfo = document.getElementById('fileInfo');
    const submitBtn = document.getElementById('submitBtn');

    if (!form || !titleInput || !fileInput || !fileLabel || !filePreview || !fileInfo || !submitBtn) {
        console.error('One or more elements not found:', {
            form,
            titleInput,
            fileInput,
            fileLabel,
            filePreview,
            fileInfo,
            submitBtn
        });
        return;
    }

    const allowedExtensions = ['.pdf', '.docx', '.pptx', '.zip', '.rar', '.mp4', '.jpg', '.jpeg', '.xls', '.xlsx'];
    const maxFileSize = 50 * 1024 * 1024;

    let isFileValid = false;

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
                    <strong>${t('js.lesson-materials.label.fileSelected')}</strong><br>
                    ${t('js.lesson-materials.label.clickToChooseAnother')}
                </div>
            </div>
        `;
        updateSubmitButton();
    }

    function validateFile(file) {
        const ext = '.' + file.name.split('.').pop().toLowerCase();
        if (!allowedExtensions.includes(ext)) {
            showError(t('js.lesson-materials.error.invalidType', {ext, list: allowedExtensions.join(', ')}));
            fileInput.value = '';
            return false;
        }
        if (file.size > maxFileSize) {
            showError(t('js.lesson-materials.error.tooLarge', {max: 50}));
            fileInput.value = '';
            return false;
        }
        return true;
    }

    function showFileInfo(file) {
        const sizeInMB = (file.size / (1024 * 1024)).toFixed(2);
        fileInfo.innerHTML = `
            <div>
                <strong>${t('js.lesson-materials.info.selectedFile')}</strong><br>
                <i class="fas fa-file" style="margin-right: 0.5rem; color: #007bff;"></i>
                ${file.name}<br>
                <i class="fas fa-weight" style="margin-right: 0.5rem; color: #6c757d;"></i>
                ${t('js.lesson-materials.info.size', {size: sizeInMB})}
            </div>
        `;
        fileInfo.style.display = 'block';
    }

    function showFilePreview(file) {
        filePreview.style.display = 'none';
        if (['image/jpeg', 'image/jpg'].includes(file.type)) {
            const reader = new FileReader();
            reader.onload = function (e) {
                filePreview.innerHTML = `
                    <img src="${e.target.result}" alt="${t('js.lesson-materials.preview.alt')}"
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
                    <strong>${t('js.lesson-materials.label.clickToChoose')}</strong><br>
                    ${t('js.lesson-materials.label.orDragHere')}
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

    form.addEventListener('submit', function (e) {
        if (!fileInput.files[0]) {
            e.preventDefault();
            showError(t('js.lesson-materials.error.pickFile'));
            return;
        }
        if (!titleInput.value.trim()) {
            e.preventDefault();
            showError(t('js.lesson-materials.error.enterTitle'));
            return;
        }
        submitBtn.disabled = true;
        submitBtn.innerHTML = `
            <i class="fas fa-spinner fa-spin" style="margin-right: 0.5rem;"></i>
            ${t('js.lesson-materials.saving')}
        `;
    });

    updateSubmitButton();
});
