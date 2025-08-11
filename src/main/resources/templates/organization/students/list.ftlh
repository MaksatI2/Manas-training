<#import "../../layout.ftlh" as layout>
<#import "../../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>

<#assign bcHome><@spring.message code='organization.student.list.breadcrumb.home'/></#assign>
<#assign bcStudents><@spring.message code='organization.student.list.breadcrumb.students'/></#assign>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcStudents, "url": ""}
    ] />

    <div class="card shadow mb-4">
        <#if successMessage??>
            <div id="successMessage" data-message="${successMessage?js_string}"></div>
        </#if>
        <#if errorMessage??>
            <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
        </#if>

        <div class="card-header py-3 d-flex justify-content-between align-items-center"
             style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-users me-2"></i>
                <@spring.message code="organization.student.list.title"/>
            </h5>
            <div class="d-flex gap-2">
                <a href="/organization/students/unassigned" class="btn btn-light btn-sm"
                   style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-user-check me-1" style="color: #0066cc;"></i>
                    <@spring.message code="organization.student.list.button.unassigned"/>
                </a>
                <a href="/organization/students/add" class="btn btn-light btn-sm"
                   style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fa fa-user-plus me-1" style="color: #0066cc;"></i>
                    <@spring.message code="organization.student.list.button.add"/>
                </a>
            </div>
        </div>

        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="studentsTable" width="100%" cellspacing="0">
                    <thead>
                    <tr>
                        <th><@spring.message code="organization.student.list.table.fullName"/></th>
                        <th><@spring.message code="organization.student.list.table.email"/></th>
                        <th><@spring.message code="organization.student.list.table.phone"/></th>
                        <th><@spring.message code="organization.student.list.table.courses"/></th>
                        <th><@spring.message code="organization.student.list.table.actions"/></th>
                    </tr>
                    </thead>
                    <tbody>
                    <#assign grouped = {} />
                    <#list students as s>
                        <#assign sid = s.studentId?string>
                        <#assign grouped = grouped + { (sid): (grouped[sid]![]) + [s] } >
                    </#list>

                    <#list grouped?keys as sid>
                        <#assign courseList = grouped[sid]>
                        <#assign first = courseList[0]>
                        <tr>
                            <td class="field-value">${first.fullName}</td>
                            <td class="field-value">${first.email}</td>
                            <td>${first.phone}</td>
                            <td class="field-value">
                                <ul class="mb-0 ps-3 small">
                                    <#list courseList as c>
                                        <li>
                                            <strong>${c.courseTitle}</strong> — ${c.localizedStatus}, ${c.progress}%
                                            <#if c.finalGrade??>, <@spring.message code="organization.student.list.course.grade"/>: ${c.finalGrade}</#if>
                                            <#if c.enrollmentId??>
                                                <form action="/organization/students/enrollment/${c.enrollmentId}/remove"
                                                      method="post" class="d-inline">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                           value="${_csrf.token}"/>
                                                    <button type="submit"
                                                            class="btn btn-sm btn-outline-warning btn-remove-course ms-2">
                                                        <i class="fa fa-times"></i>
                                                    </button>
                                                </form>
                                            </#if>
                                        </li>
                                    </#list>
                                </ul>
                            </td>
                            <td class="text-nowrap text-center align-middle">
                                <a href="/organization/students/${sid}/edit"
                                   class="btn btn-sm btn-outline-secondary me-1" title="Редактировать">
                                    <i class="fa fa-edit"></i>
                                </a>
                                <button type="button" class="btn btn-sm btn-outline-danger me-1" data-bs-toggle="modal"
                                        data-bs-target="#deleteModal${sid}" title="Удалить">
                                    <i class="fa fa-trash"></i>
                                </button>
                                <div class="modal fade" id="deleteModal${sid}" tabindex="-1"
                                     aria-labelledby="deleteModalLabel${sid}" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <div class="modal-header bg-danger text-white">
                                                <h5 class="modal-title" id="deleteModalLabel${sid}">
                                                    <@spring.message code="organization.student.list.confirm.delete"/>
                                                </h5>
                                                <button type="button" class="btn-close btn-close-white"
                                                        data-bs-dismiss="modal" aria-label="Закрыть"></button>
                                            </div>
                                            <div class="modal-body text-break">
                                                <p class="mb-0">
                                                    Вы уверены, что хотите удалить студента
                                                    <strong class="text-danger">«${first.fullName}»</strong>?
                                                    Это действие необратимо.
                                                </p>
                                            </div>
                                            <div class="modal-footer">
                                                <form action="/organization/students/${sid}/delete" method="post">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                           value="${_csrf.token}">
                                                    <button type="button" class="btn btn-secondary"
                                                            data-bs-dismiss="modal">Отмена
                                                    </button>
                                                    <button type="submit" class="btn btn-danger">Удалить</button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>

    <script>
        $(document).ready(function () {
            $('#studentsTable').DataTable({
                language: {
                    url: '/js/datatables/${(springMacroRequestContext.locale?string?lower_case?starts_with("ru"))?then("ru",(springMacroRequestContext.locale?string?lower_case?starts_with("ky"))?then("ky","en"))}.json',
                    paginate: {previous: '‹', next: '›'}
                },
                responsive: true,
                pageLength: 10,
                order: [[0, 'asc']],
                autoWidth: false,
                info: false,
                columnDefs: [
                    {responsivePriority: 1, targets: 0},
                    {responsivePriority: 4, targets: 1},
                    {responsivePriority: 5, targets: 2},
                    {responsivePriority: 3, targets: 3},
                    {responsivePriority: 2, orderable: false, targets: 4}
                ]
            });
        });
    </script>

    <style>
        .modal-body {
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
            word-break: break-word;
        }

        .modal-dialog {
            max-width: 600px;
            width: 100%;
        }

        @media (max-width: 576px) {
            .modal-dialog {
                max-width: 90vw;
            }
        }

        thead {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            color: white;
        }

        .btn-remove-course {
            font-size: 0.7rem;
            padding: 0.2rem 0.4rem;
        }

        ul li {
            margin-bottom: 0.3rem;
        }

        .table td, .table th {
            vertical-align: middle;
        }

        .d-flex.gap-2 > * {
            margin-left: 0.5rem;
        }

        .d-flex.gap-2 > *:first-child {
            margin-left: 0;
        }

        .field-value {
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
            max-width: 100%;
        }
    </style>
</@layout.page>
