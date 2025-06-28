<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring />

<@layout.page>
    <div class="container">
        <#if successMessage??>
            <div id="successMessage" data-message="${successMessage?js_string}"></div>
        </#if>
        <#if errorMessage??>
            <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
        </#if>

        <h2 class="section-title">Редактировать модуль курса</h2>

        <div class="card feature-card-enhanced">
            <div class="card-body">
                <form action="/admin/course-instances/${courseInstanceId}/modules/${moduleId}/edit" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="mb-3">
                        <label for="title" class="form-label">
                            <i class="fas fa-heading me-1"></i>Название модуля *
                        </label>
                        <@spring.formInput "module.title", "class='form-control' id='title'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "title", "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="durationHours" class="form-label">
                            <i class="fas fa-hourglass-half me-1"></i>Продолжительность (часы) *
                        </label>
                        <@spring.formInput
                        "module.durationHours",
                        "class='form-control only-digits' id='durationHours' type='number' min='1' step='1' inputmode='numeric' pattern='[0-9]*'"
                        />
                        <div class="error-block text-danger">
                            <@spring.showErrors "durationHours", "error-message" />
                        </div>
                    </div>


                    <div class="mb-3">
                        <label for="description" class="form-label">
                            <i class="fas fa-align-left me-1"></i>Описание
                        </label>
                        <@spring.formTextarea "module.description", "class='form-control' id='description' rows='3'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "description", "error-message" />
                        </div>
                    </div>

                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save me-2"></i>Сохранить изменения
                    </button>
                    <a href="/admin/course-instances/${courseInstanceId}/modules" class="btn btn-secondary ms-2">
                        Отмена
                    </a>
                </form>
            </div>
        </div>
    </div>
    <script src="/static/js/only-digits.js"></script>

</@layout.page>
