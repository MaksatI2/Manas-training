<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/css/intlTelInput.min.css" />
<script src="https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/intlTelInput.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/utils.js"></script>

<style>

    .error-block {
        margin-top: 5px;
        color: red;
        font-size: 13px;
    }
</style>
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
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />

                    <div class="mb-3">
                        <label for="companyName" class="form-label">
                            <i class="fas fa-building me-1"></i>Название компании *
                        </label>
                        <@spring.formInput "organizationDto.companyName", "class='form-control' id='companyName'" />
                        <div class="error-block"><@spring.showErrors "<br>" "error-message" /></div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope me-1"></i>Email *
                        </label>
                        <@spring.formInput "organizationDto.email", "class='form-control' id='email'" />
                        <div class="error-block"><@spring.showErrors "<br>" "error-message" /></div>
                        <div class="form-text">Корпоративный email для связи</div>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="fas fa-lock me-1"></i>Пароль *
                        </label>
                        <@spring.formPasswordInput "organizationDto.password", "class='form-control' id='password'" />
                        <div class="error-block"><@spring.showErrors "<br>" "error-message" /></div>
                        <div class="form-text">Минимум 8 символов, хотя бы одна заглавная буква и цифра</div>
                    </div>

                    <div class="mb-4">
                        <label for="phone" class="form-label">
                            <i class="fas fa-phone me-1"></i>Номер телефона *
                        </label>
                        <@spring.formInput "organizationDto.phone" ' type="tel" class="form-control" id="phone" autocomplete="off"'/>
                        <div class="error-block"><@spring.showErrors "<br>" "error-message" /></div>
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
        const input = document.querySelector("#phone");
        const errorBlock = document.querySelector("#phone").nextElementSibling.nextElementSibling;

        input.addEventListener("input", () => {
            if (iti.isValidNumber()) {
                input.style.borderColor = "green";
                errorBlock.textContent = "";
            } else {
                input.style.borderColor = "red";
                errorBlock.textContent = "Некорректный номер";
            }
        });

        document.addEventListener("DOMContentLoaded", function() {
            const input = document.querySelector("#phone");
            const iti = window.intlTelInput(input, {
                preferredCountries: ["kg", "ru", "kz", "uz"],
                initialCountry: "kg",
                geoIpLookup: function(callback) {
                    fetch('https://ipinfo.io/json?token=ваш_токен')
                        .then(resp => resp.json())
                        .then(resp => callback(resp.country || "kg"))
                        .catch(() => callback("kg"));
                },
                formatOnDisplay: true,
                utilsScript: "https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/utils.js"
            });

            document.getElementById("companyForm").addEventListener("submit", function(e) {
                const number = iti.getNumber();
                input.value = number;
            });
        });


    </script>
</@page>