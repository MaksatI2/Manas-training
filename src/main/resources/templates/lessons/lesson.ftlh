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

    <div class="container my-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="display-5">${lesson.title}</h1>
                <p class="text-muted">Длительность: <strong>${lesson.durationMinutes} минут</strong></p>
            </div>
            <#if isAdmin || isTeacher>
                <div class="d-flex gap-2">
                    <a href="<@spring.url '/admin/lessons/${lesson.id}/edit'/>" class="btn btn-warning btn-sm">
                        <i class="fas fa-edit me-1"></i>Редактировать
                    </a>

                </div>
            </#if>
        </div>

        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h5 class="card-title">Описание</h5>
                <p class="card-text">
                    <#if lesson.description?has_content>
                        ${lesson.description}
                    <#else>
                        <span class="text-muted">Описание отсутствует</span>
                    </#if>
                </p>
            </div>
        </div>

        <div class="mb-4">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <h4>Материалы</h4>
                <#if isAdmin || isTeacher>
                    <a href="<@spring.url '/admin/lessons/${lesson.id}/materials/new'/>" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus me-1"></i>Добавить
                    </a>
                </#if>
            </div>

            <#if materials?has_content>
                <div class="row row-cols-1 row-cols-md-2 g-3">
                    <#list materials as material>
                        <div class="col">
                            <div class="card h-100 border-0 shadow-sm">
                                <div class="card-body">
                                    <h6 class="card-title mb-2">${material.title}</h6>
                                    <a href="${material.url}" target="_blank" class="card-link small">
                                        <i class="fas fa-external-link-alt me-1"></i>Открыть
                                    </a>
                                    <#if isAdmin>
                                        <form action="<@spring.url '/admin/lessons/${lesson.id}/materials/${material.id}/delete'/>"
                                              method="post" class="d-inline float-end"
                                              onsubmit="return confirm('Удалить материал?')">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </#if>
                                </div>
                            </div>
                        </div>
                    </#list>
                </div>
            <#else>
                <p class="text-muted">Материалы не добавлены.</p>
            </#if>
        </div>

        <div class="mb-4">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <h4>Расписание</h4>
                <#if isAdmin>
                    <#if schedule??>
                        <a href="<@spring.url '/schedules/lessons/${lesson.id}'/>" class="btn btn-primary btn-sm">Редактировать расписание</a>
                    <#else>
                        <a href="<@spring.url '/schedules/lessons/${lesson.id}'/>" class="btn btn-primary btn-sm">Создать расписание</a>
                    </#if>
                </#if>
            </div>

            <#if schedule??>
                <div class="card shadow-sm border-0">
                    <div class="card-body">
                        <h6 class="card-title">${schedule.title!lesson.title}</h6>
                        <p class="card-text">
                            <strong>Дата:</strong> ${schedule.lessonDate}<br>
                            <strong>Длительность:</strong> ${schedule.durationHours} ч.<br>
                            <strong>Преподаватель:</strong> ${schedule.teacherName!'Не указан'}<br>
                            <strong>Тип урока:</strong> ${schedule.lessonType}<br>
                            <#if schedule.meetingUrl?has_content>
                                <strong>Ссылка на встречу:</strong> <a href="${schedule.meetingUrl}" target="_blank">Присоединиться</a><br>
                            </#if>
                            <#if schedule.notes?has_content>
                                <li><strong>Примечания:</strong> ${schedule.notes}</li>
                            </#if>
                        </ul>
                    </div>
                </div>
            <#else>
                <p class="text-muted">Расписание пока не задано.</p>
            </#if>
        </div>
    </div>

    <style>
        .card:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.2s ease-in-out;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border: none;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #004a99, #002f66);
        }

        .card-title {
            font-weight: 600;
        }

        .list-unstyled li {
            margin-bottom: 0.25rem;
        }

        .hero-title {
            font-size: 2rem;
            font-weight: bold;
        }
    </style>
</@layout.page>
