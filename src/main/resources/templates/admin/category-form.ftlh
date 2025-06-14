<#import "../layout.ftlh" as layout>
<@layout.page>
    <style>
        :root {
            --primary-blue: #0066cc;
            --dark-blue: #003d7a;
            --light-blue: #87ceeb;
            --white: #ffffff;
            --text-dark: #2c3e50;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            border: none;
            padding: 0.8rem 2rem;
            border-radius: 25px;
            transition: all 0.2s ease-in-out;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }

        .btn-outline-secondary {
            border: 2px solid var(--primary-blue);
            color: var(--primary-blue);
            border-radius: 25px;
            padding: 0.8rem 2rem;
            background-color: transparent;
            transition: all 0.2s ease-in-out;
        }

        .btn-outline-secondary:hover {
            background-color: var(--primary-blue);
            color: var(--white);
            transform: translateY(-2px);
        }

        .form-label {
            font-weight: 600;
            color: var(--text-dark);
        }

        .form-control {
            border-radius: 10px;
        }

        .card-form {
            background: var(--white);
            border-left: 4px solid var(--primary-blue);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
            padding: 2rem;
        }

        .invalid-feedback {
            font-size: 0.875rem;
            color: #dc3545;
        }

        h1 {
            font-size: 2.5rem;
            color: var(--primary-blue);
            font-weight: bold;
        }

        @media (max-width: 768px) {
            h1 {
                font-size: 2rem;
                text-align: center;
            }

            .btn-primary-custom,
            .btn-outline-secondary {
                padding: 0.6rem 1.2rem;
                font-size: 0.95rem;
            }
        }
    </style>

    <div class="container py-4">
        <h1 class="mb-4">
            <i class="fas fa-tag me-2 text-primary"></i>
            <#if categoryDto.id??>Редактировать категорию<#else>Создать категорию</#if>
        </h1>

        <form method="post" action="/admin/categories/save" class="card-form">
            <input type="hidden" name="_csrf" value="${_csrf.token}">
            <#if categoryDto.id??>
                <input type="hidden" name="id" value="${categoryDto.id}">
            </#if>

            <div class="mb-3">
                <label class="form-label">Название категории</label>
                <input type="text" name="name"
                       class="form-control <#if errors?has_content && errors.hasFieldErrors('name')>is-invalid</#if>"
                       value="${categoryDto.name!}" required>
                <#if errors?has_content && errors.hasFieldErrors("name")>
                    <div class="invalid-feedback">
                        ${errors.getFieldError("name").defaultMessage}
                    </div>
                </#if>
            </div>

            <div class="mb-3">
                <label class="form-label">Описание</label>
                <textarea name="description"
                          class="form-control <#if errors?has_content && errors.hasFieldErrors('description')>is-invalid</#if>"
                          rows="4">${categoryDto.description!}</textarea>
                <#if errors?has_content && errors.hasFieldErrors("description")>
                    <div class="invalid-feedback">
                        ${errors.getFieldError("description").defaultMessage}
                    </div>
                </#if>
            </div>

            <div class="d-flex gap-2 flex-wrap">
                <button type="submit" class="btn btn-primary-custom">
                    <i class="fas fa-save me-2"></i>Сохранить
                </button>
                <a href="/admin/categories" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Назад
                </a>
            </div>
        </form>
    </div>
</@layout.page>
