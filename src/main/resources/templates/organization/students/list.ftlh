<#import "/layout.ftlh" as layout>
<#import "/RoadMap.ftlh" as roadmap>
<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Студенты", "url": ""}
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
                Студенты организации
            </h5>
            <div class="d-flex gap-2">
                <a href="/organization/students/unassigned" class="btn btn-light btn-sm"
                   style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-user-check me-1" style="color: #0066cc;"></i> Присоединить студента
                </a>
                <a href="/organization/students/add" class="btn btn-light btn-sm"
                   style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fa fa-user-plus me-1" style="color: #0066cc;"></i> Добавить студента
                </a>
            </div>
        </div>

        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="studentsTable" width="100%" cellspacing="0">
                    <thead>
                    <tr>
                        <th>ФИО</th>
                        <th>Email</th>
                        <th>Телефон</th>
                        <th>Курсы</th>
                        <th>Действия</th>
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
                            <td>${first.fullName}</td>
                            <td>${first.email}</td>
                            <td>${first.phone}</td>
                            <td>
                                <ul class="mb-0 ps-3 small">
                                    <#list courseList as c>
                                        <li>
                                            <strong>${c.courseTitle}</strong> — ${c.localizedStatus}, ${c.progress}%
                                            <#if c.finalGrade??>, оценка: ${c.finalGrade}</#if>
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
                            <td class="text-nowrap">
                                <a href="/organization/students/${sid}/edit"
                                   class="btn btn-sm btn-outline-secondary me-1">
                                    <i class="fa fa-edit"></i>
                                </a>
                                <form action="/organization/students/${sid}/delete"
                                      method="post" class="d-inline"
                                      onsubmit="return confirm('Удалить студента?')">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-sm btn-outline-danger me-1">
                                        <i class="fa fa-trash"></i>
                                    </button>
                                </form>
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
                    url: '/js/datatables/ru.json',
                    paginate: {previous: '‹', next: '›'}
                },
                responsive: true,
                pageLength: 10,
                order: [[0, 'asc']],
                autoWidth: false,
                info:false
            });
        });
    </script>

    <style>
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
    </style>
</@layout.page>
