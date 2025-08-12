<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
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
            <i class="fas fa-building me-3"></i>
            <@spring.message code="register.company.title" />
        </h1>
        <p class="hero-subtitle"><@spring.message code="register.company.subtitle" /></p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
            <div class="feature-card">
                <form action="/auth/register/company" method="post" id="companyForm">
                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>

                    <div class="mb-3">
                        <label for="companyName" class="form-label">
                            <i class="fas fa-building me-1"></i><@spring.message code="register.company.name" />
                        </label>
                        <@spring.formInput "organizationDto.companyName", "class='form-control' id='companyName'" />
                        <div class="error-block"><@spring.showErrors "<br>" "error-message" /></div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope me-1"></i><@spring.message code="register.company.email" />
                        </label>
                        <@spring.formInput "organizationDto.email", "class='form-control' id='email'" />
                        <div class="error-block"><@spring.showErrors "<br>" "error-message" /></div>
                        <div class="form-text"><@spring.message code="register.company.email.hint" /></div>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="fas fa-lock me-1"></i><@spring.message code="register.company.password" />
                        </label>
                        <@spring.formPasswordInput "organizationDto.password", "class='form-control' id='password'" />
                        <div class="error-block"><@spring.showErrors "<br>" "error-message" /></div>
                        <div class="form-text"><@spring.message code="register.company.password.hint" /></div>
                    </div>

                    <div class="mb-4">
                        <label for="phone" class="form-label">
                            <i class="fas fa-phone me-1"></i><@spring.message code="register.company.phone" />
                        </label>
                        <@spring.formInput "organizationDto.phone",
                        " type='tel' class='form-control' id='phone' autocomplete='off' placeholder='" +
                        (springMacroRequestContext.getMessage('register.company.phone.placeholder')) + "' " />
                        <div class="error-block"><@spring.showErrors "<br>" "error-message" /></div>
                    </div>

                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="businessAgreement" required>
                            <label class="form-check-label" for="businessAgreement">
                                <@spring.message code="register.company.confirm.rights" />
                            </label>
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-building me-2"></i><@spring.message code="register.company.button" />
                        </button>
                    </div>
                </form>
            </div>

            <div class="text-center mt-4">
                <p class="text-muted">
                    <@spring.message code="register.company.login.question" />
                    <a href="/auth/login"
                       style="color: var(--primary-blue);"><@spring.message code="register.company.login.link" /></a>
                </p>
                <p class="text-muted">
                    <a href="/auth/register" style="color: var(--primary-blue);">
                        <i class="fas fa-arrow-left me-1"></i><@spring.message code="register.company.back.choice" />
                    </a>
                </p>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const input = document.querySelector("#phone");
            const errorBlock = document.querySelector("#phone").nextElementSibling.nextElementSibling;

            const iti = window.intlTelInput(input, {
                preferredCountries: ["kg", "ru", "kz", "uz"],
                initialCountry: "kg",
                geoIpLookup: function (callback) {
                    fetch('https://ipinfo.io/json?token=ваш_токен')
                        .then(resp => resp.json())
                        .then(resp => callback(resp.country || "kg"))
                        .catch(() => callback("kg"));
                },
                formatOnDisplay: true,
                utilsScript: "https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/utils.js"
            });

            input.addEventListener("input", () => {
                if (iti.isValidNumber()) {
                    input.style.borderColor = "green";
                    errorBlock.textContent = "";
                } else {
                    input.style.borderColor = "red";
                    errorBlock.textContent = "<@spring.message code='register.company.phone.invalid' />";
                }
            });

            document.getElementById("companyForm").addEventListener("submit", function (e) {
                const number = iti.getNumber();
                input.value = number;
            });
        });
    </script>
</@page>
