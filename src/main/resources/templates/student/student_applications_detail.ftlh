<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>

<#assign dateFormat = "dd.MM.yyyy">
<#assign dateTimeFormat = "dd.MM.yyyy HH:mm">

<@layout.page title="Детали заявки">
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои заявки", "url": "/applications/student/applications"},
    {"label": "Заявка №${application.id}", "url": ""}
    ] />

    <style>
        :root {
            --primary-blue: #0066cc;
            --dark-blue: #003d7a;
        }

        .card-custom {
            background: white;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 102, 204, 0.08);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            padding: 1rem 1.25rem;
            color: white;
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
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: 0.375rem;
            padding: 0.35em 0.65em;
        }

        .bg-warning { background-color: #ffc107 !important; color: #212529 !important; }
        .bg-success { background-color: #28a745 !important; }
        .bg-danger { background-color: #dc3545 !important; }
        .bg-secondary { background-color: #6c757d !important; }

        .me-1 { margin-right: 0.25rem; }
        .me-2 { margin-right: 0.5rem; }

        .btn-light:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 102, 204, 0.2);
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--dark-blue);
        }

        .employee-list {
            padding-left: 0.25rem;
        }

        .employee-item {
            padding: 0.4rem 0;
            border-bottom: 1px dashed #ddd;
            font-size: 0.95rem;
            color: #333;
            display: flex;
            align-items: center;
        }

        .employee-item:last-child {
            border-bottom: none;
        }

        .employee-item i {
            color: #6c757d;
            margin-right: 0.5rem;
        }
    </style>

    <div class="card-custom">
        <div class="card-header-custom">
            <h5 class="m-0">
                <i class="fas fa-file-alt me-2"></i> Заявка №${application.id}
            </h5>
            <a href="/applications/student/applications" class="btn btn-light btn-sm"
               style="border-radius: 25px; background: white; color: var(--primary-blue); border: 1px solid var(--primary-blue);">
                <i class="fas fa-arrow-left me-1" style="color: var(--primary-blue);"></i> Назад
            </a>
        </div>

        <div class="card-body-custom">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <strong>Курс:</strong><br>
                    ${application.courseTitle!"—"}
                </div>
                <div class="col-md-6 mb-3">
                    <strong>Статус:</strong><br>
                    <span class="badge
                        <#if application.status == "PENDING">bg-warning
                        <#elseif application.status == "APPROVED">bg-success
                        <#elseif application.status == "REJECTED">bg-danger
                        <#else>bg-secondary</#if>">
                        ${application.localizedStatus!"—"}
                    </span>
                </div>
                <div class="col-md-6 mb-3">
                    <strong>Дата подачи:</strong><br>
                    ${application.formattedSubmittedAt!"—"}
                </div>

                <#if application.preferredTeacher??>
                    <div class="col-md-6 mb-3">
                        <strong>Предпочтительный преподаватель:</strong><br>
                        ${application.preferredTeacher.name} ${application.preferredTeacher.lastName}
                    </div>
                </#if>

                <#if application.formattedPreferredStartDate??>
                    <div class="col-md-6 mb-3">
                        <strong>Желаемая дата начала:</strong><br>
                        ${application.formattedPreferredStartDate}
                    </div>
                </#if>

                <#if application.formattedPreferredEndDate??>
                    <div class="col-md-6 mb-3">
                        <strong>Желаемая дата окончания:</strong><br>
                        ${application.formattedPreferredEndDate}
                    </div>
                </#if>

                <#if application.employees?? && application.employees?size == 1>
                    <div class="col-md-6 mb-3">
                        <strong>Студент:</strong><br>
                        <div class="employee-item">
                            <i class="fas fa-user"></i>
                            <span>${application.employees[0].fullName} &lt;${application.employees[0].email}&gt;</span>
                        </div>
                    </div>
                </#if>
            </div>
        </div>
    </div>

    <div class="card-custom">
        <div class="card-header-custom" style="background: #f8f9fa; color: #333; font-weight: 600;">
            <i class="fas fa-comments me-2 text-secondary"></i>Комментарии
        </div>
        <div class="card-body-custom">
            <#if comments?size == 0>
                <p class="text-muted">Комментариев пока нет.</p>
            <#else>
                <ul class="list-group list-group-flush mb-0">
                    <#list comments as c>
                        <li class="list-group-item">
                            <div class="fw-bold">${c.authorName}</div>
                            <div>${c.comment}</div>
                            <div class="text-muted small">${c.formattedCreatedAt!"—"}</div>
                        </li>
                    </#list>
                </ul>
            </#if>
        </div>
    </div>
</@layout.page>
