<#import "/layout.ftlh" as layout>
<@layout.page>
    <style>
        :root {
            --primary-blue: #0066cc;
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

        .form-label {
            font-weight: 500;
        }
    </style>

    <h1 class="page-title">Редактирование студента</h1>

    <form method="post" action="/organization/students/${student.studentId}/edit" class="form-wrapper mt-4">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <div class="mb-3">
            <label for="name" class="form-label">Имя</label>
            <input type="text" class="form-control" id="name" name="name"
                   value="${student.name!}" placeholder="Введите имя">
        </div>

        <div class="mb-3">
            <label for="lastName" class="form-label">Фамилия</label>
            <input type="text" class="form-control" id="lastName" name="lastName"
                   value="${student.lastName!}" placeholder="Введите фамилию">
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email"
                   value="${student.email!}" placeholder="example@email.com">
        </div>

        <div class="mb-4">
            <label for="phone" class="form-label">Телефон</label>
            <input type="text" class="form-control" id="phone" name="phone"
                   value="${student.phone!}" placeholder="+996xxxxxxxxx">
        </div>

        <div class="d-flex justify-content-between">
            <button type="submit" class="btn btn-gradient px-4 rounded-pill">
                <i class="fas fa-save me-2"></i>Сохранить
            </button>
            <a href="/organization/students" class="btn btn-outline-primary px-4 rounded-pill">Отмена</a>
        </div>
    </form>
</@layout.page>
