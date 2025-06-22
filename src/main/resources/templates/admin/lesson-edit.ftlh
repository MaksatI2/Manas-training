<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring />

<@layout.page>
    <div class="container">
        <h2 class="section-title">Редактировать урок</h2>

        <div class="card feature-card-enhanced">
            <div class="card-body">
                <form action="/admin/lessons/${lessonId}/edit" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="mb-3">
                        <label for="title" class="form-label">
                            <i class="fas fa-heading me-1"></i>Название урока *
                        </label>
                        <@spring.formInput "lessonEditDto.title", "class='form-control' id='title'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "title", "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="durationMinutes" class="form-label">
                            <i class="fas fa-clock me-1"></i>Продолжительность (минуты) *
                        </label>
                        <@spring.formInput "lessonEditDto.durationMinutes", "class='form-control' id='durationMinutes' type='number' min='1'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "durationMinutes", "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">
                            <i class="fas fa-align-left me-1"></i>Описание
                        </label>
                        <@spring.formTextarea "lessonEditDto.description", "class='form-control' id='description' rows='3'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "description", "error-message" />
                        </div>
                    </div>

                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save me-2"></i>Сохранить изменения
                    </button>
                    <a href="/lessons/${lessonId}" class="btn btn-secondary ms-2">
                        Отмена
                    </a>
                </form>
            </div>
        </div>
    </div>
</@layout.page>
