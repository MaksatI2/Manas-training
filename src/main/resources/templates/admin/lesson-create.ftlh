<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring />

<@layout.page>
    <h1>Создать урок в модуле "${module.title}"</h1>

    <form action="/admin/course-instances/${courseInstance.id}/modules/${module.id}/lessons" method="post">
        <input type="hidden" name="_csrf" value="${_csrf.token}" />

        <div class="mb-3">
            <label for="lessonTitle" class="form-label">Название *</label>
            <@spring.formInput "lessonCreateRequest.title", "class='form-control' id='lessonTitle'" />
            <div class="error-block text-danger">
                <@spring.showErrors  "<br>" "error-message" />
            </div>
        </div>

        <div class="mb-3">
            <label for="lessonDescription" class="form-label">Описание</label>
            <@spring.formTextarea "lessonCreateRequest.description", "class='form-control' id='lessonDescription' rows='3'" />
            <div class="error-block text-danger">
                <@spring.showErrors  "<br>" "error-message" />
            </div>        </div>


        <button type="submit" class="btn btn-primary">Создать урок</button>
        <a href="/admin/course-instances/${courseInstance.id}" class="btn btn-secondary ms-2">Отмена</a>
    </form>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const input = document.getElementById('durationMinutes');

            input.addEventListener('input', function () {
                this.value = this.value.replace(/\D/g, '');
            });

            input.addEventListener('keypress', function (e) {
                if (!/\d/.test(e.key)) {
                    e.preventDefault();
                }
            });

            input.addEventListener('paste', function (e) {
                const pasted = (e.clipboardData || window.clipboardData).getData('text');
                if (/\D/.test(pasted)) {
                    e.preventDefault();
                }
            });
        });
    </script>

</@layout.page>
