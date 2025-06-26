<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<#assign known = Session.SPRING_SECURITY_CONTEXT??>
<#if known>
    <#assign user = Session.SPRING_SECURITY_CONTEXT.authentication.principal>
    <#assign name = user.getFullName()>
    <#assign roles = user.getAuthorities()?join(",")>
    <#assign isAdmin = roles?contains("ADMIN")>
    <#assign isTeacher = roles?contains("TEACHER")>
    <#assign isStudent = roles?contains("STUDENT")>
    <#assign isOrganization = roles?contains("ORGANIZATION")>
</#if>

<@layout.page>
    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="display-4 fw-bold">${lesson.title}</h1>
                <p class="text-muted mb-0"><i class="fas fa-clock me-1"></i>Длительность: <strong>${lesson.durationMinutes} минут</strong></p>
            </div>
            <#if isAdmin || isTeacher>
                <div class="d-flex gap-2">
                    <a href="<@spring.url '/admin/lessons/${lesson.id}/edit'/>" class="btn btn-primary btn-sm rounded-pill">
                        <i class="fas fa-edit me-1"></i>Редактировать
                    </a>

                    <form method="post" action="<@spring.url '/admin/lessons/${lesson.id}/delete'/>" onsubmit="return confirm('Вы уверены, что хотите удалить этот урок?')">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-danger btn-sm rounded-pill">
                            <i class="fas fa-trash-alt me-1"></i>Удалить
                        </button>
                    </form>
                </div>
            </#if>
        </div>

        <div class="card shadow-sm mb-5 border-0 rounded-3">
            <div class="card-body">
                <h5 class="card-title fw-semibold">Описание</h5>
                <p class="card-text text-secondary">
                    <#if lesson.description?has_content>
                        ${lesson.description}
                    <#else>
                        <span class="text-muted fst-italic">Описание отсутствует</span>
                    </#if>
                </p>
            </div>
        </div>

        <div class="mb-5">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="fw-bold">Материалы</h4>
                <#if isAdmin || isTeacher>
                    <a href="<@spring.url '/admin/lessons/${lesson.id}/materials/new'/>" class="btn btn-primary btn-sm rounded-pill">
                        <i class="fas fa-plus me-1"></i>Добавить
                    </a>
                </#if>
            </div>

            <#if materials?has_content>
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                    <#list materials as material>
                        <div class="col">
                            <div class="card h-100 border-0 shadow-sm rounded-3 overflow-hidden">
                                <div class="card-body d-flex flex-column">
                                    <h6 class="card-title mb-3 fw-semibold">${material.title}</h6>
                                    <div class="mt-auto d-flex justify-content-between align-items-center">
                                        <a href="${material.url}" target="_blank" class="btn btn-outline-primary btn-sm">
                                            <i class="fas fa-external-link-alt me-1"></i>Открыть
                                        </a>
                                        <#if isAdmin>
                                            <form action="<@spring.url '/admin/lessons/${lesson.id}/materials/${material.id}/delete'/>"
                                                  method="post" class="d-inline"
                                                  onsubmit="return confirm('Удалить материал?')">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-outline-danger btn-sm">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                        </#if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </#list>
                </div>
            <#else>
                <div class="text-center py-5 bg-light rounded-3">
                    <p class="text-muted mb-0">Материалы не добавлены.</p>
                </div>
            </#if>
        </div>

        <div class="mb-5">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="fw-bold">Расписание</h4>
                <#if isAdmin>
                    <#if schedule??>
                        <a href="<@spring.url '/schedules/lessons/${lesson.id}'/>" class="btn btn-primary btn-sm">Редактировать расписание</a>
                    <#else>
                        <a href="<@spring.url '/schedules/lessons/${lesson.id}'/>" class="btn btn-primary btn-sm">Создать расписание</a>
                    </#if>
                </#if>
            </div>

            <#if schedule??>
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body">
                        <h6 class="card-title fw-semibold">${schedule.title!lesson.title}</h6>
                        <ul class="list-unstyled small mb-0 text-secondary">
                            <li><i class="fas fa-calendar me-1"></i><strong>Дата:</strong> ${schedule.lessonDate}</li>
                            <li><i class="fas fa-clock me-1"></i><strong>Длительность:</strong> ${schedule.durationHours} ч.</li>
                            <li><i class="fas fa-user me-1"></i><strong>Преподаватель:</strong> ${schedule.teacherName!'Не указан'}</li>
                            <li><i class="fas fa-chalkboard me-1"></i><strong>Тип урока:</strong> ${schedule.lessonType}</li>
                            <#if schedule.meetingUrl?has_content>
                                <li><i class="fas fa-link me-1"></i><strong>Ссылка:</strong> <a href="${schedule.meetingUrl}" target="_blank" class="text-primary">Присоединиться</a></li>
                            </#if>
                            <#if schedule.notes?has_content>
                                <li><i class="fas fa-note-sticky me-1"></i><strong>Примечания:</strong> ${schedule.notes}</li>
                            </#if>
                        </ul>
                    </div>
                </div>
            <#else>
                <div class="text-center py-5 bg-light rounded-3">
                    <p class="text-muted mb-0">Расписание пока не задано.</p>
                </div>
            </#if>
        </div>
    </div>

    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        .container {
            max-width: 1200px;
        }

        .display-4 {
            font-size: 2.5rem;
            color: #1a252f;
        }

        .card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
        }

        .btn-primary {
            background: linear-gradient(135deg, #007bff, #0056b3);
            border: none;
            transition: background 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #0056b3, #003d7a);
        }

        .btn-outline-primary, .btn-outline-warning, .btn-outline-danger {
            transition: all 0.2s ease-in-out;
        }

        .btn-outline-primary:hover, .btn-outline-warning:hover, .btn-outline-danger:hover {
            transform: scale(1.05);
        }

        .btn-sm {
            padding: 0.375rem 0.75rem;
        }

        .rounded-pill {
            border-radius: 50rem !important;
        }

        .card-title {
            color: #1a252f;
        }

        .text-secondary {
            color: #6c757d !important;
        }

        .list-unstyled li {
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }

        .list-unstyled i {
            width: 1.25rem;
            text-align: center;
        }

        .alert {
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .bg-light {
            background-color: #f1f3f5 !important;
        }

        @media (max-width: 768px) {
            .display-4 {
                font-size: 2rem;
            }

            .d-flex.justify-content-between {
                flex-direction: column;
                gap: 1rem;
            }

            .d-flex.gap-2 {
                justify-content: center;
            }
        }
    </style>
</@layout.page>