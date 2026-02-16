<#import "../../layout.ftlh" as layout>
<#import "../../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>

<#assign bcHome><@spring.message code='organization.student.edit.breadcrumb.home'/></#assign>
<#assign bcStudents><@spring.message code='organization.student.edit.breadcrumb.students'/></#assign>
<#assign bcEdit><@spring.message code='organization.student.edit.breadcrumb.edit'/></#assign>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcStudents, "url": "/organization/students"},
    {"label": bcEdit, "url": ""}
    ] />
    <style>
        :root {
            --primary-blue: #0066cc;
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
        }

        .btn-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }

        .form-label {
            font-weight: 500;
        }
    </style>

    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

    <h1 class="page-title"><@spring.message code="organization.student.edit.title"/></h1>

    <form method="post" action="/organization/students/${student.studentId}/edit" class="form-wrapper mt-4">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <@spring.bind "student.name"/>
        <div class="mb-3">
            <label for="name" class="form-label"><@spring.message code="organization.student.edit.form.name"/></label>
            <input type="text" class="form-control <#if spring.status.error>is-invalid</#if>"
                   id="name" name="name" value="${student.name!}"
                   placeholder="<@spring.message code='organization.student.edit.form.name.placeholder'/>">
            <#if spring.status.error>
                <div class="invalid-feedback">
                    <@spring.showErrors "<br>"/>
                </div>
            </#if>
        </div>

        <@spring.bind "student.lastName"/>
        <div class="mb-3">
            <label for="lastName"
                   class="form-label"><@spring.message code="organization.student.edit.form.lastname"/></label>
            <input type="text" class="form-control <#if spring.status.error>is-invalid</#if>"
                   id="lastName" name="lastName" value="${student.lastName!}"
                   placeholder="<@spring.message code='organization.student.edit.form.lastname.placeholder'/>">
            <#if spring.status.error>
                <div class="invalid-feedback">
                    <@spring.showErrors "<br>"/>
                </div>
            </#if>
        </div>

        <@spring.bind "student.email"/>
        <div class="mb-3">
            <label for="email" class="form-label"><@spring.message code="organization.student.edit.form.email"/></label>
            <input type="email" class="form-control <#if spring.status.error>is-invalid</#if>"
                   id="email" name="email" value="${student.email!}"
                   placeholder="<@spring.message code='organization.student.edit.form.email.placeholder'/>">
            <#if spring.status.error>
                <div class="invalid-feedback">
                    <@spring.showErrors "<br>"/>
                </div>
            </#if>
        </div>

        <@spring.bind "student.phone"/>
        <div class="mb-4">
            <label for="phone" class="form-label"><@spring.message code="organization.student.edit.form.phone"/></label>
            <input type="text" class="form-control <#if spring.status.error>is-invalid</#if>"
                   id="phone" name="phone" value="${student.phone!}"
                   placeholder="<@spring.message code='organization.student.edit.form.phone.placeholder'/>">
            <#if spring.status.error>
                <div class="invalid-feedback">
                    <@spring.showErrors "<br>"/>
                </div>
            </#if>
        </div>

        <div class="d-flex justify-content-between">
            <button type="submit" class="btn btn-gradient px-4 rounded-pill">
                <i class="fas fa-save me-2"></i><@spring.message code="organization.student.edit.button.save"/>
            </button>
            <a href="/organization/students"
               class="btn btn-outline-primary px-4 rounded-pill"><@spring.message code="organization.student.edit.button.cancel"/></a>
        </div>
    </form>
</@layout.page>
