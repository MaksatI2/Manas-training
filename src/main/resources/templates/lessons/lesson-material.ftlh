<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<@layout.page>
    <div class="hero-section">
        <h1 class="hero-title">Добавить материал к уроку: ${lesson.title}</h1>
    </div>

    <#if errorMessage??>
        <div class="alert alert-danger">${errorMessage}</div>
    </#if>

    <div class="container">
        <form action="<@spring.url '/admin/lessons/${lesson.id}/materials'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <@spring.formHiddenInput "material.lessonId" 'value="${lesson.id}"'/>
            <div class="mb-3">
                <label for="materialTitle" class="form-label">Название *</label>
                <@spring.formInput "material.title" 'class="form-control" id="materialTitle" required maxlength="200"' />
                <div class="error-block"><@spring.showErrors "<br>" "text-danger small" /></div>
            </div>
            <div class="mb-3">
                <label for="materialUrl" class="form-label">URL *</label>
                <@spring.formInput "material.url" 'class="form-control" id="materialUrl" required maxlength="500"' />
                <div class="error-block"><@spring.showErrors "<br>" "text-danger small" /></div>
            </div>
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary">Сохранить</button>
                <a href="<@spring.url '/lessons/${lesson.id}'/>" class="btn btn-secondary">Отмена</a>
            </div>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.querySelector('form');
            const titleInput = document.querySelector('#materialTitle');
            const urlInput = document.querySelector('#materialUrl');
            const submitButton = form.querySelector('button[type="submit"]');

            function updateSubmitButton() {
                const isValid = titleInput.value.trim() && urlInput.value.trim();
                submitButton.disabled = !isValid;
                submitButton.classList.toggle('btn-primary', isValid);
                submitButton.classList.toggle('btn-secondary', !isValid);
            }

            [titleInput, urlInput].forEach(input => {
                input.addEventListener('input', updateSubmitButton);
            });

            updateSubmitButton();
        });
    </script>

    <style>
        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }
        .form-label {
            font-weight: 500;
        }
        .error-block {
            font-size: 0.875rem;
        }
    </style>
</@layout.page>