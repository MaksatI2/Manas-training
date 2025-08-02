<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>

<@layout.page title="Сертификаты">

    <@roadmap.breadcrumbs items=[
    {"label":"Главная","url":"/"},
    {"label":"Сертификаты","url":""}
    ]/>

    <div class="card shadow mb-4">
        <div class="card-header d-flex align-items-center justify-content-between filter-panel">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-certificate me-2"></i>Сертификаты
            </h5>
            <div class="input-group custom-filter" style="max-width:300px;">
                <span class="input-group-text"><i class="fas fa-search"></i></span>
                <input id="certSearch" type="text" class="form-control" placeholder="Поиск по имени или email"/>
            </div>
        </div>

        <div class="card-body">
            <div class="table-responsive">
                <table id="certificatesTable"
                       class="table table-bordered table-hover"
                       width="100%">
                    <thead style="background: linear-gradient(135deg, #0066cc, #003d7a); color: #fff;">
                    <tr>
                        <th>Студент</th>
                        <th>Email</th>
                        <th>Завершено курсов</th>
                        <th>Действие</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if studentsPage.content?has_content>
                        <#list studentsPage.content as student>
                            <tr>
                                <td>${student.name} ${student.lastName}</td>
                                <td>${student.email}</td>
                                <td>
                                    ${student.completedCoursesCount}
                                </td>
                                <td class="text-center">
                                    <a href="/admin/certificate/detail?studentId=${student.id}"
                                       class="btn btn-sm btn-info">
                                        <i class="fas fa-info-circle"></i> Подробнее
                                    </a>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                          <tr>
                            <td colspan="4" class="text-center text-muted py-4">
                              На данной странице пока ещё отсутствуют студенты.
                            </td>
                          </tr>
                    </#if>
                    </tbody>
                </table>
            </div>

            <div class="row mt-3 align-items-center">
                <div class="col-md-6">
                    <div id="certificatesTable_info" class="text-muted small">
                        Показаны
                        ${(studentsPage.number * studentsPage.size) + 1}
                        –
                        ${(studentsPage.number * studentsPage.size) + studentsPage.numberOfElements}
                        из ${studentsPage.totalElements}
                    </div>
                </div>
                <div class="col-md-6 d-flex justify-content-end">
                    <nav aria-label="Пагинация">
                        <ul class="pagination mb-0">
                            <#list 0..<studentsPage.totalPages as i>
                                <li class="page-item ${(i == studentsPage.number)?then('active','')}">
                                    <a class="page-link" href="?page=${i}&size=${studentsPage.size}">
                                        ${i + 1}
                                    </a>
                                </li>
                            </#list>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>

    <script>
        $(function() {
            $.fn.dataTable.ext.errMode = 'none';

            var table = $('#certificatesTable').DataTable({
                language: {
                    url: '/js/datatables/ru.json',
                    zeroRecords: 'На данной странице пока ещё отсутствуют студенты',
                    emptyTable:  'На данной странице пока ещё отсутствуют студенты',
                    paginate:    { previous: '‹', next: '›' }
                },
                responsive:  true,
                searching:   true,
                paging:      false,
                info:        false,
                autoWidth:   false,
                dom:         'rtip',
                columnDefs: [
                    { width: '25%' },
                    { width: '25%' },
                    { width: '25%' },
                    { width: '25%', orderable: false, searchable: false }
                ]
            });

            $('#certSearch').on('keyup', function() {
                table.search(this.value).draw();
            });
        });
    </script>

    <style>
        :root {
            --primary-blue: #0066cc;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
        }

        .filter-panel {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            border-radius: 15px 15px 0 0;
            padding: 1rem;
        }
        .custom-filter .input-group-text {
            background: transparent;
            border: none;
            color: white;
        }
        .custom-filter .form-control {
            border: none;
            min-width: 200px;
        }
        .card {
            border-radius: 12px;
        }
        .pagination .active .page-link {
            background-color: var(--primary-blue) !important;
            border-color: var(--primary-blue) !important;
            color: #fff !important;
        }

        #certificatesTable {
            width: 100% !important;
            table-layout: fixed;
        }
    </style>

</@layout.page>
