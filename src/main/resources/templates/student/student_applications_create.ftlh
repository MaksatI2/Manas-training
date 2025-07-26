<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css"/>
<script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>

<@layout.page title="Подача заявки на курс">
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои заявки", "url": "/applications/student/applications"},
    {"label": "Подача заявки", "url": ""}
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
            transition: 0.3s ease;
        }

        .card-custom:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 25px rgba(0, 102, 204, 0.15);
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

        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }

        .form-label {
            color: #2c3e50;
        }
    </style>

    <div class="card-custom mb-4">
        <div class="card-header-custom">
            <h5 class="m-0">
                <i class="fas fa-user-edit me-2"></i> Подача заявки на курс
            </h5>
            <a href="/applications/student/applications" class="btn btn-light btn-sm"
               style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                <i class="fas fa-arrow-left me-1" style="color: #0066cc;"></i> Назад
            </a>
        </div>

        <div class="card-body-custom">
            <form method="post" action="/applications/student/applications">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <#if errors?? && errors.hasGlobalErrors()>
                    <div class="alert alert-danger small">
                        <#list errors.globalErrors as err>
                            ${err.defaultMessage}<br/>
                        </#list>
                    </div>
                </#if>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="courseId" class="form-label fw-bold">Курс <span class="text-danger">*</span></label>
                        <select id="courseId" name="courseId" class="form-select" required>
                            <option value="">Выберите курс</option>
                            <#list courses as course>
                                <option value="${course.id}"
                                        <#if application?? && application.courseId?? && application.courseId?number == course.id>selected</#if>>
                                    ${course.title}
                                </option>
                            </#list>
                        </select>
                        <#if errors?? && errors.hasFieldErrors("courseId")>
                            <div class="text-danger small mt-1">${errors.getFieldError("courseId").defaultMessage}</div>
                        </#if>
                    </div>
                    <div class="col-md-6">
                        <label for="preferredTeacherId" class="form-label fw-bold">Предпочтительный преподаватель</label>
                        <select id="preferredTeacherId" name="preferredTeacherId" class="form-select">
                            <option value="">Не выбрано</option>
                            <#if teachers??>
                                <#list teachers as teacher>
                                    <option value="${teacher.id}"
                                            <#if application?? && application.preferredTeacherId?? && application.preferredTeacherId?number == teacher.id>selected</#if>>
                                        ${teacher.fullName} (${teacher.email})
                                    </option>
                                </#list>
                            </#if>
                        </select>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="preferredStartDate" class="form-label fw-bold">Желаемая дата начала</label>
                        <input type="date" id="preferredStartDate" name="preferredStartDate" class="form-control"
                               value="${(application.preferredStartDate)!}">
                        <#if errors?? && errors.hasFieldErrors("preferredStartDate")>
                            <div class="text-danger small mt-1">${errors.getFieldError("preferredStartDate").defaultMessage}</div>
                        </#if>
                    </div>
                    <div class="col-md-6">
                        <label for="preferredEndDate" class="form-label fw-bold">Желаемая дата окончания</label>
                        <input type="date" id="preferredEndDate" name="preferredEndDate" class="form-control"
                               value="${(application.preferredEndDate)!}">
                        <#if errors?? && errors.hasFieldErrors("preferredEndDate")>
                            <div class="text-danger small mt-1">${errors.getFieldError("preferredEndDate").defaultMessage}</div>
                        </#if>
                    </div>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-primary shadow-sm">
                        <i class="fas fa-paper-plane me-1"></i> Отправить заявку
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.getElementById('courseId').addEventListener('change', function () {
            const courseId = this.value;
            const teacherSelect = document.getElementById('preferredTeacherId');
            teacherSelect.innerHTML = '<option value="">Не выбрано</option>';

            if (courseId) {
                fetch('/api/courses/' + courseId + '/teachers')
                    .then(response => response.json())
                    .then(data => {
                        data.forEach(teacher => {
                            const option = document.createElement('option');
                            option.value = teacher.id;
                            option.textContent = teacher.fullName + ' (' + teacher.email + ')';
                            teacherSelect.appendChild(option);
                        });
                    })
                    .catch(error => {
                        console.error('Ошибка при загрузке преподавателей:', error);
                    });
            }
        });

        window.addEventListener('DOMContentLoaded', function () {
            const courseSelect = document.getElementById('courseId');
            if (courseSelect.value) {
                courseSelect.dispatchEvent(new Event('change'));
            }
        });
    </script>

</@layout.page>
