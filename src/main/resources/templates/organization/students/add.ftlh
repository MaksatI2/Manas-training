<#import "/layout.ftlh" as layout>
<#import "/RoadMap.ftlh" as roadmap>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/css/intlTelInput.min.css"/>
<script src="https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/intlTelInput.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/intl-tel-input@17/build/js/utils.js"></script>

<@layout.page>
    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>
    <@roadmap.breadcrumbs items=[
    {"label": springMacroRequestContext.getMessage("organization.student.add.breadcrumb.home"), "url": "/"},
    {"label": springMacroRequestContext.getMessage("organization.student.add.breadcrumb.students"), "url": "/organization/students"},
    {"label": springMacroRequestContext.getMessage("organization.student.add.breadcrumb.add"), "url": ""}
    ] />

    <style>
        :root {
            --primary-blue: #0066cc;
            --light-blue: #87ceeb;
            --white: #ffffff;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
        }

        .page-title {
            text-align: center;
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin: 2rem 0 1.5rem;
        }

        .form-wrapper {
            max-width: 550px;
            margin: 0 auto;
            background: #fff;
            padding: 2rem;
            border-left: 4px solid var(--primary-blue);
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
        }

        .btn-gradient {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: #fff;
            border: none;
            transition: all 0.3s ease;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            font-weight: 500;
        }

        .btn-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
            color: #fff;
        }

        .alert-compact {
            max-width: 550px;
            margin: 1rem auto -1rem;
            font-size: 0.9rem;
            padding: 0.75rem 1rem;
            border-radius: 8px;
        }

        .form-label {
            font-weight: 500;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 0.2rem rgba(0, 102, 204, 0.25);
        }

        .error-message {
            font-size: 0.85rem;
            color: #dc3545;
            margin-top: 0.25rem;
            display: block;
        }

        .phone-error {
            border-color: #dc3545 !important;
        }

        .phone-success {
            border-color: #28a745 !important;
        }

        .iti {
            width: 100%;
        }

        .iti__country-list {
            z-index: 9999;
        }

        .iti__selected-flag {
            padding: 0.75rem 0.5rem;
        }

        .iti__flag-box {
            margin-right: 0.5rem;
        }

        .row {
            margin-bottom: 1rem;
        }

        .col-md-6 {
            padding-right: 0.75rem;
            padding-left: 0.75rem;
        }

        .col-md-6:first-child {
            padding-left: 0;
        }

        .col-md-6:last-child {
            padding-right: 0;
        }

        .button-group {
            display: flex;
            gap: 1rem;
            justify-content: space-between;
            margin-top: 1.5rem;
        }

        .btn-outline-primary {
            border: 2px solid var(--primary-blue);
            color: var(--primary-blue);
            background: transparent;
            transition: all 0.3s ease;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            font-weight: 500;
        }

        .btn-outline-primary:hover {
            background: var(--primary-blue);
            color: white;
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .col-md-6 {
                padding-right: 0;
                padding-left: 0;
                margin-bottom: 1rem;
            }

            .button-group {
                flex-direction: column;
                gap: 0.5rem;
            }
        }
    </style>

    <h1 class="page-title">
        <i class="fas fa-user-graduate me-3"></i>
        ${springMacroRequestContext.getMessage("organization.student.add.title")}
    </h1>

    <div class="form-wrapper">
        <#if errorMessage??>
            <div class="alert alert-danger alert-compact text-center shadow-sm">${errorMessage}</div>
        </#if>

        <#if successMessage??>
            <div class="alert alert-success alert-compact text-center shadow-sm">${successMessage}</div>
        </#if>

        <form method="post" action="/organization/students/add" id="studentForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="row">
                <div class="col-md-6">
                    <label for="name" class="form-label">
                        <i class="fas fa-user me-1"></i>${springMacroRequestContext.getMessage("organization.student.add.form.name")}
                    </label>
                    <input type="text" class="form-control" id="name" name="name"
                           value="${studentDto.name!}"
                           placeholder="${springMacroRequestContext.getMessage('organization.student.add.form.name.placeholder')}">
                    <div class="error-message"><#if validationErrors??>${validationErrors["name"]!}</#if></div>
                </div>

                <div class="col-md-6">
                    <label for="lastName" class="form-label">
                        <i class="fas fa-user me-1"></i>${springMacroRequestContext.getMessage("organization.student.add.form.lastname")}
                    </label>
                    <input type="text" class="form-control" id="lastName" name="lastName"
                           value="${studentDto.lastName!}"
                           placeholder="${springMacroRequestContext.getMessage('organization.student.add.form.lastname.placeholder')}">
                    <div class="error-message"><#if validationErrors??>${validationErrors["lastName"]!}</#if></div>
                </div>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">
                    <i class="fas fa-envelope me-1"></i>${springMacroRequestContext.getMessage("organization.student.add.form.email")}
                </label>
                <input type="email" class="form-control" id="email" name="email"
                       value="${studentDto.email!}"
                       placeholder="${springMacroRequestContext.getMessage('organization.student.add.form.email.placeholder')}">
                <div class="error-message"><#if validationErrors??>${validationErrors["email"]!}</#if></div>
            </div>

            <div class="mb-4">
                <label for="phone" class="form-label">
                    <i class="fas fa-phone me-1"></i>${springMacroRequestContext.getMessage("organization.student.add.form.phone")}
                </label>
                <input type="tel" class="form-control" id="phone" name="phone"
                       value="${studentDto.phone!}"
                       placeholder="${springMacroRequestContext.getMessage('organization.student.add.form.phone.placeholder')}"
                       autocomplete="off">
                <div class="error-message" id="phone-error">
                    <#if validationErrors??>${validationErrors["phone"]!}</#if>
                </div>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-gradient rounded-pill">
                    <i class="fas fa-user-plus me-2"></i>${springMacroRequestContext.getMessage("organization.student.add.button.save")}
                </button>
                <a href="/organization/students" class="btn btn-outline-primary rounded-pill">
                    <i class="fas fa-arrow-left me-1"></i>${springMacroRequestContext.getMessage("organization.student.add.button.cancel")}
                </a>
            </div>
        </form>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const input = document.querySelector("#phone");
            const errorBlock = document.querySelector("#phone-error");

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

            input.addEventListener("input", function () {
                const phoneNumber = input.value.trim();
                if (phoneNumber) {
                    if (iti.isValidNumber()) {
                        input.classList.remove("phone-error");
                        input.classList.add("phone-success");
                        errorBlock.textContent = "";
                    } else {
                        input.classList.remove("phone-success");
                        input.classList.add("phone-error");
                        errorBlock.textContent = "${springMacroRequestContext.getMessage('organization.student.add.phone.invalid')}";
                    }
                } else {
                    input.classList.remove("phone-error", "phone-success");
                    errorBlock.textContent = "";
                }
            });

            input.addEventListener("blur", function () {
                const phoneNumber = input.value.trim();
                if (phoneNumber && !iti.isValidNumber()) {
                    input.classList.remove("phone-success");
                    input.classList.add("phone-error");
                    errorBlock.textContent = "${springMacroRequestContext.getMessage('organization.student.add.phone.invalid')}";
                }
            });

            document.getElementById("studentForm").addEventListener("submit", function (e) {
                const phoneNumber = input.value.trim();
                if (phoneNumber && !iti.isValidNumber()) {
                    e.preventDefault();
                    input.classList.add("phone-error");
                    errorBlock.textContent = "${springMacroRequestContext.getMessage('organization.student.add.phone.invalid.full')}";
                    input.focus();
                    return false;
                }
                if (phoneNumber && iti.isValidNumber()) {
                    const formattedNumber = iti.getNumber();
                    input.value = formattedNumber;
                }
            });

            input.addEventListener("focus", function () {
                if (input.classList.contains("phone-error")) {
                    errorBlock.textContent = "";
                }
            });
        });
    </script>
</@layout.page>
