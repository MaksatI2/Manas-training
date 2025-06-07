<#include "../layout.ftlh">

<@page>
    <div class="hero-section">
        <h1 class="hero-title">
            <i class="fas fa-building me-3"></i>
            Регистрация компании
        </h1>
        <p class="hero-subtitle">Заполните форму для создания корпоративного аккаунта</p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
            <div class="feature-card">
                <form action="/auth/register/company" method="post" id="companyForm">
                    <div class="mb-3">
                        <label for="companyName" class="form-label">
                            <i class="fas fa-building me-1"></i>Название компании *
                        </label>
                        <input type="text" class="form-control" id="companyName" name="companyName">
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope me-1"></i>Email *
                        </label>
                        <input type="email" class="form-control" id="email" name="email">
                        <div class="form-text">Корпоративный email для связи</div>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="fas fa-lock me-1"></i>Пароль *
                        </label>
                        <input type="password" class="form-control" id="password" name="password">
                        <div class="form-text">Минимум 6 символов</div>
                    </div>

                    <div class="mb-4">
                        <label for="phone" class="form-label">
                            <i class="fas fa-phone me-1"></i>Номер телефона *
                        </label>
                        <input type="tel" class="form-control" id="phone" name="phone"
                               placeholder="+996700270984"
                               pattern="\+996[0-9]{9}">
                        <div class="form-text">Формат: +996700270984</div>
                    </div>

                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="businessAgreement" required>
                            <label class="form-check-label" for="businessAgreement">
                                Я подтверждаю, что имею право представлять данную компанию *
                            </label>
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-building me-2"></i>Зарегистрировать компанию
                        </button>
                    </div>
                </form>
            </div>

            <div class="text-center mt-4">
                <p class="text-muted">
                    Уже есть аккаунт?
                    <a href="/auth/login" style="color: var(--primary-blue);">Войти</a>
                </p>
                <p class="text-muted">
                    <a href="/auth/register" style="color: var(--primary-blue);">
                        <i class="fas fa-arrow-left me-1"></i>Вернуться к выбору типа регистрации
                    </a>
                </p>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('phone').addEventListener('input', function(e) {
            let value = e.target.value;
            if (!value.startsWith('+996')) {
                if (value.startsWith('+')) {
                    e.target.value = '+996' + value.substring(1);
                } else if (value.startsWith('996')) {
                    e.target.value = '+' + value;
                } else if (value.length > 0 && !value.startsWith('+996')) {
                    e.target.value = '+996' + value;
                }
            }
        });

        document.getElementById('phone').addEventListener('focus', function(e) {
            if (e.target.value === '') {
                e.target.value = '+996';
            }
        });
    </script>
</@page>