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

    <div class="hero-section">
        <h1 class="hero-title">${lesson.title}</h1>
        <p class="hero-subtitle">
            Длительность: ${lesson.durationMinutes} минут
        </p>
    </div>

    <div class="container">
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h5 class="card-title">Описание</h5>
                <#if lesson.description?has_content>
                    <p class="card-text">${lesson.description}</p>
                <#else>
                    <p class="card-text text-muted">Описание отсутствует</p>
                </#if>
            </div>
        </div>

        <div class="mb-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5>Материалы урока</h5>
                <#if isAdmin || isTeacher>
                    <a href="<@spring.url '/admin/lessons/${lesson.id}/materials/new'/>" class="btn btn-primary btn-sm">+ Добавить материал</a>
                </#if>
            </div>
            <#if materials?has_content>
                <div class="row row-cols-1 row-cols-md-2 g-3">
                    <#list materials as material>
                        <div class="col">
                            <div class="card h-100 shadow-sm">
                                <div class="card-body">
                                    <h6 class="card-title">${material.title}</h6>
                                    <a href="${material.url}" target="_blank" class="card-link small">Открыть материал</a>
                                    <#if isAdmin || isTeacher>
                                        <form action="<@spring.url '/admin/lessons/${lesson.id}/materials/${material.id}/delete'/>" method="post" class="d-inline">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <button type="submit" class="btn btn-danger btn-sm float-end" onclick="return confirm('Удалить материал?')">Удалить</button>
                                        </form>
                                    </#if>
                                </div>
                            </div>
                        </div>
                    </#list>
                </div>
            <#else>
                <p class="text-muted">Материалы отсутствуют</p>
            </#if>
        </div>

        <div class="mb-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5>Расписание</h5>
                <#if isAdmin>
                    <#if schedule??>
                        <a href="<@spring.url '/admin/lessons/${lesson.id}/schedule'/>" class="btn btn-primary btn-sm">Редактировать расписание</a>
                    <#else>
                        <a href="<@spring.url '/admin/lessons/${lesson.id}/schedule'/>" class="btn btn-primary btn-sm">Создать расписание</a>
                    </#if>
                </#if>
            </div>
            <#if schedule??>
                <div class="card shadow-sm">
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
                                <strong>Примечания:</strong> ${schedule.notes}<br>
                            </#if>
                        </p>
                    </div>
                </div>
            <#else>
                <p class="text-muted">Расписание не задано</p>
            </#if>
        </div>

        <a href="<@spring.url '/courses'/>" class="btn btn-secondary">К списку курсов</a>
    </div>

    <style>
        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
        .card {
            border-radius: 0.375rem;
        }
        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.2s ease-in-out;
        }
        .card-title {
            font-size: 1.1rem;
            font-weight: 500;
        }
        .card-text, .card-link {
            font-size: 0.875rem;
        }
    </style>
</@layout.page>
