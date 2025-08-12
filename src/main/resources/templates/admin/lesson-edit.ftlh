<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring />
<#import "../RoadMap.ftlh" as roadmap>

<#assign bcHome = springMacroRequestContext.getMessage("lesson.edit.breadcrumb.home")>
<#assign bcInstances = springMacroRequestContext.getMessage("lesson.edit.breadcrumb.courseInstances")>
<#assign bcEditLesson = springMacroRequestContext.getMessage("lesson.edit.breadcrumb.editLesson")>
<#assign pageTitle = springMacroRequestContext.getMessage("lesson.edit.pageTitle")>
<#assign labelTitle = springMacroRequestContext.getMessage("lesson.edit.form.title")>
<#assign labelDescription = springMacroRequestContext.getMessage("lesson.edit.form.description")>
<#assign saveText = springMacroRequestContext.getMessage("lesson.edit.save")>
<#assign cancelText = springMacroRequestContext.getMessage("lesson.edit.cancel")>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcInstances, "url": "/admin/course-instances"},
    {"label": bcEditLesson, "url": ""}
    ] />
    <div class="container">
        <h2 class="section-title">${pageTitle}</h2>

        <div class="card feature-card-enhanced">
            <div class="card-body">
                <form action="/admin/lessons/${lessonId}/edit" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="mb-3">
                        <label for="title" class="form-label">
                            <i class="fas fa-heading me-1"></i>${labelTitle}
                        </label>
                        <@spring.formInput "lessonEditDto.title", "class='form-control' id='title'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "title", "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">
                            <i class="fas fa-align-left me-1"></i>${labelDescription}
                        </label>
                        <@spring.formTextarea "lessonEditDto.description", "class='form-control' id='description' rows='3'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "description", "error-message" />
                        </div>
                    </div>

                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save me-2"></i>${saveText}
                    </button>
                    <a href="/lessons/${lessonId}" class="btn btn-secondary ms-2">
                        ${cancelText}
                    </a>
                </form>
            </div>
        </div>
    </div>
</@layout.page>
