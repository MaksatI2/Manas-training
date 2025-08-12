<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>

<#assign bcHome = springMacroRequestContext.getMessage("student.applications.detail.breadcrumb.home", [], "Главная")>
<#assign bcMyApps = springMacroRequestContext.getMessage("student.applications.detail.breadcrumb.myApplications", [], "Мои заявки")>
<#assign bcDetail = springMacroRequestContext.getMessage("student.applications.detail.detail", [], "Заявка №") + " " + application.id>

<@layout.page title='${springMacroRequestContext.getMessage("student.applications.detail.title", [], "Детали заявки")?no_esc}'>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMyApps, "url": "/applications/student/applications"},
    {"label": bcDetail, "url": ""}
    ] />

    <style>
        :root {
            --primary-blue: #0066cc;
            --dark-blue: #003d7a;
        }

        .card-custom {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 102, 204, 0.08);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            padding: 1rem 1.25rem;
            color: #fff;
            font-size: 1.1rem;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-body-custom {
            padding: 1.5rem;
        }

        .badge {
            font-size: .75rem;
            font-weight: 600;
            border-radius: .375rem;
            padding: .35em .65em;
            display: inline-block;
            min-width: 80px;
            text-align: center;
        }

        .bg-warning {
            background-color: #ffc107 !important;
            color: #212529 !important;
        }

        .bg-success {
            background-color: #28a745 !important;
        }

        .bg-danger {
            background-color: #dc3545 !important;
        }

        .bg-secondary {
            background-color: #6c757d !important;
        }

        .me-1 {
            margin-right: .25rem;
        }

        .me-2 {
            margin-right: .5rem;
        }

        .btn-light:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 102, 204, .2);
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--dark-blue);
        }

        .employee-list {
            padding-left: .25rem;
        }

        .employee-item {
            padding: .4rem 0;
            border-bottom: 1px dashed #ddd;
            font-size: .95rem;
            color: #333;
            display: flex;
            align-items: center;
        }

        .employee-item:last-child {
            border-bottom: none;
        }

        .employee-item i {
            color: #6c757d;
            margin-right: .5rem;
        }

        .field-container {
            display: flex;
            flex-direction: column;
            max-width: 100%;
        }

        .field-container strong {
            white-space: nowrap;
        }

        .field-value {
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
            max-width: 100%;
        }

        .field-container-status {
            display: inline-flex;
            flex-direction: column;
            align-items: flex-start;
            width: auto;
        }
    </style>

    <div class="card-custom">
        <div class="card-header-custom">
            <h5 class="m-0">
                <i class="fas fa-file-alt me-2"></i>
                ${springMacroRequestContext.getMessage("student.applications.detail.header", [], "Заявка №")} ${application.id}
            </h5>
            <a href="/applications/student/applications" class="btn btn-light btn-sm"
               style="border-radius:25px; background:#fff; color:var(--primary-blue); border:1px solid var(--primary-blue);">
                <i class="fas fa-arrow-left me-1" style="color:var(--primary-blue);"></i>
                ${springMacroRequestContext.getMessage("student.applications.detail.back", [], "Назад")}
            </a>
        </div>

        <div class="card-body-custom">
            <div class="row">
                <div class="col-md-6 mb-3 field-container">
                    <strong>${springMacroRequestContext.getMessage("student.applications.detail.course", [], "Курс")}
                        :</strong>
                    <span class="field-value">${application.courseTitle!"—"}</span>
                </div>

                <div class="col-md-6 mb-3 field-container-status">
                    <strong>${springMacroRequestContext.getMessage("student.applications.detail.status", [], "Статус")}
                        :</strong>
                    <span class="badge
                        <#if application.status == "PENDING">bg-warning
                        <#elseif application.status == "APPROVED">bg-success
                        <#elseif application.status == "REJECTED">bg-danger
                        <#else>bg-secondary</#if>">
                        <#if application.status == "PENDING">
                            ${springMacroRequestContext.getMessage("status.pending", [], "В ожидании")}
                        <#elseif application.status == "APPROVED">
                            ${springMacroRequestContext.getMessage("status.approved", [], "Одобрено")}
                        <#elseif application.status == "REJECTED">
                            ${springMacroRequestContext.getMessage("status.rejected", [], "Отклонено")}
                        <#else>
                            ${springMacroRequestContext.getMessage("status.unknown", [], "Неизвестно")}
                        </#if>
                    </span>
                </div>

                <div class="col-md-6 mb-3 field-container">
                    <strong>${springMacroRequestContext.getMessage("student.applications.detail.dateSubmitted", [], "Дата подачи")}
                        :</strong>
                    <span class="field-value">${application.formattedSubmittedAt!"—"}</span>
                </div>

                <#if application.preferredTeacher??>
                    <div class="col-md-6 mb-3 field-container">
                        <strong>${springMacroRequestContext.getMessage("student.applications.detail.preferredTeacher", [], "Предпочтительный преподаватель")}
                            :</strong>
                        <span class="field-value">${application.preferredTeacher.name} ${application.preferredTeacher.lastName}</span>
                    </div>
                </#if>

                <#if application.formattedPreferredStartDate??>
                    <div class="col-md-6 mb-3 field-container">
                        <strong>${springMacroRequestContext.getMessage("student.applications.detail.preferredStartDate", [], "Желаемая дата начала")}
                            :</strong>
                        <span class="field-value">${application.formattedPreferredStartDate}</span>
                    </div>
                </#if>

                <#if application.formattedPreferredEndDate??>
                    <div class="col-md-6 mb-3 field-container">
                        <strong>${springMacroRequestContext.getMessage("student.applications.detail.preferredEndDate", [], "Желаемая дата окончания")}
                            :</strong>
                        <span class="field-value">${application.formattedPreferredEndDate}</span>
                    </div>
                </#if>

                <#if application.employees?? && application.employees?size == 1>
                    <div class="col-md-6 mb-3 field-container">
                        <strong>${springMacroRequestContext.getMessage("student.applications.detail.student", [], "Студент")}
                            :</strong>
                        <div class="employee-item">
                            <i class="fas fa-user"></i>
                            <span class="field-value">${application.employees[0].fullName} &lt;${application.employees[0].email}&gt;</span>
                        </div>
                    </div>
                </#if>
            </div>
        </div>
    </div>

    <div class="card-custom">
        <div class="card-header-custom" style="background:#f8f9fa; color:#333; font-weight:600;">
            <i class="fas fa-comments me-2 text-secondary"></i>
            ${springMacroRequestContext.getMessage("student.applications.detail.comments", [], "Комментарии")}
        </div>
        <div class="card-body-custom">
            <#if comments?size == 0>
                <p class="text-muted">${springMacroRequestContext.getMessage("student.applications.detail.noComments", [], "Комментариев пока нет.")}</p>
            <#else>
                <ul class="list-group list-group-flush mb-0">
                    <#list comments as c>
                        <li class="list-group-item">
                            <div class="fw-bold">${c.authorName}</div>
                            <div class="field-value">${c.comment}</div>
                            <div class="text-muted small">${c.formattedCreatedAt!"—"}</div>
                        </li>
                    </#list>
                </ul>
            </#if>
        </div>
    </div>

    <script>
        const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
        fetch('/api/notifications/mark-all-as-read?targetType=COURSE_APPLICATION', {
            method: 'POST',
            headers: {[csrfHeader]: csrfToken}
        }).then(() => {
            updateNotificationCount();
        });
    </script>
</@layout.page>
