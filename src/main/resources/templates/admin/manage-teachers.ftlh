<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>
<#import "../RoadMap.ftlh" as roadmap>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Потоки курсов", "url": "/admin/course-instances"},
    {"label": "Поток #${courseInstance.id}", "url": "/admin/course-instances/${courseInstance.id}"},
    {"label": "Преподаватели", "url": ""}
    ] />
        <div class="container mb-4">
            <#if successMessage??>
                <div id="successMessage" data-message="${successMessage?js_string}"></div>
            </#if>
            <#if errorMessage??>
                <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
            </#if>
            <div class="d-flex flex-wrap gap-2">
                <a href="/admin/course-instances/${courseInstance.id}" class="btn btn-secondary">Назад</a>
            </div>
        </div>
        <div class="container py-4">
            <div class="hero-section mb-4 text-center">
                <h2 class="hero-title mb-2">Управление преподавателями: <strong>${courseInstance.title}</strong></h2>
                <p class="hero-subtitle fs-5 text-muted">
                    Текущий поток: <span class="fw-semibold">${courseInstance.title}</span>
                </p>
            </div>



            <div class="feature-card mb-5 p-4 bg-white shadow-sm rounded">
                <h3 class="mb-3">Текущие преподаватели</h3>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                        <tr>
                            <th scope="col" style="width: 40%;">Имя преподавателя</th>
                            <th scope="col" style="width: 20%;">Основной</th>
                            <th scope="col" style="width: 20%;">Дата назначения</th>
                            <th scope="col" style="width: 20%;">Действия</th>
                        </tr>
                        </thead>
                        <tbody id="current-teachers">
                        <#list instanceTeachers as teacher>
                            <tr data-teacher-id="${teacher.teacherId}">
                                <td>${teacher.teacherName!''}</td>
                                <td>${teacher.isPrimary?string('Да', 'Нет')}</td>
                                <td>${teacher.createdAt.toLocalDate()}</td>
                                <td>
                                    <form action="/admin/course-instances/${courseInstance.id}/teachers/${teacher.teacherId}/toggle-primary" method="post" class="d-inline">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button type="submit" class="btn btn-${teacher.isPrimary?string('warning', 'outline-secondary')} btn-sm">
                                            ${teacher.isPrimary?string('Снять как основного', 'Сделать основным')}
                                        </button>
                                    </form>
                                </td>

                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="feature-card p-4 bg-white shadow-sm rounded">
                <h3 class="mb-3">Добавить преподавателей</h3>
                <form id="teacher-form" action="/admin/course-instances/${courseInstance.id}/teachers/add" method="post" novalidate>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div id="new-teachers-container" class="mb-4">
                        <#if teacherForm?? && teacherForm.teacherIds?? && teacherForm.teacherIds?has_content>
                            <#list eligibleTeachers as teacher>
                                <#if teacherForm.teacherIds?seq_contains(teacher.teacherId)>
                                    <div class="new-teacher-section mb-3 p-3 border rounded" data-teacher-id="${teacher.teacherId}">
                                        <div class="row align-items-center">
                                            <div class="col-md-1">
                                                <input type="checkbox" class="form-check-input" name="teacherIds" value="${teacher.teacherId}" checked>
                                            </div>
                                            <div class="col-md-5">
                                                <span>${teacher.teacherName!''}</span>
                                            </div>
                                            <div class="col-md-6">
                                                <span>Назначен на курс: ${courseInstance.title}</span>
                                            </div>
                                        </div>
                                    </div>
                                </#if>
                            </#list>
                        </#if>
                        <#list eligibleTeachers as teacher>
                            <#if teacherForm?? && teacherForm.teacherIds?? && !teacherForm.teacherIds?seq_contains(teacher.teacherId)>
                                <div class="new-teacher-section mb-3 p-3 border rounded" data-teacher-id="${teacher.teacherId}">
                                    <div class="row align-items-center">
                                        <div class="col-md-1">
                                            <input type="checkbox" class="form-check-input" name="teacherIds" value="${teacher.teacherId}">
                                        </div>
                                        <div class="col-md-5">
                                            <span>${teacher.teacherName!''}</span>
                                        </div>
                                        <div class="col-md-6">
                                            <span>Назначен на курс: ${courseInstance.title}</span>
                                        </div>
                                    </div>
                                </div>
                            <#elseif !(teacherForm?? && teacherForm.teacherIds??)>
                                <div class="new-teacher-section mb-3 p-3 border rounded" data-teacher-id="${teacher.teacherId}">
                                    <div class="row align-items-center">
                                        <div class="col-md-1">
                                            <input type="checkbox" class="form-check-input" name="teacherIds" value="${teacher.teacherId}">
                                        </div>
                                        <div class="col-md-5">
                                            <span>${teacher.teacherName!''}</span>
                                        </div>
                                        <div class="col-md-6">
                                            <span>Назначен на курс: ${courseInstance.title}</span>
                                        </div>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </div>

                    <div class="d-flex gap-2 flex-wrap">
                        <button type="submit" class="btn btn-primary">Добавить преподавателей</button>
                    </div>
                </form>
            </div>
        </div>

        <script src="/static/js/teachers.js" defer></script>

        <style>
            .hero-title {
                font-weight: 700;
                color: #343a40;
            }
            .hero-subtitle {
                font-weight: 500;
            }
            .feature-card {
                background-color: #fff;
                border-radius: 0.375rem;
                box-shadow: 0 0.125rem 0.25rem rgb(0 0 0 / 0.075);
            }
            table.table-hover tbody tr:hover {
                background-color: #f1f3f5;
                cursor: pointer;
            }
            .new-teacher-section {
                background-color: #f8f9fa;
                padding: 1rem;
                border-radius: 0.375rem;
                margin-bottom: 1rem;
                transition: box-shadow 0.3s ease, transform 0.3s ease;
            }
            .new-teacher-section:hover {
                box-shadow: 0 0.5rem 1rem rgb(0 0 0 / 0.1);
                transform: translateY(-2px);
            }
            .table th, .table td {
                vertical-align: middle;
            }
            .form-check-input {
                margin-top: 0;
            }
            .btn-primary {
                background: linear-gradient(135deg, #0066cc, #003d7a);
                border-color: #0066cc;
            }
            .btn-primary:hover {
                background: linear-gradient(135deg, #003d7a, #002a5a);
                transform: translateY(-1px);
                box-shadow: 0 4px 15px rgba(0,102,204,0.3);
            }
            .btn-danger.btn-sm {
                font-size: 0.875rem;
                padding: 0.25rem 0.5rem;
            }
        </style>
</@layout.page>