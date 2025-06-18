<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<@layout.page>
    <div class="hero-section">
        <h1 class="hero-title">${schedule.id?? 'Создать' 'Редактировать'} расписание для урока: ${lesson.title}</h1>
    </div>

    <#if errorMessage??>
        <div class="alert alert-danger">${errorMessage}</div>
    </#if>

    <div class="container">
        <form action="<@spring.url '/admin/lessons/${lesson.id}/schedule'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <@spring.formHiddenInput "schedule.lessonId" 'value="${lesson.id}"'/>
            <@spring.formHiddenInput "schedule.courseInstanceId" 'value="${courseInstance.id}"'/>
            <#if schedule.id??>
                <@spring.formHiddenInput "schedule.id"/>
            </#if>
            <div class="mb-3">
                <label for="lessonDate" class="form-label">Дата урока *</label>
                <@spring.formInput "schedule.lessonDate" 'class="form-control" id="lessonDate" type="date" required' />
                <div class="error-block"><@spring.showErrors "<br>" "text-danger small" /></div>
            </div>
            <div class="mb-3">
                <label for="durationHours" class="form-label">Длительность (ч.) *</label>
                <@spring.formInput "schedule.durationHours" 'class="form-control" id="durationHours" type="number" min="1" required' />
                <div class="error-block"><@spring.showErrors "<br>" "text-danger small" /></div>
            </div>
            <div class="mb-3">
                <label for="teacherId" class="form-label">Преподаватель *</label>
                <@spring.formSingleSelect "schedule.teacherId" teachers 'class="form-control" id="teacherId" required' />
                <div class="error-block"><@spring.showErrors "<br>" "text-danger small" /></div>
            </div>
            <div class="mb-3">
                <label for="title" class="form-label">Название</label>
                <@spring.formInput "schedule.title" 'class="form-control" id="title" maxlength="200"' />
                <div class="error-block"><@spring.showErrors "<br>" "text-danger small" /></div>
            </div>
            <div class="mb-3">
                <label for="lessonType" class="form-label">Тип урока *</label>
                <@spring.formSingleSelect "schedule.lessonType" lessonTypes 'class="form-control" id="lessonType" required' />
                <div class="error-block"><@spring.showErrors "<br>" "text-danger small" /></div>
            </div>
            <div class="mb-3 form-check">
                <@spring.formCheckbox "schedule.isOnline" 'class="form-check-input" id="isOnline"' />
                <label for="isOnline" class="form-check-label">Онлайн</label>
            </div>
            <div class="mb-3">
                <label for="meetingUrl" class="form-label">Ссылка на встречу</label>
                <@spring.formInput "schedule.meetingUrl" 'class="form-control" id="meetingUrl" maxlength="500"' />
                <div class="error-block"><@spring.showErrors "<br>" "text-danger small" /></div>
            </div>
            <div class="mb-3">
                <label for="notes" class="form-label">Примечания</label>
                <@spring.formTextarea "schedule.notes" 'rows="4" class="form-control" id="notes"' />
                <div class="error-block"><@spring.showErrors "<br>" "text-danger small" /></div>
            </div>
            <div class="mb-3 form-check">
                <@spring.formCheckbox "schedule.isActive" 'class="form-check-input" id="isActive"' />
                <label for="isActive" class="form-check-label">Активно</label>
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
            const dateInput = document.querySelector('#lessonDate');
            const durationInput = document.querySelector('#durationHours');
            const teacherInput = document.querySelector('#teacherId');
            const typeInput = document.querySelector('#lessonType');
            const submitButton = form.querySelector('button[type="submit"]');

            function updateSubmitButton() {
                const isValid = dateInput.value && durationInput.value >= 1 && teacherInput.value && typeInput.value;
                submitButton.disabled = !isValid;
                submitButton.classList.toggle('btn-primary', isValid);
                submitButton.classList.toggle('btn-secondary', !isValid);
            }

            [dateInput, durationInput, teacherInput, typeInput].forEach(input => {
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