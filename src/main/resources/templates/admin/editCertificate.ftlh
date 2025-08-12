<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>

<#assign pageTitle = springMacroRequestContext.getMessage("certificate.edit.pageTitle")>
<#assign bcHome = springMacroRequestContext.getMessage("certificate.edit.breadcrumb.home")>
<#assign bcList = springMacroRequestContext.getMessage("certificate.edit.breadcrumb.list")>
<#assign bcEdit = springMacroRequestContext.getMessage("certificate.edit.breadcrumb.edit")>
<#assign headerTitle = springMacroRequestContext.getMessage("certificate.edit.headerTitle", [certificateForm.id])>
<#assign backText = springMacroRequestContext.getMessage("certificate.edit.back")>
<#assign labelNumber = springMacroRequestContext.getMessage("certificate.edit.form.certificateNumber")>
<#assign labelIssue = springMacroRequestContext.getMessage("certificate.edit.form.issueDate")>
<#assign labelExpiry = springMacroRequestContext.getMessage("certificate.edit.form.expiryDate")>
<#assign labelMark = springMacroRequestContext.getMessage("certificate.edit.form.mark")>
<#assign cancelText = springMacroRequestContext.getMessage("certificate.edit.cancel")>
<#assign saveText = springMacroRequestContext.getMessage("certificate.edit.save")>

<@layout.page title=pageTitle>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcList, "url": "/admin/certificate"},
    {"label": bcEdit, "url": ""}
    ]/>

    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center"
             style="background:linear-gradient(135deg,#0066cc,#003d7a); color:#fff;">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-edit me-2"></i>
                ${headerTitle}
            </h5>
            <a href="/admin/certificate/detail?studentId=${certificateForm.studentId}"
               class="btn btn-light btn-sm"
               style="border-radius:25px; background:white; color:#0066cc; border:1px solid #0066cc;">
                <i class="fas fa-arrow-left me-1" style="color:#0066cc;"></i> ${backText}
            </a>
        </div>

        <div class="card-body">
            <form action="/admin/certificate/edit" method="post" novalidate>
                <#if _csrf??>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </#if>
                <input type="hidden" name="id" value="${certificateForm.id}"/>
                <input type="hidden" name="studentId" value="${certificateForm.studentId}"/>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="certificateNumber" class="form-label required">${labelNumber}</label>
                        <input type="text"
                               id="certificateNumber"
                               name="certificateNumber"
                               value="${certificateForm.certificateNumber!''}"
                               maxlength="50"
                               class="form-control <#if .globals['org.springframework.validation.BindingResult.certificateForm']?? && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('certificateNumber')>is-invalid</#if>"
                               required>
                        <#if .globals['org.springframework.validation.BindingResult.certificateForm']?? && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('certificateNumber')>
                            <div class="invalid-feedback">
                                <#list .globals['org.springframework.validation.BindingResult.certificateForm'].getFieldErrors('certificateNumber') as err>
                                    ${err.defaultMessage}
                                </#list>
                            </div>
                        </#if>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="issueDate" class="form-label required">${labelIssue}</label>
                        <input type="date"
                               id="issueDate"
                               name="issueDate"
                               value="${certificateForm.issueDate!''}"
                               class="form-control <#if .globals['org.springframework.validation.BindingResult.certificateForm']?? && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('issueDate')>is-invalid</#if>"
                               required/>
                        <#if .globals['org.springframework.validation.BindingResult.certificateForm']?? && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('issueDate')>
                            <div class="invalid-feedback">
                                <#list .globals['org.springframework.validation.BindingResult.certificateForm'].getFieldErrors('issueDate') as err>
                                    ${err.defaultMessage}
                                </#list>
                            </div>
                        </#if>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="expiryDate" class="form-label required">${labelExpiry}</label>
                        <input type="date"
                               id="expiryDate"
                               name="expiryDate"
                               min="${.now?date?string('yyyy-MM-dd')}"
                               value="${certificateForm.expiryDate!''}"
                               class="form-control <#if .globals['org.springframework.validation.BindingResult.certificateForm']?? && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('expiryDate')>is-invalid</#if>"
                               required/>
                        <#if .globals['org.springframework.validation.BindingResult.certificateForm']?? && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('expiryDate')>
                            <div class="invalid-feedback">
                                <#list .globals['org.springframework.validation.BindingResult.certificateForm'].getFieldErrors('expiryDate') as err>
                                    ${err.defaultMessage}
                                </#list>
                            </div>
                        </#if>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="mark" class="form-label required">${labelMark}</label>
                        <input type="number"
                               id="mark"
                               name="mark"
                               value="${certificateForm.mark!''}"
                               min="0" max="100"
                               class="form-control <#if .globals['org.springframework.validation.BindingResult.certificateForm']?? && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('mark')>is-invalid</#if>"
                               required>
                        <#if .globals['org.springframework.validation.BindingResult.certificateForm']?? && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('mark')>
                            <div class="invalid-feedback">
                                <#list .globals['org.springframework.validation.BindingResult.certificateForm'].getFieldErrors('mark') as err>
                                    ${err.defaultMessage}
                                </#list>
                            </div>
                        </#if>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2">
                    <a href="/admin/certificate/detail?studentId=${certificateForm.studentId}"
                       class="btn btn-secondary">
                        <i class="fas fa-times me-1"></i> ${cancelText}
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check me-1"></i> ${saveText}
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

        .is-invalid {
            border-color: #dc3545 !important;
        }

        .invalid-feedback {
            display: block;
        }

        .card {
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
        }
    </style>
</@layout.page>
