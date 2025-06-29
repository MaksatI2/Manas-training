<#import "../layout.ftlh" as layout>
<#assign dateFormat = "dd.MM.yyyy">
<#assign dateTimeFormat = "dd.MM.yyyy HH:mm">
<@layout.page title="Детали заявки">
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center"
             style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-file-alt me-2"></i>
                Заявка №${application.id}
            </h5>
            <a href="/applications/organization" class="btn btn-light btn-sm"
               style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                <i class="fas fa-arrow-left me-1" style="color: #0066cc;"></i> Назад
            </a>
        </div>

        <div class="card-body">
            <div class="mb-3">
                <strong>Курс:</strong> ${application.courseTitle!"—"}
            </div>
            <div class="mb-3">
                <strong>Код компании:</strong> ${application.outgoingCode!"—"}
            </div>
            <div class="mb-3">
                <strong>Статус:</strong>
                <span class="badge
                    <#if application.status == "PENDING">bg-warning
                    <#elseif application.status == "APPROVED">bg-success
                    <#elseif application.status == "REJECTED">bg-danger
                    <#else>bg-secondary</#if>">
                    ${application.localizedStatus!"—"}
                </span>
            </div>
            <div class="mb-3">
                <strong>Дата подачи:</strong> ${application.formattedSubmittedAt!"—"}
            </div>

            <#if application.preferredTeacher??>
                <div class="mb-3">
                    <strong>Предпочтительный преподаватель:</strong>
                    ${application.preferredTeacher.name} ${application.preferredTeacher.lastName}
                </div>
            </#if>

            <#if application.formattedPreferredStartDate??>
                <div class="mb-3">
                    <strong>Желаемая дата начала:</strong> ${application.formattedPreferredStartDate}
                </div>
            </#if>

            <#if application.formattedPreferredEndDate??>
                <div class="mb-3">
                    <strong>Желаемая дата окончания:</strong> ${application.formattedPreferredEndDate}
                </div>
            </#if>

            <h6 class="mt-4 fw-bold">
                <i class="fas fa-users me-2" style="color: #0066cc;"></i>Сотрудники
            </h6>
            <ul class="list-group mb-4">
                <#list application.employees as emp>
                    <li class="list-group-item">${emp.fullName} &lt;${emp.email}&gt;</li>
                </#list>
            </ul>
        </div>
    </div>

    <div class="card shadow">
        <div class="card-header bg-light fw-semibold">
            <i class="fas fa-comments me-2"></i>Комментарии
        </div>
        <div class="card-body">
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

    <style>
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

        .btn-light:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 102, 204, 0.2);
        }

        .btn-sm {
            font-size: 0.875rem;
            padding: 0.375rem 0.75rem;
        }

        .me-1 {
            margin-right: 0.25rem;
        }

        .me-2 {
            margin-right: 0.5rem;
        }
    </style>
</@layout.page>
