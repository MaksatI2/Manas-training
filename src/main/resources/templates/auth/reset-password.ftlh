<#include "../layout.ftlh">
<@page>
    <div class="hero-section">
        <h1 class="hero-title">
            <i class="fas fa-lock me-3"></i>Установка нового пароля
        </h1>
        <p class="hero-subtitle">Введите новый пароль для восстановления доступа</p>
    </div>

    <#if message??>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </#if>
    <#if error??>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i>
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </#if>

    <div class="row justify-content-center">
        <div class="col-lg-5 col-md-7">
            <div class="feature-card">
                <form method="post" action="/auth/reset-password" id="resetForm">
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </#if>
                    <input type="hidden" name="token" value="${token!}"/>

                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="fas fa-key me-1"></i>Новый пароль
                        </label>
                        <div class="input-group">
                            <input type="password" class="form-control" name="password" id="password"
                                   placeholder="Введите новый пароль">
                            <button type="button" class="btn btn-outline-secondary" id="togglePassword">
                                <i class="fas fa-eye" id="eyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="confirm" class="form-label">
                            <i class="fas fa-key me-1"></i>Повторите пароль
                        </label>
                        <input type="password" class="form-control" name="confirmPassword" id="confirm"
                               placeholder="Повторите новый пароль">
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-check me-2"></i>Сбросить пароль
                        </button>
                    </div>
                </form>
            </div>

            <div class="text-center mt-4">
                <a href="/auth/login" style="color: var(--primary-blue);">
                    <i class="fas fa-arrow-left me-1"></i>Вернуться к входу
                </a>
            </div>
        </div>
    </div>

    <script>
        const toggleBtn = document.getElementById('togglePassword');
        const password = document.getElementById('password');
        const confirm = document.getElementById('confirm');
        const eyeIcon = document.getElementById('eyeIcon');

        toggleBtn.addEventListener('click', function () {
            const type = password.type === 'password' ? 'text' : 'password';
            password.type = type;
            confirm.type = type;
            eyeIcon.classList.toggle('fa-eye');
            eyeIcon.classList.toggle('fa-eye-slash');
        });
    </script>
</@page>
