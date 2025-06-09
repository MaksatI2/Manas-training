<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">

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
                    <@spring.formHiddenInput "passwordResetDto.token" />

                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="fas fa-key me-1"></i>Новый пароль *
                        </label>
                        <div class="input-group">
                            <@spring.formPasswordInput "passwordResetDto.password", "class='form-control' id='password' placeholder='Введите новый пароль'" />
                            <button type="button" class="btn btn-outline-secondary" id="togglePassword">
                                <i class="fas fa-eye" id="eyeIcon"></i>
                            </button>
                        </div>
                        <div class="error-block"><@spring.showErrors "<br>" /></div>
                        <div class="form-text">Минимум 8 символов, хотя бы одна заглавная буква и цифра</div>
                    </div>

                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">
                            <i class="fas fa-key me-1"></i>Повторите пароль *
                        </label>
                        <@spring.formPasswordInput "passwordResetDto.confirmPassword", "class='form-control' id='confirmPassword' placeholder='Повторите новый пароль'" />
                        <div class="error-block"><@spring.showErrors "passwordResetDto.confirmPassword", "<br>" /></div>
                    </div>

                    <#if spring.status.error>
                        <div class="error-block mb-3">
                            <@spring.showErrors "<br>" />
                        </div>
                    </#if>

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
        const confirmPassword = document.getElementById('confirmPassword');
        const eyeIcon = document.getElementById('eyeIcon');
        const resetForm = document.getElementById('resetForm');

        function showError(input, message) {
            const errorBlock = input.nextElementSibling;
            if (errorBlock && errorBlock.classList.contains('error-block')) {
                errorBlock.textContent = message;
                errorBlock.style.display = 'block';
            } else {
                const newErrorBlock = document.createElement('div');
                newErrorBlock.className = 'error-block';
                newErrorBlock.textContent = message;
                input.parentNode.insertBefore(newErrorBlock, input.nextSibling);
            }
        }

        function hideError(input) {
            const errorBlock = input.nextElementSibling;
            if (errorBlock && errorBlock.classList.contains('error-block')) {
                errorBlock.style.display = 'none';
            }
        }

        function validatePasswords() {
            let isValid = true;

            if (password.value !== confirmPassword.value) {
                showError(confirmPassword, 'Пароли не совпадают');
                isValid = false;
            } else {
                hideError(confirmPassword);
            }

            return isValid;
        }

        resetForm.addEventListener('submit', function(e) {
            if (!validatePasswords()) {
                e.preventDefault();
            }
        });

        confirmPassword.addEventListener('input', function() {
            if (password.value !== confirmPassword.value) {
                showError(confirmPassword, 'Пароли не совпадают');
            } else {
                hideError(confirmPassword);
            }
        });

        toggleBtn.addEventListener('click', function () {
            const type = password.type === 'password' ? 'text' : 'password';
            password.type = type;
            confirmPassword.type = type;
            eyeIcon.classList.toggle('fa-eye');
            eyeIcon.classList.toggle('fa-eye-slash');
        });
    </script>
</@page>