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
            <i class="fas fa-user-edit me-3"></i>
            Редактирование профиля преподавателя
        </h1>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            <div class="feature-card">
                <form action="/teacher/profile/edit" method="post" id="teacherForm">
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </#if>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="firstName" class="form-label">
                                <i class="fas fa-user me-1"></i>Имя *
                            </label>
                            <@spring.formInput "teacherEditDto.name" ' class="form-control" id="firstName"'/>
                            <div class="error-block">
                                <@spring.showErrors  "<br>" "error-message" />
                            </div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="lastName" class="form-label">
                                <i class="fas fa-user me-1"></i>Фамилия *
                            </label>
                            <@spring.formInput "teacherEditDto.surname" ' class="form-control" id="lastName"'/>
                            <div class="error-block">
                                <@spring.showErrors  "<br>" "error-message" />
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label">
                            <i class="fas fa-phone me-1"></i>Номер телефона *
                        </label>
                        <@spring.formInput "teacherEditDto.phone" ' type="tel" class="form-control" id="phone" placeholder="+996700270984"'/>
                        <div class="form-text">Формат: +996700270984</div>
                        <div class="error-block">
                            <@spring.showErrors  "<br>" "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="department" class="form-label">
                            <i class="fas fa-building me-1"></i>Отделение *
                        </label>
                        <@spring.formInput "teacherEditDto.department" ' class="form-control" id="department"'/>
                        <div class="error-block">
                            <@spring.showErrors  "<br>" "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="qualifications" class="form-label">
                            <i class="fas fa-certificate me-1"></i>Квалификация *
                        </label>
                        <@spring.formInput "teacherEditDto.qualifications" ' class="form-control" id="qualifications"'/>
                        <div class="error-block">
                            <@spring.showErrors  "<br>" "error-message" />
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="bio" class="form-label">
                            <i class="fas fa-info-circle me-1"></i>О себе
                        </label>
                        <@spring.formTextarea "teacherEditDto.bio" ' class="form-control" id="bio" rows="4" placeholder="Расскажите немного о себе, вашем опыте работы и достижениях..."'/>
                        <div class="error-block">
                            <@spring.showErrors  "<br>" "error-message" />
                        </div>
                    </div>

                    <input type="hidden" name="userId" value="${teacherEditDto.userId}">

                    <div class="text-center mt-4">
                        <button type="submit" class="btn btn-primary-custom" style="padding: 0.3rem 0.9rem !important;">
                            <i class="fas fa-save me-2"></i>Сохранить
                        </button>
                    </div>
                </form>
            </div>

            <div class="text-center mt-4">
                <p class="text-muted">
                    <a href="/teacher/profile" style="color: var(--primary-blue);">
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