<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css"/>
<script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>

<@layout.page title="Создание заявки на курс">

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

        .btn-outline-secondary:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .form-label {
            color: #2c3e50;
        }

        .form-control, .form-select {
            border-radius: 0.375rem;
        }

        .me-1 { margin-right: 0.25rem; }
        .me-2 { margin-right: 0.5rem; }
    </style>

    <div class="card-custom mb-4">
        <div class="card-header-custom">
            <h5 class="m-0">
                <i class="fas fa-file-signature me-2"></i>Создание заявки на курс
            </h5>
            <div class="d-flex align-items-center">
                <a href="/applications/organization/calendar" class="btn btn-light btn-sm me-2"
                   style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-calendar-alt me-1" style="color: #0066cc;"></i> Календарь
                </a>
                <a href="/applications/organization" class="btn btn-light btn-sm"
                   style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-arrow-left me-1" style="color: #0066cc;"></i> Назад
                </a>
            </div>
        </div>

        <div class="card-body-custom">
            <#if errors?? && errors.hasGlobalErrors()>
                <div class="alert alert-danger small">
                    <#list errors.globalErrors as err>
                        ${err.defaultMessage}<br/>
                    </#list>
                </div>
            </#if>

            <form action="/applications/organization" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="courseId" class="form-label fw-bold">Курс <span class="text-danger">*</span></label>
                            <select id="courseId" name="courseId" class="form-select" required>
                                <option value="">Выберите курс</option>
                                <#list courses as course>
                                    <option value="${course.id}"
                                            <#if application?? && application.courseId?? && application.courseId == course.id>selected</#if>>
                                        ${course.title}
                                    </option>
                                </#list>
                            </select>
                            <#if errors?? && errors.hasFieldErrors("courseId")>
                                <div class="text-danger small mt-1">${errors.getFieldError("courseId").defaultMessage}</div>
                            </#if>
                        </div>

                        <div class="mb-3">
                            <label for="preferredTeacherId" class="form-label fw-bold">Предпочтительный преподаватель</label>
                            <select id="preferredTeacherId" name="preferredTeacherId" class="form-select">
                                <option value="">Не выбрано</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="preferredStartDate" class="form-label fw-bold">Желаемая дата начала</label>
                            <input type="date" id="preferredStartDate" name="preferredStartDate" class="form-control"
                                   value="${(application.preferredStartDate)?if_exists}">
                            <#if errors?? && errors.hasFieldErrors("preferredStartDate")>
                                <div class="text-danger small mt-1">${errors.getFieldError("preferredStartDate").defaultMessage}</div>
                            </#if>
                        </div>

                        <div class="mb-3">
                            <label for="preferredEndDate" class="form-label fw-bold">Желаемая дата окончания</label>
                            <input type="date" id="preferredEndDate" name="preferredEndDate" class="form-control"
                                   value="${(application.preferredEndDate)?if_exists}">
                            <#if errors?? && errors.hasFieldErrors("preferredEndDate")>
                                <div class="text-danger small mt-1">${errors.getFieldError("preferredEndDate").defaultMessage}</div>
                            </#if>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="employeeIds" class="form-label fw-bold">Сотрудники <span class="text-danger">*</span></label>
                            <select id="employeeIds" name="employeeIds" class="form-select" multiple required>
                                <#list employees as emp>
                                    <option value="${emp.id}"
                                            <#if application.employeeIds?? && application.employeeIds?seq_contains(emp.id)>selected</#if>>
                                        ${emp.fullName} &lt;${emp.email}&gt;
                                    </option>
                                </#list>
                            </select>
                            <#if errors?? && errors.hasFieldErrors("employeeIds")>
                                <div class="text-danger small mt-1">${errors.getFieldError("employeeIds").defaultMessage}</div>
                            </#if>
                        </div>

                        <div class="mb-3">
                            <label for="outgoingCode" class="form-label fw-bold">Исходящий код компании <span class="text-danger">*</span></label>
                            <input type="text" id="outgoingCode" name="outgoingCode" class="form-control"
                                   value="${(application.outgoingCode)!''}" required>
                            <#if errors?? && errors.hasFieldErrors("outgoingCode")>
                                <div class="text-danger small mt-1">${errors.getFieldError("outgoingCode").defaultMessage}</div>
                            </#if>
                        </div>
                    </div>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-primary shadow-sm">
                        <i class="fas fa-paper-plane me-1"></i> Отправить заявку
                    </button>
                    <a href="/applications/organization" class="btn btn-outline-secondary ms-2">
                        <i class="fas fa-arrow-left me-1"></i> Назад
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const element = document.getElementById('employeeIds');
            new Choices(element, {
                removeItemButton: true,
                searchResultLimit: 10,
                searchPlaceholderValue: 'Поиск сотрудника...',
                placeholder: true,
                shouldSort: false,
            });
        });

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
    </script>
</@layout.page>
