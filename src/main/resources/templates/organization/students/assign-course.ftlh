<#import "/layout.ftlh" as layout>
<@layout.page>
    <style>
        :root {
            --primary-blue: #0066cc;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
        }

        .breadcrumb-wrapper {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: white;
            padding: 0.75rem 0;
        }

        .breadcrumb-wrapper .container {
            display: flex;
            align-items: center;
            font-size: 0.95rem;
        }

        .breadcrumb-wrapper a {
            color: white;
            text-decoration: none;
            margin-right: 0.5rem;
        }

        .breadcrumb-separator {
            margin: 0 0.4rem;
            color: #ccc;
        }

        .breadcrumb-current {
            font-weight: 600;
            color: #fff;
        }

        .page-title {
            text-align: center;
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin: 2rem 0 1.5rem;
        }

        .form-wrapper {
            max-width: 500px;
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
            max-width: 500px;
            margin: 1rem auto -1rem;
            font-size: 0.9rem;
            padding: 0.75rem 1rem;
        }

        .form-label {
            font-weight: 500;
        }
    </style>

    <div class="breadcrumb-wrapper text-center">
        <nav class="breadcrumb-nav d-inline-block">
            <a href="/">Главная</a>
            <span class="breadcrumb-separator">›</span>
            <a href="/organization/students">Сотрудники</a>
            <span class="breadcrumb-separator">›</span>
            <span class="breadcrumb-current">Назначение курса</span>
        </nav>
    </div>

    <h1 class="page-title">Назначение курса студенту</h1>

    <#if errorMessage??>
        <div class="alert alert-danger alert-compact text-center rounded shadow-sm">${errorMessage}</div>
    </#if>

    <form method="post" action="" class="form-wrapper mt-4">
        <input type="hidden" name="studentId" value="${assignDto.studentId}"/>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <div class="mb-3">
            <label for="courseInstanceId" class="form-label">Выберите курс</label>
            <select class="form-select" id="courseInstanceId" name="courseInstanceId" required>
                <#if courses?? && courses?size gt 0>
                    <#list courses as course>
                        <option value="${course.id}">${course.title}</option>
                    </#list>
                <#else>
                    <option disabled selected>Нет доступных курсов</option>
                </#if>
            </select>
        </div>

        <div class="d-flex justify-content-between">
            <button type="submit" class="btn btn-gradient px-4 rounded-pill">
                <i class="fas fa-book me-2"></i>Назначить
            </button>
            <a href="/organization/students" class="btn btn-outline-primary px-4 rounded-pill">Отмена</a>
        </div>
    </form>
</@layout.page>
