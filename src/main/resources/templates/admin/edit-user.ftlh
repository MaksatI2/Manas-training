<#import "../layout.ftlh" as layout>

<@layout.page>
    <div class="card shadow mb-4">
        <#if successMessage??>
            <div id="successMessage" data-message="${successMessage?js_string}"></div>
        </#if>
        <#if errorMessage??>
            <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
        </#if>
        <div class="card-header py-3 d-flex justify-content-between align-items-center" style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-user-edit me-2"></i>
                Редактировать пользователя
            </h5>
            <div>
                <a href="/admin/users" class="btn btn-light btn-sm me-2" style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-arrow-left me-1" style="color: #0066cc;"></i> Назад к списку
                </a>
            </div>
        </div>

        <div class="card-body">
            <form action="/admin/users/${userEditDto.id}/edit" method="post" novalidate>
                <#if _csrf??>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </#if>

                <input type="hidden" name="id" value="${userEditDto.id!''}">


                <div class="mb-3">
                    <label for="email" class="form-label required">Email</label>
                    <input type="email"
                           class="form-control <#if .globals['org.springframework.validation.BindingResult.userEditDto']?? && .globals['org.springframework.validation.BindingResult.userEditDto'].hasFieldErrors('email')>is-invalid</#if>"
                           id="email"
                           name="email"
                           value="${userEditDto.email!''}"
                           maxlength="100"
                           required>
                    <#if .globals['org.springframework.validation.BindingResult.userEditDto']?? && .globals['org.springframework.validation.BindingResult.userEditDto'].hasFieldErrors('email')>
                        <div class="invalid-feedback">
                            <#list .globals['org.springframework.validation.BindingResult.userEditDto'].getFieldErrors('email') as error>
                                ${error.defaultMessage}<#if error_has_next><br></#if>
                            </#list>
                        </div>
                    </#if>
                </div>


                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="name" class="form-label required">Имя</label>
                        <input type="text"
                               class="form-control <#if .globals['org.springframework.validation.BindingResult.userEditDto']?? && .globals['org.springframework.validation.BindingResult.userEditDto'].hasFieldErrors('name')>is-invalid</#if>"
                               id="name"
                               name="name"
                               value="${userEditDto.name!''}"
                               maxlength="50"
                               required>
                        <#if .globals['org.springframework.validation.BindingResult.userEditDto']?? && .globals['org.springframework.validation.BindingResult.userEditDto'].hasFieldErrors('name')>
                            <div class="invalid-feedback">
                                <#list .globals['org.springframework.validation.BindingResult.userEditDto'].getFieldErrors('name') as error>
                                    ${error.defaultMessage}<#if error_has_next><br></#if>
                                </#list>
                            </div>
                        </#if>

                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="lastName" class="form-label required">Фамилия</label>
                        <input type="text"
                               class="form-control <#if .globals['org.springframework.validation.BindingResult.userEditDto']?? && .globals['org.springframework.validation.BindingResult.userEditDto'].hasFieldErrors('lastName')>is-invalid</#if>"
                               id="lastName"
                               name="lastName"
                               value="${userEditDto.lastName!''}"
                               maxlength="50"
                               required>
                        <#if .globals['org.springframework.validation.BindingResult.userEditDto']?? && .globals['org.springframework.validation.BindingResult.userEditDto'].hasFieldErrors('phone')>
                            <div class="invalid-feedback">
                                <#list .globals['org.springframework.validation.BindingResult.userEditDto'].getFieldErrors('lastName') as error>
                                    ${error.defaultMessage}<#if error_has_next><br></#if>
                                </#list>
                            </div>
                        </#if>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">Телефон</label>
                    <input type="text"
                           class="form-control <#if .globals['org.springframework.validation.BindingResult.userEditDto']?? && .globals['org.springframework.validation.BindingResult.userEditDto'].hasFieldErrors('phone')>is-invalid</#if>"
                           id="phone"
                           name="phone"
                           value="${userEditDto.phone!''}"
                           maxlength="20">
                    <#if .globals['org.springframework.validation.BindingResult.userEditDto']?? && .globals['org.springframework.validation.BindingResult.userEditDto'].hasFieldErrors('phone')>
                        <div class="invalid-feedback">
                            <#list .globals['org.springframework.validation.BindingResult.userEditDto'].getFieldErrors('phone') as error>
                                ${error.defaultMessage}
                            </#list>
                        </div>
                    </#if>
                </div>

                <div class="d-flex justify-content-end gap-2">
                    <a href="/admin/users" class="btn btn-secondary">
                        <i class="fas fa-times me-1"></i> Отмена
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Сохранить пользователя
                    </button>
                </div>
            </form>
        </div>
    </div>

    <style>
        .required::after {
            content: " *";
            color: #dc3545;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
        }
        .form-control {
            border-radius: 8px;
            border: 1px solid #ced4da;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #0066cc;
            box-shadow: 0 0 0 0.2rem rgba(0, 102, 204, 0.25);
        }
        .btn {
            border-radius: 8px;
            padding: 0.5rem 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
        }
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #545b62;
            transform: translateY(-1px);
        }
        .invalid-feedback {
            display: block;
        }
        .gap-2 {
            gap: 0.5rem;
        }
    </style>
</@layout.page>
