<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>

<@layout.page title="Создать сертификат">
    <@roadmap.breadcrumbs items=[
    {"label":"Главная","url":"/"},
    {"label":"Сертификаты","url":"/admin/certificate"},
    {"label":"Создать сертификат","url":""}
    ]/>

    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center"
             style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-file-certificate me-2"></i>Создать сертификат
            </h5>
            <a href="/admin/certificate/detail?studentId=${certificateForm.studentId}"
               class="btn btn-light btn-sm"
               style="border-radius:25px; background:white; color:#0066cc; border:1px solid #0066cc;">
                <i class="fas fa-arrow-left me-1" style="color:#0066cc;"></i> Назад
            </a>
        </div>

        <div class="card-body">
            <form action="/admin/certificate/create" method="post" novalidate>
                <#if _csrf??>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </#if>

                <input type="hidden" name="studentId"        value="${certificateForm.studentId}"/>
                <input type="hidden" name="courseInstanceId" value="${certificateForm.courseInstanceId}"/>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="expiryDate" class="form-label required">Срок действия до</label>
                        <input
                                type="date"
                                id="expiryDate"
                                name="expiryDate"
                                class="form-control<#if .globals['org.springframework.validation.BindingResult.certificateForm']?? &&
                                .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('expiryDate')> is-invalid</#if>"
                                value="${certificateForm.expiryDate!''}"
                                required/>
                        <#if .globals['org.springframework.validation.BindingResult.certificateForm']??
                        && .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('expiryDate')>
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
                        <input
                                type="number"
                                id="mark"
                                name="mark"
                                class="form-control<#if .globals['org.springframework.validation.BindingResult.certificateForm']?? &&
                                .globals['org.springframework.validation.BindingResult.certificateForm'].hasFieldErrors('mark')> is-invalid</#if>"
                                min="0" max="100"
                                value="${certificateForm.mark!''}"
                                required/>
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
                        <i class="fas fa-check me-1"></i> Создать
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function(){
            const expiry = document.getElementById('expiryDate');
            if (!expiry) return;
            const today = new Date().toISOString().split('T')[0];
            expiry.min = today;
        });
    </script>

    <style>
        .required::after { content: " *"; color: #dc3545; }
        .card { border-radius:10px; box-shadow:0 4px 15px rgba(0,102,204,0.1); }
        .form-control:focus { border-color:#0066cc; box-shadow:0 0 0 .2rem rgba(0,102,204,0.25); }
        .invalid-feedback { display:block; }
        .btn { border-radius:8px; padding:.5rem 1rem; transition:.3s; }
        .btn-primary { background:linear-gradient(135deg,#0066cc,#003d7a); border-color:#0066cc; }
        .btn-primary:hover { background:linear-gradient(135deg,#003d7a,#002a5a); box-shadow:0 4px 15px rgba(0,102,204,0.3); }
        .btn-secondary { background:#6c757d; border-color:#6c757d; color:#fff; }
        .btn-secondary:hover { background:#545b62; }
    </style>
</@layout.page>
