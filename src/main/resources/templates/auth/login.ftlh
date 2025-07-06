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
            <#if quickLoginAvailable?? && quickLoginAvailable>
                <div class="feature-card mb-4" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                    <div class="d-flex align-items-center mb-3">
                        <div class="flex-shrink-0">
                            <i class="fas fa-user-circle fa-3x"></i>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h5 class="mb-1">Добро пожаловать обратно!</h5>
                            <p class="mb-0">${quickLoginName}</p>
                            <small class="text-light">${quickLoginEmail}</small>
                        </div>
                    </div>
                    <p class="small mb-3">
                        <i class="fas fa-clock me-1"></i>
                        Прошлый раз вы заходили с этого устройства. Хотите войти снова?
                    </p>
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <form action="/auth/quick-login" method="post" class="me-md-2">
                            <#if _csrf??>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            </#if>
                            <button type="submit" class="btn btn-light btn-sm">
                                <i class="fas fa-sign-in-alt me-1"></i>Быстрый вход
                            </button>
                        </form>
                        <form action="/auth/dismiss-quick-login" method="post">
                            <#if _csrf??>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            </#if>
                            <button type="submit" class="btn btn-outline-light btn-sm">
                                <i class="fas fa-times me-1"></i>Не я
                            </button>
                        </form>
                    </div>
                </div>
            </#if>

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

                <form action="/login" method="post">
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </#if>

                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope me-1"></i>Email
                        </label>
                        <input type="email" class="form-control" id="login" name="login"
                               placeholder="Введите ваш email" <#if quickLoginEmail??>value="${quickLoginEmail}"</#if>>
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

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                                <label class="form-check-label" for="rememberMe">
                                    <i class="fas fa-bookmark me-1"></i>Запомнить меня
                                </label>
                            </div>
                        </div>
                        <div class="col-md-6 text-end">
                            <a href="/auth/forgot-password" style="color: var(--primary-blue);" class="small">
                                <i class="fas fa-key me-1"></i>Забыли пароль?
                            </a>
                        </div>
                    </div>

                    <div class="d-grid gap-2 mb-3">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-sign-in-alt me-2"></i>Войти
                        </button>
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

        <#if quickLoginEmail??>
        document.getElementById('password').focus();
        <#else>
        document.getElementById('login').focus();
        </#if>

        document.getElementById('rememberMe').addEventListener('change', function() {
            const label = document.querySelector('label[for="rememberMe"]');
            if (this.checked) {
                label.title = 'Мы запомним вас на этом устройстве на год';
            } else {
                label.title = '';
            }
        });
    </script>
</@page>