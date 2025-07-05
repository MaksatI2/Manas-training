<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page title="Просмотр заявки">

<@roadmap.breadcrumbs items=[
  {"label": "Главная", "url": "/"},
  {"label": "Заявки на курсы", "url": "/applications/admin"},
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
    .bg-info { background-color: #17a2b8 !important; }
    .bg-secondary { background-color: #6c757d !important; }

    .me-1 { margin-right: 0.25rem; }
    .me-2 { margin-right: 0.5rem; }

    .section-title {
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 1rem;
        color: var(--dark-blue);
    }

    .employee-item {
        padding: 0.4rem 0;
        border-bottom: 1px dashed #ddd;
        font-size: 0.95rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .employee-item:last-child {
        border-bottom: none;
    }

    .btn-light:hover {
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(0, 102, 204, 0.2);
    }

    .form-label {
        font-weight: 600;
    }
</style>

<div class="card-custom">
    <div class="card-header-custom">
        <h5 class="m-0">
            <i class="fas fa-file-alt me-2"></i> Заявка №${application.id}
        </h5>
        <a href="/applications/admin" class="btn btn-light btn-sm"
           style="border-radius: 25px; background: white; color: var(--primary-blue); border: 1px solid var(--primary-blue);">
            <i class="fas fa-arrow-left me-1" style="color: var(--primary-blue);"></i> Назад
        </a>
    </div>
    <div class="card-body-custom">
        <div class="row">
            <div class="col-md-6 mb-3"><strong>Организация:</strong><br>${application.organizationName!"—"}</div>
            <div class="col-md-6 mb-3"><strong>Код организации:</strong><br>${application.organizationCode!"—"}</div>
            <div class="col-md-6 mb-3"><strong>Курс:</strong><br>${application.courseTitle!"—"}</div>
            <div class="col-md-6 mb-3">
                <strong>Статус:</strong><br>
                <span class="badge
                    <#if application.status == "PENDING">bg-warning
                    <#elseif application.status == "APPROVED">bg-success
                    <#elseif application.status == "REJECTED">bg-danger
                    <#elseif application.status == "IN_PROGRESS">bg-info
                    <#else>bg-secondary</#if>">
                    ${application.localizedStatus!"—"}
                </span>
            </div>
            <div class="col-md-6 mb-3"><strong>Дата подачи:</strong><br>${application.formattedSubmittedAt!"—"}</div>

            <#if application.outgoingCode?? && application.outgoingCode?has_content>
                <div class="col-md-6 mb-3"><strong>Исходящий код:</strong><br>${application.outgoingCode}</div>
            </#if>

            <#if application.preferredTeacher??>
                <div class="col-md-6 mb-3"><strong>Желаемый преподаватель:</strong><br>${application.preferredTeacher.name} ${application.preferredTeacher.lastName}</div>
            </#if>

            <#if application.formattedPreferredStartDate??>
                <div class="col-md-6 mb-3"><strong>Желаемая дата начала:</strong><br>${application.formattedPreferredStartDate}</div>
            </#if>

            <#if application.formattedPreferredEndDate??>
                <div class="col-md-6 mb-3"><strong>Желаемая дата окончания:</strong><br>${application.formattedPreferredEndDate}</div>
            </#if>
        </div>

        <h6 class="mt-4 section-title"><i class="fas fa-users me-2 text-primary"></i>Сотрудники</h6>
        <div class="employee-list mb-4">
            <#list application.employees as emp>
                <div class="employee-item">
                    <span><i class="fas fa-user me-1 text-muted"></i>${emp.fullName} &lt;${emp.email}&gt;</span>
                    <span class="badge
                        <#if emp.applicationStatus == "APPROVED">bg-success
                        <#elseif emp.applicationStatus == "REJECTED">bg-danger
                        <#elseif emp.applicationStatus == "PENDING">bg-warning
                        <#else>bg-secondary</#if>">
                        <#if emp.applicationStatus == "APPROVED">Одобрен
                        <#elseif emp.applicationStatus == "REJECTED">Отклонён
                        <#elseif emp.applicationStatus == "PENDING">В ожидании
                        <#else>Неизвестно</#if>
                    </span>
                </div>
            </#list>
        </div>
        <div class="card-body-custom">
            <form action="/applications/admin/${application.id}/status" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="newStatus" class="form-label">Изменить статус</label>
                        <select id="newStatus" name="newStatus" class="form-select form-select-sm" required>
                            <option value="">Выберите</option>
                            <option value="APPROVED">Одобрена</option>
                            <option value="REJECTED">Отклонена</option>
                            <option value="IN_PROGRESS">В работе</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="comment" class="form-label">Комментарий (обязателен при отклонении)</label>
                        <textarea id="comment" name="comment" rows="3" class="form-control form-control-sm"></textarea>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary shadow-sm">
                    <i class="fas fa-save me-1"></i> Сохранить
                </button>
            </form>
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
            <ul class="list-group list-group-flush mb-3">
                <#list comments as c>
                    <li class="list-group-item">
                        <div class="fw-bold">${c.authorName}</div>
                        <div>${c.comment}</div>
                        <div class="text-muted small">${c.formattedCreatedAt!"—"}</div>
                    </li>
                </#list>
            </ul>
        </#if>

        <form action="/applications/admin/${application.id}/comment" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="mb-3">
                <label for="comment" class="form-label">Добавить комментарий</label>
                <textarea id="comment" name="comment" rows="3" class="form-control" required></textarea>
            </div>
            <button type="submit" class="btn btn-outline-primary shadow-sm">
                <i class="fas fa-paper-plane me-1"></i> Отправить
            </button>
        </form>
    </div>
</div>

    <script>
        setTimeout(() => {
            const toast = document.querySelector('.custom-toast');
            if (toast) toast.classList.remove('show');
        }, 5000);
    </script>

</@layout.page>
