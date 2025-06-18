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

        <div class="mb-3">
            <label for="lessonDuration" class="form-label">Длительность (мин.) *</label>
            <@spring.formInput "lessonCreateRequest.durationMinutes", "type='number' min='1' class='form-control' id='lessonDuration'" />
            <div class="error-block text-danger">
                <@spring.showErrors  "<br>" "error-message" />
            </div>
        </div>

        <button type="submit" class="btn btn-primary">Создать урок</button>
        <a href="/admin/course-instances/${courseInstance.id}" class="btn btn-secondary ms-2">Отмена</a>
    </form>
</@layout.page>
