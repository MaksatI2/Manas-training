<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page title="Просмотр заявки">
    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

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
            display: inline-block;
            min-width: 80px;
            text-align: center;
        }

        .custom-toast {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1080;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            opacity: 1;
            transition: opacity 0.5s ease-in-out;
            min-width: 320px;
            max-width: 400px;
            font-size: 0.95rem;
        }

        .custom-toast.hide {
            opacity: 0;
            pointer-events: none;
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
            padding: 0.75rem 1rem;
            border-bottom: 1px dashed #ddd;
            font-size: 0.95rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #f9f9f9;
            border-radius: 8px;
            margin-bottom: 0.5rem;
        }

        .employee-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .btn-light:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 102, 204, 0.2);
        }

        .form-label {
            font-weight: 600;
        }

        .text-wrap {
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
        }

        .field-container {
            display: flex;
            flex-direction: column;
            max-width: 100%;
        }

        .field-container strong {
            white-space: nowrap;
        }

        .field-container-status {
            display: inline-flex;
            flex-direction: column;
            align-items: flex-start;
            width: auto;
        }


        .field-value {
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
            max-width: 100%;
        }

        .employee-container {
            max-width: 100%;
            padding: 0.5rem;
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
                <div class="col-12 col-sm-6 col-md-6 mb-3 field-container">
                    <strong>Организация:</strong>
                    <span class="field-value">${application.organizationName!"—"}</span>
                </div>
                <div class="col-12 col-sm-6 col-md-6 mb-3 field-container">
                    <strong>Код организации:</strong>
                    <span class="field-value">${application.organizationCode!"—"}</span>
                </div>
                <div class="col-12 col-sm-6 col-md-6 mb-3 field-container">
                    <strong>Курс:</strong>
                    <span class="field-value">${application.courseTitle!"—"}</span>
                </div>
                <div class="col-12 col-sm-6 col-md-6 mb-3 field-container-status">
                    <strong>Статус:</strong>
                    <span class="badge
                    <#if application.status == "PENDING">bg-warning
                    <#elseif application.status == "APPROVED">bg-success
                    <#elseif application.status == "REJECTED">bg-danger
                    <#elseif application.status == "IN_PROGRESS">bg-info
                    <#else>bg-secondary</#if>">
                    ${application.localizedStatus!"—"}
                </span>
                </div>
                <div class="col-12 col-sm-6 col-md-6 mb-3 field-container">
                    <strong>Дата подачи:</strong>
                    <span class="field-value">${application.formattedSubmittedAt!"—"}</span>
                </div>

                <#if application.outgoingCode?? && application.outgoingCode?has_content>
                    <div class="col-12 col-sm-6 col-md-6 mb-3 field-container">
                        <strong>Исходящий код:</strong>
                        <span class="field-value">${application.outgoingCode}</span>
                    </div>
                </#if>

                <#if application.preferredTeacher??>
                    <div class="col-12 col-sm-6 col-md-6 mb-3 field-container">
                        <strong>Желаемый преподаватель:</strong>
                        <span class="field-value">${application.preferredTeacher.name} ${application.preferredTeacher.lastName}</span>
                    </div>
                </#if>

                <#if application.formattedPreferredStartDate??>
                    <div class="col-12 col-sm-6 col-md-6 mb-3 field-container">
                        <strong>Желаемая дата начала:</strong>
                        <span class="field-value">${application.formattedPreferredStartDate}</span>
                    </div>
                </#if>

                <#if application.formattedPreferredEndDate??>
                    <div class="col-12 col-sm-6 col-md-6 mb-3 field-container">
                        <strong>Желаемая дата окончания:</strong>
                        <span class="field-value">${application.formattedPreferredEndDate}</span>
                    </div>
                </#if>
            </div>

            <div class="col-12 mb-3">
                <strong class="section-title">Участники заявки:</strong>
                <div class="row">
                    <#list application.employees as emp>
                        <div class="col-12 col-sm-6 employee-container">
                            <div class="employee-item">
                            <span class="field-value">
                                <i class="fas fa-user me-2 text-muted"></i>
                                ${emp.fullName} &lt;${emp.email}&gt;
                            </span>
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
                        </div>
                    </#list>
                </div>
            </div>
            <#if application.status != "APPROVED" && application.status != "REJECTED">
                <div class="card-body-custom">
                    <form action="/applications/admin/${application.id}/status" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div class="row">
                            <div class="col-12 col-md-6 mb-3">
                                <label for="newStatus" class="form-label">Изменить статус</label>
                                <select id="newStatus" name="newStatus" class="form-select form-select-sm">
                                    <option value="">Выберите</option>
                                    <option value="APPROVED">Одобрена</option>
                                    <option value="REJECTED">Отклонена</option>
                                    <option value="IN_PROGRESS">В работе</option>
                                </select>
                            </div>
                            <div class="col-12 col-md-6 mb-3">
                                <label for="comment" class="form-label">Комментарий (обязателен при отклонении)</label>
                                <textarea id="comment" name="comment" rows="3" class="form-control form-control-sm"></textarea>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary shadow-sm">
                            <i class="fas fa-save me-1"></i> Сохранить
                        </button>
                    </form>
                </div>
            <#else>
                <div class="alert alert-info mt-3">
                    Заявка уже
                    <#if application.status == "APPROVED"><strong>одобрена</strong></#if>
                    <#if application.status == "REJECTED"><strong>отклонена</strong></#if>
                    , её статус изменить нельзя.
                </div>
            </#if>
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
                            <div class="field-value">${c.comment}</div>
                            <div class="text-muted small">${c.formattedCreatedAt!"—"}</div>
                        </li>
                    </#list>
                </ul>
            </#if>

            <form action="/applications/admin/${application.id}/comment" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="mb-3">
                    <label for="comment" class="form-label">Добавить комментарий</label>
                    <textarea id="comment" name="comment" rows="3" class="form-control"></textarea>
                </div>
                <button type="submit" class="btn btn-outline-primary shadow-sm">
                    <i class="fas fa-paper-plane me-1"></i> Отправить
                </button>
            </form>
        </div>
    </div>

    <script>
        setTimeout(() => {
            document.querySelectorAll('.custom-toast').forEach(toast => {
                toast.classList.add('hide');
            });
        }, 5000);
    </script>

</@layout.page>