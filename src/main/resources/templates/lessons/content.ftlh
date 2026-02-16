<#import "/spring.ftl" as spring>
<#import "../layout.ftlh" as layout>

<@layout.page title="${springMacroRequestContext.getMessage('lesson.content.pageTitle')}">

    <div class="container mt-5 col-10">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h2 class="mb-0">${lesson.title?has_content?then(lesson.title, springMacroRequestContext.getMessage("lesson.content.noTitle"))}</h2>
                <#if isTeacherOrAdmin?? && isTeacherOrAdmin>
                    <button type="button" class="btn btn-light btn-sm" id="toggleEditor">
                        <i class="fas fa-pen"></i> <@spring.message code="lesson.content.edit"/>
                    </button>
                    <button id="saveButton" class="btn btn-success btn-sm d-none">
                        <i class="fas fa-save"></i> <@spring.message code="lesson.content.save"/>
                    </button>
                    <a href="/lessons/${lessonId}" class="btn btn-light btn-sm"
                       style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                        <i class="fas fa-arrow-left me-1" style="color: #0066cc;"></i> Назад к списку
                    </a>
                <#else>
                    <a href="/lessons/${lessonId}" class="btn btn-light btn-sm"
                       style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                        <i class="fas fa-arrow-left me-1" style="color: #0066cc;"></i> Назад к списку
                    </a>
                </#if>
            </div>

            <div class="card-body">
                <#if isTeacherOrAdmin?? && isTeacherOrAdmin>
                    <div class="mb-3">
                        <label for="contentTitle"
                               class="form-label fw-bold"><@spring.message code="lesson.content.titleLabel"/></label>
                        <input type="text" id="contentTitle" class="form-control" maxlength="200" readonly>
                    </div>
                <#else>
                    <div class="mb-3">
                        <label class="form-label fw-bold"><@spring.message code="lesson.content.titleLabel"/></label>
                        <div class="form-control"
                             style="background-color: #f8f9fa;">${contentTitle?has_content?then(contentTitle, springMacroRequestContext.getMessage("lesson.content.noTitle"))}</div>
                    </div>
                </#if>
                <div class="mb-3">
                    <label for="content"
                           class="form-label fw-bold"><@spring.message code="lesson.content.lessonContentLabel"/></label>
                    <div id="content" class="form-control" style="min-height: 300px; padding: 15px;"
                         contenteditable="false"></div>
                </div>
            </div>
        </div>
    </div>

    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

    <div id="i18n-holder"
         data-no-content="<@spring.message code='lesson.content.noContent'/>"
         data-load-error="<@spring.message code='lesson.content.load.error'/>"
         data-load-fail="<@spring.message code='lesson.content.load.fail'/>"
         data-title-empty="<@spring.message code='lesson.content.titleEmpty'/>"
         data-save-success="<@spring.message code='lesson.content.save.success'/>"
         data-save-error="<@spring.message code='lesson.content.save.error'/>"
         data-preview="<@spring.message code='lesson.content.preview'/>"
         data-edit="<@spring.message code='lesson.content.edit'/>"
         data-placeholder="<@spring.message code='lesson.content.editPlaceholder'/>">
    </div>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/froala-editor@4.1.4/css/froala_editor.pkgd.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <script src="https://cdn.jsdelivr.net/npm/froala-editor@4.1.4/js/froala_editor.pkgd.min.js"></script>
    <script>
        const lessonId = ${(lesson.id)!"0"};
        const csrfToken = '${(_csrf.token)!"default-csrf"}';
        const isTeacherOrAdmin = ${isTeacherOrAdmin?string('true', 'false')};

        let editor;
        let isEditorEnabled = false;
        const contentDiv = document.getElementById('content');
        const titleInput = document.getElementById('contentTitle');
        const saveButton = document.getElementById('saveButton');
        const i18n = document.getElementById('i18n-holder').dataset;

        async function loadContent() {
            try {
                const res = await fetch(`/lessons/${lessonId}/content`);
                if (res.ok) {
                    const data = await res.json();
                    contentDiv.innerHTML = data.content || ('<p>' + i18n.noContent + '</p>');
                    if (titleInput) titleInput.value = data.title || '';
                    if (editor) editor.html.set(data.content || '');
                    if (!isTeacherOrAdmin) {
                        const el = document.getElementById('contentTitle') || document.querySelector('.form-control[style*="background-color"]');
                        if (el) {
                            el.innerHTML = data.title || '${springMacroRequestContext.getMessage("lesson.content.noTitle")}';
                        }
                    }
                } else {
                    window.showFlashMessage('danger', i18n.loadError, {duration: 6000});
                }
            } catch (error) {
                window.showFlashMessage('danger', i18n.loadFail, {duration: 6000});
                console.error('Error loading content:', error);
            }
        }

        async function saveContent(isAutoSave = false) {
            if (!isTeacherOrAdmin) return;
            const content = editor ? editor.html.get() : contentDiv.innerHTML;
            const title = titleInput ? titleInput.value.trim() : '';

            if (!title) {
                if (!isAutoSave) {
                    window.showFlashMessage('danger', i18n.titleEmpty, {duration: 6000});
                }
                return;
            }

            try {
                const res = await fetch(`/lessons/${lessonId}/content`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken
                    },
                    body: JSON.stringify({title, content})
                });

                if (res.ok) {
                    if (!isAutoSave) {
                        window.showFlashMessage('success', i18n.saveSuccess, {duration: 4000});
                    }
                } else {
                    const errorData = await res.json();
                    window.showFlashMessage('danger', errorData.message || i18n.saveError, {duration: 6000});
                }
            } catch (error) {
                window.showFlashMessage('danger', i18n.saveError, {duration: 6000});
                console.error('Error saving content:', error);
            }
        }

        document.addEventListener('DOMContentLoaded', async () => {
            await loadContent();

            if (isTeacherOrAdmin) {
                const toggleBtn = document.getElementById('toggleEditor');
                toggleBtn.addEventListener('click', function () {
                    if (isEditorEnabled) {
                        if (editor) editor.destroy();
                        contentDiv.contentEditable = false;
                        contentDiv.classList.add('form-control');
                        if (titleInput) titleInput.readOnly = true;
                        this.innerHTML = '<i class="fas fa-pen"></i> ' + i18n.edit;
                        if (saveButton) saveButton.classList.add('d-none');
                    } else {
                        contentDiv.classList.remove('form-control');
                        editor = new FroalaEditor('#content', {
                            heightMin: 300,
                            toolbarButtons: [
                                'bold', 'italic', 'underline', 'strikeThrough', '|',
                                'fontSize', 'textColor', 'backgroundColor', '|',
                                'align', 'formatOL', 'formatUL', 'outdent', 'indent', '|',
                                'insertLink', 'insertImage', 'insertTable', '|',
                                'undo', 'redo'
                            ],
                            quickInsertTags: ['p', 'div', 'h1', 'h2', 'h3'],
                            placeholderText: i18n.placeholder
                        });
                        contentDiv.contentEditable = true;
                        if (titleInput) titleInput.readOnly = false;
                        this.innerHTML = '<i class="fas fa-eye"></i> ' + i18n.preview;
                        if (saveButton) saveButton.classList.remove('d-none');
                    }
                    isEditorEnabled = !isEditorEnabled;
                });

                if (saveButton) {
                    saveButton.addEventListener('click', () => saveContent(false));
                }
            }
        });
    </script>

    <style>
        .card {
            border-radius: 10px;
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            border-bottom: none;
        }

        .card-header h2 {
            font-size: 1.8rem;
            font-weight: 600;
        }

        .form-control {
            border: 1px solid #ced4da;
            border-radius: 8px;
            font-size: 1rem;
        }

        .fr-box.fr-basic .fr-element {
            min-height: 300px;
            padding: 15px;
        }

        #content {
            min-height: 300px;
            padding: 15px;
            overflow-y: auto;
        }

        .alert {
            min-width: 280px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            border-radius: 12px;
            margin: 0.5rem;
            cursor: pointer;
            transition: transform 0.2s, opacity 0.3s;
            display: flex;
            align-items: center;
            position: relative;
        }

        .alert-success {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }

        .alert-danger {
            background-color: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }
    </style>

</@layout.page>
