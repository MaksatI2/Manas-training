<#include "../layout.ftlh">

<@page>
    <div class="hero-section">
        <h1 class="hero-title">
            <i class="fas fa-sign-in-alt me-3"></i>
            Вход в систему
        </h1>
        <p class="hero-subtitle">Войдите в свой аккаунт для доступа к курсам</p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-5 col-md-7">
            <div class="feature-card">
                <#if message??>
                    <div class="alert alert-info alert-dismissible fade show" role="alert">
                        <i class="fas fa-info-circle me-2"></i>
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

                <form action="/auth/login" method="post" id="loginForm">
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </#if>

                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope me-1"></i>Email
                        </label>
                        <input type="email" class="form-control" id="email" name="email"
                               placeholder="Введите ваш email">
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="fas fa-lock me-1"></i>Пароль
                        </label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="password" name="password"
                                   placeholder="Введите ваш пароль">
                            <button type="button" class="btn btn-outline-secondary" id="togglePassword">
                                <i class="fas fa-eye" id="eyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                            <label class="form-check-label" for="rememberMe">
                                Запомнить меня
                            </label>
                        </div>
                    </div>

                    <div class="d-grid gap-2 mb-3">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-sign-in-alt me-2"></i>Войти
                        </button>
                    </div>

                    <div class="text-center">
                        <a href="/auth/forgot-password" style="color: var(--primary-blue);">
                            <i class="fas fa-key me-1"></i>Забыли пароль?
                        </a>
                    </div>
                </form>
            </div>

            <div class="text-center mt-4">
                <p class="text-muted mb-3">
                    Нет аккаунта? Зарегистрируйтесь:
                </p>
                <div class="d-grid gap-2 d-md-block">
                    <a href="/auth/register/student" class="btn btn-outline-primary me-md-2">
                        <i class="fas fa-user-graduate me-1"></i>Как студент
                    </a>
                    <a href="/auth/register/company" class="btn btn-outline-primary">
                        <i class="fas fa-building me-1"></i>Как компания
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('togglePassword').addEventListener('click', function() {
            const passwordField = document.getElementById('password');
            const eyeIcon = document.getElementById('eyeIcon');

            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                eyeIcon.classList.remove('fa-eye');
                eyeIcon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                eyeIcon.classList.remove('fa-eye-slash');
                eyeIcon.classList.add('fa-eye');
            }
        });

        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;

            if (!email || !password) {
                e.preventDefault();
                alert('Пожалуйста, заполните все обязательные поля');
                return;
            }
        });

        document.getElementById('email').focus();
    </script>
</@page>