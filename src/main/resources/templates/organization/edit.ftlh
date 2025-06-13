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
            <i class="fas fa-user-graduate me-3"></i>
            Редактирование профиля
        </h1>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
            <div class="feature-card">
                <form action="/organization/profile/edit" method="post" id="studentForm">
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </#if>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="firstName" class="form-label">
                                <i class="fas fa-user me-1"></i>Имя *
                            </label>
                            <@spring.formInput "organizationProfile.name" ' class="form-control" id="firstName"'/>
                            <div class="error-block">
                                <@spring.showErrors  "<br>" "error-message" />
                            </div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="lastName" class="form-label">
                                <i class="fas fa-user me-1"></i>Фамилия *
                            </label>
                            <@spring.formInput "organizationProfile.surname" ' class="form-control" id="lastName"'/>
                            <div class="error-block">
                                <@spring.showErrors "<br>" "error-message" />
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="organizationName" class="form-label">
                            <i class="fas fa-building me-1"></i>Название организации
                        </label>
                        <@spring.formInput  "organizationProfile.organizationName" ' class="form-control"'/>
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="phone" class="form-label">
                            <i class="fas fa-phone me-1"></i>Номер телефона *
                        </label>
                        <@spring.formInput  "organizationProfile.phone"' type="tel" class="form-control" id="phone" placeholder="+996700270984"'/>
                        <div class="form-text">Формат: +996700270984</div>
                        <div class="error-block">
                            <#if errorMessage??>
                                <span class="error-message">${errorMessage}</span>
                            </#if>
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                    </div>
                    <input type="hidden" name="userId" value="${organizationProfile.userId}">

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-user-plus me-2"></i>Сохранить
                        </button>
                    </div>
                </form>
            </div>

            <div class="text-center mt-4">
                <p class="text-muted">
                    <a href="/student/profile" style="color: var(--primary-blue);">
                        <i class="fas fa-arrow-left me-1"></i>Вернуться в личный кабинет
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