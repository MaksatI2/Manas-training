<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Курсы", "url": "/admin/courses"},
    {"label": "Добавить курс", "url": ""}
    ] />
    <div class="card shadow mb-4">
        <#if successMessage??>
            <div id="successMessage" data-message="${successMessage?js_string}"></div>
        </#if>
        <#if errorMessage??>
            <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
        </#if>
        <div class="card-header py-3 d-flex justify-content-between align-items-center" style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-plus-circle me-2"></i>
                Добавить курс
            </h5>
            <div>
                <a href="/admin/courses" class="btn btn-light btn-sm" style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-arrow-left me-1" style="color: #0066cc;"></i> Назад к списку
                </a>
            </div>
        </div>

        <div class="card-body">
            <form action="/admin/courses/add" method="post" novalidate>
                <#if _csrf??>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </#if>
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="title" class="form-label required">Название курса</label>
                            <input type="text"
                                   class="form-control <#if .globals['org.springframework.validation.BindingResult.course']?? && .globals['org.springframework.validation.BindingResult.course'].hasFieldErrors('title')>is-invalid</#if>"
                                   id="title"
                                   name="title"
                                   value="${course.title!''}"
                                   maxlength="200"
                                   required>
                            <#if .globals['org.springframework.validation.BindingResult.course']?? && .globals['org.springframework.validation.BindingResult.course'].hasFieldErrors('title')>
                                <div class="invalid-feedback">
                                    <#list .globals['org.springframework.validation.BindingResult.course'].getFieldErrors('title') as error>
                                        ${error.defaultMessage}
                                    </#list>
                                </div>
                            </#if>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="code" class="form-label required">Код курса</label>
                            <input type="text"
                                   class="form-control <#if .globals['org.springframework.validation.BindingResult.course']?? && .globals['org.springframework.validation.BindingResult.course'].hasFieldErrors('code')>is-invalid</#if>"
                                   id="code"
                                   name="code"
                                   value="${course.code!''}"
                                   maxlength="20"
                                   required>
                            <#if .globals['org.springframework.validation.BindingResult.course']?? && .globals['org.springframework.validation.BindingResult.course'].hasFieldErrors('code')>
                                <div class="invalid-feedback">
                                    <#list .globals['org.springframework.validation.BindingResult.course'].getFieldErrors('code') as error>
                                        ${error.defaultMessage}
                                    </#list>
                                </div>
                            </#if>
                            <div class="form-text">Уникальный идентификатор курса</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="categoryId" class="form-label required">Категория</label>
                            <select class="form-select <#if .globals['org.springframework.validation.BindingResult.course']?? && .globals['org.springframework.validation.BindingResult.course'].hasFieldErrors('categoryId')>is-invalid</#if>"
                                    id="categoryId"
                                    name="categoryId"
                                    required>
                                <option value="">Выберите категорию</option>
                                <#list categories as category>
                                    <option value="${category.id}" <#if course.categoryId?? && course.categoryId == category.id>selected</#if>>
                                        ${category.name}
                                    </option>
                                </#list>
                            </select>
                            <#if .globals['org.springframework.validation.BindingResult.course']?? && .globals['org.springframework.validation.BindingResult.course'].hasFieldErrors('categoryId')>
                                <div class="invalid-feedback">
                                    <#list .globals['org.springframework.validation.BindingResult.course'].getFieldErrors('categoryId') as error>
                                        ${error.defaultMessage}
                                    </#list>
                                </div>
                            </#if>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="duration" class="form-label required">Продолжительность (часы)</label>
                            <input type="number"
                                   class="form-control <#if .globals['org.springframework.validation.BindingResult.course']?? && .globals['org.springframework.validation.BindingResult.course'].hasFieldErrors('duration')>is-invalid</#if>"
                                   id="duration"
                                   name="duration"
                                   value="${course.duration!''}"
                                   min="1"
                                   max="10000"
                                   required>
                            <#if .globals['org.springframework.validation.BindingResult.course']?? && .globals['org.springframework.validation.BindingResult.course'].hasFieldErrors('duration')>
                                <#assign durationErrors = .globals['org.springframework.validation.BindingResult.course'].getFieldErrors('duration') />
                                <#assign visibleErrors = durationErrors?filter(error -> error.code != "typeMismatch") />
                                <#if (visibleErrors?size > 0)>
                                    <div class="invalid-feedback">
                                        <#list visibleErrors as error>
                                            ${error.defaultMessage}
                                        </#list>
                                    </div>
                                </#if>
                            </#if>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Описание</label>
                    <textarea class="form-control <#if .globals['org.springframework.validation.BindingResult.course']?? && .globals['org.springframework.validation.BindingResult.course'].hasFieldErrors('description')>is-invalid</#if>"
                              id="description"
                              name="description"
                              rows="4"
                              maxlength="1000">${course.description!''}</textarea>
                    <#if .globals['org.springframework.validation.BindingResult.course']?? && .globals['org.springframework.validation.BindingResult.course'].hasFieldErrors('description')>
                        <div class="invalid-feedback">
                            <#list .globals['org.springframework.validation.BindingResult.course'].getFieldErrors('description') as error>
                                ${error.defaultMessage}
                            </#list>
                        </div>
                    </#if>
                    <div class="form-text">Максимум 1000 символов</div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input type="hidden" name="individual" value="false">
                                <input class="form-check-input"
                                       type="checkbox"
                                       id="individual"
                                       name="individual"
                                       value="true"
                                       <#if course.individual?? && course.individual>checked</#if>>
                                <label class="form-check-label" for="individual">
                                    <i class="fas fa-user me-1" style="color: #0066cc;"></i>
                                    Индивидуальный курс
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input type="hidden" name="active" value="false">
                                <input class="form-check-input"
                                       type="checkbox"
                                       id="active"
                                       name="active"
                                       value="true"
                                       <#if !course.active?? || course.active>checked</#if>>
                                <label class="form-check-label" for="active">
                                    <i class="fas fa-check-circle me-1" style="color: #28a745;"></i>
                                    Активный курс
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2">
                    <a href="/admin/courses" class="btn btn-secondary">
                        <i class="fas fa-times me-1"></i> Отмена
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Создать курс
                    </button>
                </div>
            </form>
        </div>
    </div>

    <style>
        .required::after {
            content: " *";
            color: #dc3545;
        }

        .card {
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #ced4da;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0066cc;
            box-shadow: 0 0 0 0.2rem rgba(0, 102, 204, 0.25);
        }

        .btn {
            border-radius: 8px;
            padding: 0.5rem 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
        }

        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        .btn-secondary:hover {
            background-color: #545b62;
            transform: translateY(-1px);
        }

        .form-check-input:checked {
            background-color: #0066cc;
            border-color: #0066cc;
        }

        .alert {
            border-radius: 8px;
            border: none;
        }

        .form-text {
            font-size: 0.875rem;
            color: #6c757d;
        }

        .gap-2 {
            gap: 0.5rem;
        }
    </style>
</@layout.page>