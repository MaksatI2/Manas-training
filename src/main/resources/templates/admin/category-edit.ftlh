<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Управление категориями", "url": "/admin/categories"},
    {"label": "Редактировать категорию", "url": ""}
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
                <i class="fas fa-edit me-2"></i>
                Редактировать категорию
            </h5>
            <div>
                <a href="/admin/categories" class="btn btn-light btn-sm" style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-arrow-left me-1" style="color: #0066cc;"></i> Назад к списку
                </a>
            </div>
        </div>

        <div class="card-body">
            <form action="/admin/categories/save" method="post" novalidate>
                <#if _csrf??>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </#if>
                <input type="hidden" name="id" value="${categoryDto.id!''}"/>

                <div class="row">
                    <div class="col-md-8">
                        <div class="mb-3">
                            <label for="name" class="form-label required">Название категории</label>
                            <input type="text"
                                   class="form-control <#if .globals['org.springframework.validation.BindingResult.categoryDto']?? && .globals['org.springframework.validation.BindingResult.categoryDto'].hasFieldErrors('name')>is-invalid</#if>"
                                   id="name"
                                   name="name"
                                   value="${categoryDto.name!''}"
                                   maxlength="100"
                                   placeholder="Введите название категории"
                                   required>
                            <#if .globals['org.springframework.validation.BindingResult.categoryDto']?? && .globals['org.springframework.validation.BindingResult.categoryDto'].hasFieldErrors('name')>
                                <div class="invalid-feedback">
                                    <#list .globals['org.springframework.validation.BindingResult.categoryDto'].getFieldErrors('name') as error>
                                        ${error.defaultMessage}
                                    </#list>
                                </div>
                            </#if>
                            <div class="form-text">Уникальное название категории курсов</div>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Описание</label>
                    <textarea class="form-control <#if .globals['org.springframework.validation.BindingResult.categoryDto']?? && .globals['org.springframework.validation.BindingResult.categoryDto'].hasFieldErrors('description')>is-invalid</#if>"
                              id="description"
                              name="description"
                              rows="3"
                              maxlength="500"
                              placeholder="Краткое описание категории (необязательно)">${categoryDto.description!''}</textarea>
                    <#if .globals['org.springframework.validation.BindingResult.categoryDto']?? && .globals['org.springframework.validation.BindingResult.categoryDto'].hasFieldErrors('description')>
                        <div class="invalid-feedback">
                            <#list .globals['org.springframework.validation.BindingResult.categoryDto'].getFieldErrors('description') as error>
                                ${error.defaultMessage}
                            </#list>
                        </div>
                    </#if>
                    <div class="form-text">Максимум 500 символов</div>
                </div>
                <div class="d-flex justify-content-end gap-2">
                    <a href="/admin/categories" class="btn btn-secondary">
                        <i class="fas fa-times me-1"></i> Отмена
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Сохранить изменения
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

        .info-box {
            background-color: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #0066cc;
        }
    </style>
</@layout.page>