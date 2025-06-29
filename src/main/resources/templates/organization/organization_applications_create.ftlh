<#import "../layout.ftlh" as layout>
<@layout.page title="Создание заявки на курс">
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center"
             style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-file-signature me-2"></i>
                Создание заявки на курс
            </h5>
            <a href="/applications/organization" class="btn btn-light btn-sm"
               style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                <i class="fas fa-arrow-left me-1" style="color: #0066cc;"></i> Назад
            </a>
        </div>

        <div class="card-body">
            <#if errors?? && errors.hasGlobalErrors()>
                <div class="alert alert-danger small">
                    <#list errors.globalErrors as err>
                        ${err.defaultMessage}<br/>
                    </#list>
                </div>
            </#if>

            <form action="/applications/organization" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="mb-3">
                    <label for="courseId" class="form-label fw-bold">Курс <span class="text-danger">*</span></label>
                    <select id="courseId" name="courseId" class="form-select" required>
                        <option value="">Выберите курс</option>
                        <#list courses as course>
                            <option value="${course.id}"
                                    <#if application?? && application.courseId?? && application.courseId == course.id>selected</#if>>
                                ${course.title}
                                <#if course.instanceTitle??> — ${course.instanceTitle}</#if>
                                <#if course.instanceStartDate?? && course.instanceEndDate??>
                                    (${course.instanceStartDate} — ${course.instanceEndDate})
                                </#if>
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
                        <#list teachers as teacher>
                            <option value="${teacher.id}"
                                    <#if application?? && application.preferredTeacherId?? && application.preferredTeacherId == teacher.id>selected</#if>>
                                ${teacher.fullName}
                            </option>
                        </#list>
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

                <div class="mb-3">
                    <label class="form-label fw-bold">Сотрудники <span class="text-danger">*</span></label>
                    <#if employees?size == 0>
                        <p class="text-muted">Нет доступных сотрудников.</p>
                    <#else>
                        <#list employees as emp>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="employeeIds"
                                       value="${emp.id}" id="emp_${emp.id}"
                                       <#if application.employeeIds?? && application.employeeIds?seq_contains(emp.id)>checked</#if>>
                                <label class="form-check-label" for="emp_${emp.id}">
                                    ${emp.fullName} &lt;${emp.email}&gt;
                                </label>
                            </div>
                        </#list>
                    </#if>
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

    <style>
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

        .form-check-label {
            color: #495057;
        }

        .form-control, .form-select {
            border-radius: 0.375rem;
        }
    </style>
</@layout.page>
