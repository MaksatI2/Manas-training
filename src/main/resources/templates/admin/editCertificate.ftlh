<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>

<@layout.page title="Редактировать сертификат">
    <@roadmap.breadcrumbs items=[
    {"label":"Главная","url":"/"},
    {"label":"Сертификаты","url":"/admin/certificate"},
    {"label":"Редактировать","url":""}
    ]/>

    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center"
             style="background:linear-gradient(135deg,#0066cc,#003d7a); color:#fff;">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-edit me-2"></i>
                Редактировать №${certificateForm.id}
            </h5>
            <a href="/admin/certificate/detail?studentId=${certificateForm.studentId}"
               class="btn btn-light btn-sm"
               style="border-radius:25px; background:white; color:#0066cc; border:1px solid #0066cc;">
                <i class="fas fa-arrow-left me-1" style="color:#0066cc;"></i> Назад
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
                        <label for="certificateNumber" class="form-label required">Номер</label>
                        <input type="text"
                               id="certificateNumber"
                               name="certificateNumber"
                               value="${certificateForm.certificateNumber!''}"
                               maxlength="50"
                               class="form-control <#if .globals['org.springframework.validation.BindingResult.certificateForm']??
                               && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('certificateNumber')>
                                     is-invalid
                                  </#if>"
                               required>
                        <#if .globals['org.springframework.validation.BindingResult.certificateForm']??
                        && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('certificateNumber')>
                            <div class="invalid-feedback">
                                <#list .globals['org.springframework.validation.BindingResult.certificateForm']
                                .getFieldErrors('certificateNumber') as err>
                                    ${err.defaultMessage}
                                </#list>
                            </div>
                        </#if>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="issueDate" class="form-label required">Дата выдачи</label>
                        <input type="date"
                               id="issueDate"
                               name="issueDate"
                               value="${certificateForm.issueDate!''}"
                               class="form-control
         <#if .globals['org.springframework.validation.BindingResult.certificateForm']??
                               && .globals['org.springframework.validation.BindingResult.certificateForm']
                               .hasFieldErrors('issueDate')>
           is-invalid
         </#if>"
                               required/>

                        <#if .globals['org.springframework.validation.BindingResult.certificateForm']??
                        && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('issueDate')>
                            <div class="invalid-feedback">
                                <#list .globals['org.springframework.validation.BindingResult.certificateForm']
                                .getFieldErrors('issueDate') as err>
                                    ${err.defaultMessage}
                                </#list>
                            </div>
                        </#if>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="expiryDate" class="form-label required">Срок действия до</label>
                        <input type="date"
                               id="expiryDate"
                               name="expiryDate"
                               min="${.now?date?string('yyyy-MM-dd')}"
                               value="${certificateForm.expiryDate!''}"
                               class="form-control
         <#if .globals['org.springframework.validation.BindingResult.certificateForm']??
                               && .globals['org.springframework.validation.BindingResult.certificateForm']
                               .hasFieldErrors('expiryDate')>
           is-invalid
         </#if>"
                               required/>
                        <#if .globals['org.springframework.validation.BindingResult.certificateForm']??
                        && .globals['org.springframework.validation.BindingResult.certificateForm']
                        .hasFieldErrors('expiryDate')>
                            <div class="invalid-feedback">
                                <#list .globals['org.springframework.validation.BindingResult.certificateForm']
                                .getFieldErrors('expiryDate') as err>
                                    ${err.defaultMessage}
                                </#list>
                            </div>
                        </#if>


                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="mark" class="form-label required">Оценка</label>
                        <input type="number"
                               id="mark"
                               name="mark"
                               value="${certificateForm.mark!''}"
                               min="0" max="100"
                               class="form-control <#if .globals['org.springframework.validation.BindingResult.certificateForm']??
                               && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('mark')>
                                     is-invalid
                                  </#if>"
                               required>
                        <#if .globals['org.springframework.validation.BindingResult.certificateForm']??
                        && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('mark')>
                            <div class="invalid-feedback">
                                <#list .globals['org.springframework.validation.BindingResult.certificateForm']
                                .getFieldErrors('mark') as err>
                                    ${err.defaultMessage}
                                </#list>
                            </div>
                        </#if>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2">
                    <a href="/admin/certificate/detail?studentId=${certificateForm.studentId}"
                       class="btn btn-secondary">
                        <i class="fas fa-times me-1"></i> Отмена
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check me-1"></i> Сохранить
                    </button>
                </div>
            </form>
        </div>
    </div>

    <style>
        .required::after { content:" *"; color:#dc3545; }
        .is-invalid { border-color: #dc3545 !important; }
        .invalid-feedback { display:block; }
        .card { border-radius:10px; box-shadow:0 4px 15px rgba(0,102,204,0.1); }
        .btn-primary { background: linear-gradient(135deg,#0066cc,#003d7a); }
    </style>
</@layout.page>
