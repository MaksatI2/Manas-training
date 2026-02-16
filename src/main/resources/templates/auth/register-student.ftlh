<#include "../layout.ftlh">
<#import "/spring.ftl" as spring>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/css/intlTelInput.min.css"/>
<script src="https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/intlTelInput.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/utils.js"></script>

<style>
    .error-block {
        margin-top: 5px;
        color: red;
        font-size: 13px;
    }

    #phone::placeholder {
        opacity: 0.7;
    }
</style>

<@page>
    <div class="hero-section">
        <h1 class="hero-title">
            <i class="fas fa-user-graduate me-3"></i>
            <@spring.message code="register.student.title"/>
        </h1>
        <p class="hero-subtitle"><@spring.message code="register.student.subtitle"/></p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
            <div class="feature-card">
                <form action="/auth/register/student" method="post" id="studentForm">
                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="firstName" class="form-label">
                                <i class="fas fa-user me-1"></i><@spring.message code="register.student.first.name"/>
                            </label>
                            <@spring.formInput "studentRegisterDto.name" ' class="form-control" id="firstName"'/>
                            <div class="error-block">
                                <@spring.showErrors  "<br>" "error-message" />
                            </div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="lastName" class="form-label">
                                <i class="fas fa-user me-1"></i><@spring.message code="register.student.last.name"/>
                            </label>
                            <@spring.formInput "studentRegisterDto.surname" ' class="form-control" id="lastName"'/>
                            <div class="error-block">
                                <@spring.showErrors "<br>" "error-message" />
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope me-1"></i><@spring.message code="register.student.email"/>
                        </label>
                        <@spring.formInput "studentRegisterDto.email" ' type="email" class="form-control" id="email"'/>
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="fas fa-lock me-1"></i><@spring.message code="register.student.password"/>
                        </label>
                        <@spring.formPasswordInput "studentRegisterDto.password" ' type="password" class="form-control" id="password"'/>
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                        <div class="form-text"><@spring.message code="register.student.password.hint"/></div>
                    </div>

                    <div class="mb-3">
                        <label for="companyCode" class="form-label">
                            <i class="fas fa-building me-1"></i><@spring.message code="register.student.company.code"/>
                        </label>
                        <@spring.formInput  "studentRegisterDto.organizationCode" ' class="form-control" id="companyCode" placeholder="${springMacroRequestContext.getMessage("register.student.company.code.placeholder")}"'/>
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                        <div class="form-text"><@spring.message code="register.student.company.code.hint"/></div>
                    </div>

                    <div class="mb-4">
                        <label for="phone" class="form-label">
                            <i class="fas fa-phone me-1"></i><@spring.message code="register.student.phone"/>
                        </label>
                        <@spring.formInput "studentRegisterDto.phone" ' type="tel" class="form-control" id="phone" autocomplete="off" '/>
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-user-plus me-2"></i><@spring.message code="register.student.button"/>
                        </button>
                    </div>
                </form>
            </div>

            <div class="text-center mt-4">
                <p class="text-muted">
                    <@spring.message code="register.student.login.question"/>
                    <a href="/auth/login"
                       style="color: var(--primary-blue);"><@spring.message code="register.student.login.link"/></a>
                </p>
                <p class="text-muted">
                    <a href="/auth/register" style="color: var(--primary-blue);">
                        <i class="fas fa-arrow-left me-1"></i><@spring.message code="register.student.back.choice"/>
                    </a>
                </p>
            </div>
        </div>
    </div>

    <div id="i18n-holder"
         data-phone-invalid="<@spring.message code='register.student.phone.invalid'/>">
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const input = document.querySelector("#phone");
            const i18n = document.getElementById('i18n-holder').dataset;
            let iti;

            try {
                iti = window.intlTelInput(input, {
                    preferredCountries: ["kg", "ru", "kz", "uz"],
                    initialCountry: "kg",
                    geoIpLookup: function (callback) {
                        fetch('https://ipinfo.io/json?token=ваш_токен')
                            .then(resp => resp.json())
                            .then(resp => callback(resp && resp.country ? resp.country : "kg"))
                            .catch(() => callback("kg"));
                    },
                    formatOnDisplay: true,
                    utilsScript: "https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/utils.js"
                });
            } catch (e) {
            }

            input.addEventListener("input", () => {
                if (iti && iti.isValidNumber()) {
                    input.style.borderColor = "green";
                    const err = input.closest('.mb-4, .mb-3')?.querySelector('.error-block');
                    if (err) err.textContent = "";
                } else {
                    input.style.borderColor = "red";
                    const err = input.closest('.mb-4, .mb-3')?.querySelector('.error-block');
                    if (err) err.textContent = i18n.phoneInvalid;
                }
            });

            document.getElementById("studentForm").addEventListener("submit", function () {
                if (iti) {
                    input.value = iti.getNumber();
                }
            });
        });
    </script>
</@page>
