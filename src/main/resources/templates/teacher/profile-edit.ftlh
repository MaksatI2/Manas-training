<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>

<style>
    .error-block {
        margin-top: 5px;
        color: red;
        font-size: 13px;
    }
</style>

<@page>
    <@roadmap.breadcrumbs items=[
    {"label": springMacroRequestContext.getMessage("teacher.profileEdit.breadcrumb.home"), "url": "/"},
    {"label": springMacroRequestContext.getMessage("teacher.profileEdit.breadcrumb.list"), "url": "/teacher"},
    {"label": springMacroRequestContext.getMessage("teacher.profileEdit.breadcrumb.edit"), "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title">
            <i class="fas fa-user-edit me-3"></i>
            <@spring.message code='teacher.profileEdit.title'/>
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
                                <i class="fas fa-user me-1"></i><@spring.message code='teacher.profileEdit.form.firstName'/>
                            </label>
                            <@spring.formInput
                            path="teacherEditDto.name"
                            attributes=' class="form-control" id="firstName"'
                            />
                            <div class="error-block">
                                <@spring.showErrors "<br>" "error-message" />
                            </div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="lastName" class="form-label">
                                <i class="fas fa-user me-1"></i><@spring.message code='teacher.profileEdit.form.lastName'/>
                            </label>
                            <@spring.formInput
                            path="teacherEditDto.surname"
                            attributes=' class="form-control" id="lastName"'
                            />
                            <div class="error-block">
                                <@spring.showErrors "<br>" "error-message" />
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label">
                            <i class="fas fa-phone me-1"></i><@spring.message code='teacher.profileEdit.form.phone'/>
                        </label>
                        <@spring.formInput
                        path="teacherEditDto.phone"
                        attributes=' type="tel" class="form-control" id="phone" placeholder="${springMacroRequestContext.getMessage("teacher.profileEdit.form.phone.placeholder")}"'
                        />
                        <div class="form-text"><@spring.message code='teacher.profileEdit.form.phone.help'/></div>
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="department" class="form-label">
                            <i class="fas fa-building me-1"></i><@spring.message code='teacher.profileEdit.form.department'/>
                        </label>
                        <@spring.formInput
                        path="teacherEditDto.department"
                        attributes=' class="form-control" id="department"'
                        />
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="qualifications" class="form-label">
                            <i class="fas fa-certificate me-1"></i><@spring.message code='teacher.profileEdit.form.qualifications'/>
                        </label>
                        <@spring.formInput
                        path="teacherEditDto.qualifications"
                        attributes=' class="form-control" id="qualifications"'
                        />
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="bio" class="form-label">
                            <i class="fas fa-info-circle me-1"></i><@spring.message code='teacher.profileEdit.form.bio'/>
                        </label>
                        <@spring.formTextarea
                        path="teacherEditDto.bio"
                        attributes=' class="form-control" id="bio" rows="4" placeholder="${springMacroRequestContext.getMessage("teacher.profileEdit.form.bio.placeholder")}"'
                        />
                        <div class="error-block">
                            <@spring.showErrors "<br>" "error-message" />
                        </div>
                    </div>

                    <input type="hidden" name="userId" value="${teacherEditDto.userId}">

                    <div class="text-center mt-4">
                        <button type="submit" class="btn btn-primary-custom" style="padding: 0.3rem 0.9rem !important;">
                            <i class="fas fa-save me-2"></i><@spring.message code='teacher.profileEdit.button.save'/>
                        </button>
                    </div>
                </form>
            </div>

            <div class="text-center mt-4">
                <p class="text-muted">
                    <a href="/teacher/profile" style="color: var(--primary-blue);">
                        <i class="fas fa-arrow-left me-1"></i><@spring.message code='teacher.profileEdit.link.back'/>
                    </a>
                </p>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('phone').addEventListener('input', function (e) {
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

        document.getElementById('phone').addEventListener('focus', function (e) {
            if (e.target.value === '') {
                e.target.value = '+996';
            }
        });
    </script>
</@page>
