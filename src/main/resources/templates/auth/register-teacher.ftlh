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
            <i class="fas fa-chalkboard-teacher me-3"></i>
            Регистрация преподавателя
        </h1>
        <p class="hero-subtitle">Заполните форму для создания аккаунта преподавателя</p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            <div class="feature-card">
                <form action="/admin/teachers/add" method="post" id="teacherForm">
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />

                    <div class="mb-4">
                        <h5 class="text-primary mb-3">
                            <i class="fas fa-user me-2"></i>Персональная информация
                        </h5>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="firstName" class="form-label">
                                    <i class="fas fa-user me-1"></i>Имя *
                                </label>
                                <@spring.formInput "teacherRegisterDto.name" ' class="form-control" id="firstName"'/>
                                <div class="error-block">
                                    <@spring.showErrors  "<br>" "error-message" />
                                </div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="lastName" class="form-label">
                                    <i class="fas fa-user me-1"></i>Фамилия *
                                </label>
                                <@spring.formInput "teacherRegisterDto.surname" ' class="form-control" id="lastName"'/>
                                <div class="error-block">
                                    <@spring.showErrors  "<br>" "error-message" />
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">
                                    <i class="fas fa-envelope me-1"></i>Email *
                                </label>
                                <@spring.formInput "teacherRegisterDto.email" ' type="email" class="form-control" id="email"'/>
                                <div class="error-block">
                                    <@spring.showErrors  "<br>" "error-message" />
                                </div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="phone" class="form-label">
                                    <i class="fas fa-phone me-1"></i>Номер телефона *
                                </label>
                                <@spring.formInput "teacherRegisterDto.phone" ' type="tel" class="form-control" id="phone" placeholder="+996700270984"'/>
                                <div class="form-text">Формат: +996700270984</div>
                                <div class="error-block">
                                    <@spring.showErrors  "<br>" "error-message" />
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">
                                <i class="fas fa-lock me-1"></i>Пароль *
                            </label>
                            <@spring.formPasswordInput "teacherRegisterDto.password" ' type="password" class="form-control" id="password"'/>
                            <div class="error-block">
                                <@spring.showErrors  "<br>" "error-message" />
                            </div>
                            <div class="form-text">Минимум 8 символов, хотя бы одна заглавная буква и цифра</div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <h5 class="text-primary mb-3">
                            <i class="fas fa-briefcase me-2"></i>Профессиональная информация
                        </h5>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="department" class="form-label">
                                    <i class="fas fa-building me-1"></i>Отделение *
                                </label>
                                <@spring.formInput "teacherRegisterDto.department" ' class="form-control" id="department" placeholder="Например: IT, Математика, Физика"'/>
                                <div class="error-block">
                                    <@spring.showErrors  "<br>" "error-message" />
                                </div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="qualifications" class="form-label">
                                    <i class="fas fa-certificate me-1"></i>Квалификация *
                                </label>
                                <@spring.formInput "teacherRegisterDto.qualifications" ' class="form-control" id="qualifications" placeholder="Например: Магистр информатики"'/>
                                <div class="error-block">
                                    <@spring.showErrors  "<br>" "error-message" />
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="bio" class="form-label">
                                <i class="fas fa-info-circle me-1"></i>Биография
                            </label>
                            <@spring.formTextarea "teacherRegisterDto.bio" ' class="form-control" id="bio" rows="4" placeholder="Краткая информация о преподавателе, опыт работы, достижения..."'/>
                            <div class="error-block">
                                <@spring.showErrors  "<br>" "error-message" />
                            </div>
                            <div class="form-text">Необязательное поле. Краткое описание опыта и достижений</div>
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-user-plus me-2"></i>Зарегистрировать преподавателя
                        </button>
                    </div>
                </form>
            </div>

            <div class="text-center mt-4">
                <p class="text-muted">
                    <a href="/admin/users" style="color: var(--primary-blue);">
                        <i class="fas fa-arrow-left me-1"></i>Вернуться к списку пользователей
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