<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": "/teacher/my-courses"},
    {"label": "Тесты для курса: ${course.title}", "url": ""}
    ] />
    <div class="card shadow mb-4">
            <#if successMessage??>
                <div id="successMessage" data-message="${successMessage?js_string}"></div>
            </#if>
            <#if errorMessage??>
                <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
            </#if>
        <div class="card-header py-3" style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <h5 class="m-0 font-weight-bold text-white">
                    <i class="fa-solid fa-list-check"></i> Управление тестами курса
                </h5>

                <div class="d-flex align-items-center flex-wrap gap-2">
                    <div id="usersTable_buttons"></div>


                    <a href="/test/create/${course.id}" class="btn btn-light btn-sm"
                       style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                        <i class="fas fa-plus me-1"></i> Создать новый тест
                    </a>
                </div>
            </div>
        </div>

        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="testsTable" width="100%" cellspacing="0">
                    <thead style="background: linear-gradient(135deg, #0066cc, #003d7a); color: white;">
                    <tr>
                        <th>Тест</th>
                        <th>Курс</th>
                        <th>Проходной балл</th>
                        <th>Количество вопросв</th>
                        <th>Статус</th>
                        <th class="text-center">Действия</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if tests?has_content>
                        <#list tests as test>
                            <tr style="cursor: pointer;" onclick="window.location.href='/test/${test.id}/details'">
                                <td>${test.title}</td>
                                <td>${test.course.title}</td>
                                <td>${test.passingScore}</td>
                                <td>${test.questions?size}</td>
                                <td>
                                    <#if test.isActive>
                                        <span class="badge bg-success">Активен</span>
                                    <#else>
                                        <span class="badge bg-warning">Неактивен</span>
                                    </#if>
                                </td>
                                <td class="text-center">
                                        <#if !test.isActive>
                                            <a href="/test/${test.id}/activate"
                                               class="btn btn-sm btn-success"
                                               title="Активировать">
                                                <i class="fas fa-check"></i>
                                            </a>
                                        <#else>
                                            <a href="/test/${test.id}/deactivate"
                                               class="btn btn-sm btn-warning"
                                               title="Деактивировать">
                                                <i class="fas fa-ban"></i>
                                            </a>
                                        </#if>
                                        <a href="/test/${test.id}/edit"
                                           class="btn btn-sm btn-warning"
                                           title="Редактировать">
                                            <i class="fa-solid fa-pencil"></i>
                                        </a>
                                    <a href="/test/${test.id}/delete" class="btn btn-sm btn-danger delete-user-btn"
                                            title="Удалить">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">
                                <i class="fas fa-users fa-2x mb-2"></i>
                                <p>Тестов по данному курсу не найдено</p>
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>
            </div>

            <div class="row mt-3">
                <div class="col-md-6">
                    <div id="usersTable_paginate" class="dataTables_paginate"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>

    </script>

    <style>
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
        }

        .card-header {
            border-bottom: none;
        }

        .table-responsive {
            overflow-x: auto;
            border-radius: 10px;
        }

        #testsTable {
            width: 100%;
            margin-bottom: 1rem;
            color: #2c3e50;
            border-collapse: separate;
            border-spacing: 0;
        }

        #testsTable th {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            color: white;
            padding: 0.75rem;
            vertical-align: middle;
            border: none;
            font-weight: 600;
        }

        #testsTable td {
            padding: 0.75rem;
            vertical-align: middle;
            border-top: 1px solid #e3e6f0;
            border-bottom: 1px solid #e3e6f0;
        }

        #testsTable tr:hover {
            background-color: rgba(0,102,204,0.05);
            transform: translateY(-1px);
            transition: all 0.3s ease;
        }

        .badge {
            display: inline-block;
            padding: 0.35em 0.65em;
            font-size: 0.75em;
            font-weight: 700;
            line-height: 1;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: 0.375rem;
        }

        .bg-success {
            background-color: #28a745 !important;
        }

        .bg-warning {
            background-color: #ffc107 !important;
            color: #212529 !important;
        }
    </style>

</@layout.page>