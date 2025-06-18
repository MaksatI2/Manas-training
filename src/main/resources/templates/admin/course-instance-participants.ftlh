<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<@layout.page>
    <div class="container py-4">
        <div class="hero-section mb-4 text-center">
            <h2 class="hero-title mb-2">Управление участниками курса: <strong>${courseInstance.title}</strong></h2>
            <p class="hero-subtitle fs-5 text-muted">
                Текущий поток: <span class="fw-semibold">${courseInstance.title}</span>
            </p>
        </div>

        <#if errorMessage??>
            <div class="alert alert-danger mt-3 mx-auto" style="max-width: 600px;">
                ${errorMessage}
            </div>
        </#if>

        <div class="feature-card mb-5 p-4 bg-white shadow-sm rounded">
            <h3 class="mb-3">Текущие участники</h3>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th scope="col" style="width: 30%;">Имя участника</th>
                        <th scope="col" style="width: 20%;">Дата зачисления</th>
                        <th scope="col" style="width: 20%;">Статус</th>
                        <th scope="col" style="width: 10%;">Оценка</th>
                    </tr>
                    </thead>
                    <tbody id="current-participants">
                    <#list enrollments as enrollment>
                        <tr data-enrollment-id="${enrollment.id}">
                            <td>${enrollment.studentName!''}</td>
                            <td>${enrollment.enrollmentDate.toLocalDate()}</td>
                            <td>${enrollment.status}</td>
                            <td>${(enrollment.finalGrade?string['0.##'])!'–'}</td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="feature-card p-4 bg-white shadow-sm rounded">
            <h3 class="mb-3">Добавить участников из заявок</h3>
            <form id="participant-form" action="/admin/course-instances/${courseInstance.id}/participants/add" method="post" novalidate>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div id="new-participants-container" class="mb-4">
                    <#if (participantForm.pendingEmployeeIds)?? && participantForm.pendingEmployeeIds?has_content>
                        <#list pendingEmployees as employee>
                            <#if participantForm.pendingEmployeeIds?seq_contains(employee.id)>
                                <div class="new-participant-section mb-3 p-3 border rounded" data-employee-id="${employee.id}">
                                    <div class="row align-items-center">
                                        <div class="col-md-1">
                                            <input type="checkbox" class="form-check-input" name="pendingEmployeeIds" value="${employee.id}" checked>
                                        </div>
                                        <div class="col-md-5">
                                            <span>${employee.employeeName!''}</span>
                                        </div>
                                        <div class="col-md-4">
                                            <span>Заявка #${employee.applicationId}</span>
                                        </div>
                                        <div class="col-md-2">
                                            <span>${employee.applicationStatus}</span>
                                        </div>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </#if>
                    <#list pendingEmployees as employee>
                        <#if !(participantForm.pendingEmployeeIds?seq_contains(employee.id))>
                            <div class="new-participant-section mb-3 p-3 border rounded" data-employee-id="${employee.id}">
                                <div class="row align-items-center">
                                    <div class="col-md-1">
                                        <input type="checkbox" class="form-check-input" name="pendingEmployeeIds" value="${employee.id}">
                                    </div>
                                    <div class="col-md-5">
                                        <span>${employee.employeeName!''}</span>
                                    </div>
                                    <div class="col-md-4">
                                        <span>Заявка #${employee.applicationId}</span>
                                    </div>
                                    <div class="col-md-2">
                                        <span>${employee.applicationStatus}</span>
                                    </div>
                                </div>
                            </div>
                        </#if>
                    </#list>
                </div>

                <div class="d-flex gap-2 flex-wrap">
                    <button type="submit" class="btn btn-primary">
                        Добавить участников
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="/static/js/participants.js" defer></script>

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

        button.btn-success {
            min-width: 140px;
        }

        .new-participant-section {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 0.375rem;
            margin-bottom: 1rem;
            transition: box-shadow 0.3s ease, transform 0.3s ease;
        }
        .new-participant-section:hover {
            box-shadow: 0 0.5rem 1rem rgb(0 0 0 / 0.1);
            transform: translateY(-2px);
        }

        .table th, .table td {
            vertical-align: middle;
        }

        .form-check-input {
            margin-top: 0;
        }
    </style>
</@layout.page>