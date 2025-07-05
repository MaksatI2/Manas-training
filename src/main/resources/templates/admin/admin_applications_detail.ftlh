<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page title="Просмотр заявки">
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Заявки на курсы", "url": "/applications/admin"},
    {"label": "Заявка №${application.id}", "url": ""}
    ] />
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center"
             style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-file-alt me-2"></i>
                Заявка №${application.id}
            </h5>
            <a href="/applications/admin" class="btn btn-light btn-sm"
               style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                <i class="fas fa-arrow-left me-1" style="color: #0066cc;"></i> Назад
            </a>
        </div>

        <div class="card-body">
            <h6 class="mb-3"><strong>Организация:</strong> ${application.organizationName!"—"}</h6>
            <p><strong>Курс:</strong> ${application.courseTitle!"—"}</p>
            <p><strong>Статус:</strong>
                <span class="badge
                    <#if application.status == "PENDING">bg-warning
                    <#elseif application.status == "APPROVED">bg-success
                    <#elseif application.status == "REJECTED">bg-danger
                    <#else>bg-secondary</#if>">
                    ${application.localizedStatus!"—"}
                </span>
            </p>
            <p><strong>Дата подачи:</strong> ${application.formattedSubmittedAt!"—"}</p>

            <#if application.outgoingCode?? && application.outgoingCode?has_content>
                <p><strong>Исходящий код:</strong> ${application.outgoingCode}</p>
            </#if>

            <#if application.preferredTeacher??>
                <p><strong>Преподаватель:</strong>
                    ${application.preferredTeacher.name} ${application.preferredTeacher.lastName}
                </p>
            </#if>

            <#if application.formattedPreferredStartDate??>
                <p><strong>Желаемая дата начала:</strong> ${application.formattedPreferredStartDate}</p>
            </#if>
            <#if application.formattedPreferredEndDate??>
                <p><strong>Желаемая дата окончания:</strong> ${application.formattedPreferredEndDate}</p>
            </#if>

            <h6 class="mt-4">Сотрудники</h6>
            <ul class="list-group mb-4">
                <#list application.employees as emp>
                    <li class="list-group-item">${emp.fullName} &lt;${emp.email}&gt;</li>
                </#list>
            </ul>

            <form action="/applications/admin/${application.id}/status" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <div class="mb-3">
                    <label for="newStatus" class="form-label fw-bold">Изменить статус</label>
                    <select id="newStatus" name="newStatus" class="form-select" required>
                        <option value="">Выберите</option>
                        <option value="APPROVED">Одобрена</option>
                        <option value="REJECTED">Отклонена</option>
                        <option value="IN_PROGRESS">В работе</option>
                        <option value="FINISHED">Завершена</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="comment" class="form-label fw-bold">Комментарий (обязателен при отклонении)</label>
                    <textarea id="comment" name="comment" rows="3" class="form-control"></textarea>
                </div>

                <button type="submit" class="btn btn-primary shadow-sm">
                    <i class="fas fa-save me-1"></i> Сохранить
                </button>
            </form>
        </div>
    </div>

    <div class="card shadow">
        <div class="card-header bg-light fw-semibold">
            <i class="fas fa-comments me-2"></i> Комментарии
        </div>
        <div class="card-body">
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
                    <label for="comment" class="form-label fw-bold">Добавить комментарий</label>
                    <textarea id="comment" name="comment" rows="3" class="form-control" required></textarea>
                </div>
                <button type="submit" class="btn btn-outline-primary shadow-sm">
                    <i class="fas fa-paper-plane me-1"></i> Отправить
                </button>
            </form>
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

        .btn-outline-primary:hover {
            background-color: #0066cc;
            color: white;
            border-color: #0066cc;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }

        .btn-light:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 102, 204, 0.2);
        }
    </style>
</@layout.page>
