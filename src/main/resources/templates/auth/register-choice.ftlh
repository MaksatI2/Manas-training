<#include "../layout.ftlh">

<@page>
    <div class="hero-section">
        <h1 class="hero-title">Регистрация</h1>
        <p class="hero-subtitle">Выберите тип аккаунта для регистрации</p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="feature-card text-center h-100">
                        <div class="feature-icon">
                            <i class="fas fa-user-graduate"></i>
                        </div>
                        <h4 class="mb-3" style="color: var(--primary-blue);">Студент</h4>
                        <p class="mb-4">Зарегистрируйтесь как студент для прохождения курсов и получения сертификатов</p>
                        <ul class="list-unstyled text-start mb-2">
                            <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i>Доступ к курсам</li>
                            <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i>Получение сертификатов</li>
                            <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i>Отслеживание прогресса</li>
                            <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i>Личный кабинет</li>
                        </ul>
                        <a href="/auth/register/student" class="btn btn-primary-custom">
                            <i class="fas fa-user-plus me-2"></i>Регистрация студента
                        </a>
                    </div>
                </div>

                <div class="col-md-6 mb-4">
                    <div class="feature-card text-center h-100">
                        <div class="feature-icon">
                            <i class="fas fa-building"></i>
                        </div>
                        <h4 class="mb-3" style="color: var(--primary-blue);">Компания</h4>
                        <p class="mb-4">Зарегистрируйте вашу компанию для обучения сотрудников</p>
                        <ul class="list-unstyled text-start mb-2">
                            <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i>Управление сотрудниками</li>
                            <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i>Корпоративные курсы</li>
                            <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i>Отчеты по обучению</li>
                        </ul>
                        <a href="/auth/register/company" class="btn btn-primary-custom">
                            <i class="fas fa-building me-2"></i>Регистрация компании
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="text-center mt-4">
        <p class="text-muted">
            Уже есть аккаунт?
            <a href="/auth/login" style="color: var(--primary-blue);">Войти</a>
        </p>
    </div>
    <style>
        .feature-card {
            display: flex;
            flex-direction: column;
            padding: 2rem 1.5rem;
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #fff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .feature-card .btn {
            margin-top: auto;
        }

    </style>
</@page>