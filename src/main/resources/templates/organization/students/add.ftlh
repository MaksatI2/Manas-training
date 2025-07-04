<#import "/templates/layout.ftlh" as layout>
<#import "/templates/RoadMap.ftlh" as roadmap>
<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Студенты", "url": "/organization/students"},
    {"label": "Добавить студента", "url": ""}
    ] />
    <style>
        :root {
            --primary-blue: #0066cc;
            --light-blue: #87ceeb;
            --white: #ffffff;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
        }

        .page-title {
            text-align: center;
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin: 2rem 0 1.5rem;
        }

        .form-wrapper {
            max-width: 550px;
            margin: 0 auto;
            background: #fff;
            padding: 2rem;
            border-left: 4px solid var(--primary-blue);
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
        }

        .btn-gradient {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: #fff;
            border: none;
            transition: all 0.3s ease;
        }

        .btn-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }

        .alert-compact {
            max-width: 550px;
            margin: 1rem auto -1rem;
            font-size: 0.9rem;
            padding: 0.75rem 1rem;
        }

        .form-label {
            font-weight: 500;
        }

        .error-message {
            font-size: 0.85rem;
            color: #dc3545;
            margin-top: 0.25rem;
        }
    </style>

    <h1 class="page-title">Добавление нового студента</h1>

    <div class="form-wrapper mt-4">
        <#if errorMessage??>
            <div class="alert alert-danger alert-compact text-center rounded shadow-sm">${errorMessage}</div>
        </#if>

        <#if successMessage??>
            <div class="alert alert-success alert-compact text-center rounded shadow-sm">${successMessage}</div>
        </#if>

        <form method="post" action="/organization/students/add">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="mb-3">
                <label for="name" class="form-label">Имя</label>
                <input type="text" class="form-control" id="name" name="name"
                       value="${studentDto.name!}" placeholder="Введите имя">
                <div class="error-message"><#if validationErrors??>${validationErrors["name"]!}</#if></div>
            </div>

            <div class="mb-3">
                <label for="lastName" class="form-label">Фамилия</label>
                <input type="text" class="form-control" id="lastName" name="lastName"
                       value="${studentDto.lastName!}" placeholder="Введите фамилию">
                <div class="error-message"><#if validationErrors??>${validationErrors["lastName"]!}</#if></div>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email"
                       value="${studentDto.email!}" placeholder="example@email.com">
                <div class="error-message"><#if validationErrors??>${validationErrors["email"]!}</#if></div>
            </div>

            <div class="mb-4">
                <label for="phone" class="form-label">Телефон</label>
                <input type="text" class="form-control" id="phone" name="phone"
                       value="${studentDto.phone!}" placeholder="+996xxxxxxxxx">
                <div class="error-message"><#if validationErrors??>${validationErrors["phone"]!}</#if></div>
            </div>

            <div class="d-flex justify-content-between">
                <button type="submit" class="btn btn-gradient px-4 rounded-pill">
                    <i class="fas fa-user-plus me-2"></i>Сохранить
                </button>
                <a href="/organization/students" class="btn btn-outline-primary px-4 rounded-pill">Отмена</a>
            </div>
        </form>
    </div>
</@layout.page>
