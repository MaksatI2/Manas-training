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
            <i class="fas fa-user-graduate me-3"></i>
            Регистрация студента
        </h1>
        <p class="hero-subtitle">Заполните форму для создания аккаунта студента</p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
            <div class="feature-card">
                <form action="/auth/register/student" method="post" id="studentForm">
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="firstName" class="form-label">
                                <i class="fas fa-user me-1"></i>Имя *
                            </label>
                            <@spring.formInput "studentRegisterDto.name" ' class="form-control" id="firstName"'/>
                            <div class="error-block">
                                <@spring.showErrors  "<br>" "error-message" />
                            </div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="lastName" class="form-label">
                                <i class="fas fa-user me-1"></i>Фамилия *
                            </label>
                            <@spring.formInput "studentRegisterDto.surname" ' class="form-control" id="lastName"'/>
                            <div class="error-block">
                                <@spring.showErrors "<br>" "error-message" />
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope me-1"></i>Email *
                        </label>
                        <@spring.formInput "studentRegisterDto.email" ' type="email" class="form-control" id="email"'/>
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="fas fa-lock me-1"></i>Пароль *
                        </label>
                        <@spring.formPasswordInput "studentRegisterDto.password" ' type="password" class="form-control" id="password"'/>
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                        <div class="form-text">Минимум 8 символов, хотя бы одна заглавная буква и цифра</div>
                    </div>

                    <div class="mb-3">
                        <label for="companyCode" class="form-label">
                            <i class="fas fa-building me-1"></i>Код компании
                        </label>
                        <@spring.formInput  "studentRegisterDto.organizationCode" ' class="form-control" id="companyCode" placeholder="Необязательное поле"'/>
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                        <div class="form-text">Если вы обучаетесь от компании, введите код компании</div>
                    </div>

                    <div class="mb-4">
                        <label for="phone" class="form-label">
                            <i class="fas fa-phone me-1"></i>Номер телефона *
                        </label>
                        <@spring.formInput "studentRegisterDto.phone" ' type="tel" class="form-control" id="phone" autocomplete="off"'/>
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-user-plus me-2"></i>Зарегистрироваться
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

            document.getElementById("studentForm").addEventListener("submit", function(e) {
                const number = iti.getNumber();
                input.value = number;
            });
        });
    </script>
</@page>