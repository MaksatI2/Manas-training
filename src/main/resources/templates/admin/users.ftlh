<#import "../layout.ftlh" as layout>
<@layout.page>
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h5 class="m-0 font-weight-bold text-primary">Управление пользователями</h5>
            <div>
                <a href="/admin/teachers/add" class="btn btn-primary btn-sm">
                    <i class="fas fa-plus me-1"></i> Добавить преподавателя
                </a>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="usersTable" width="100%" cellspacing="0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Имя</th>
                        <th>Фамилия</th>
                        <th>Email</th>
                        <th>Телефон</th>
                        <th>Роль</th>
                        <th>Статус</th>
                        <th>Действия</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if users?has_content>
                        <#list users as user>
                            <tr>
                                <td>${user.id}</td>
                                <td>${user.name}</td>
                                <td>${user.lastName!"-"}</td>
                                <td>${user.email}</td>
                                <td>${user.phone}</td>
                                <td>
                                    <span class="badge bg-primary">${user.role.name}</span>
                                </td>
                                <td>
                                    <#if user.isActive>
                                        <span class="badge bg-success">Активен</span>
                                    <#else>
                                        <span class="badge bg-warning">Неактивен</span>
                                    </#if>
                                </td>
                                <td>
                                    <a href="/admin/users/${user.id}" class="btn btn-sm btn-info" title="Просмотр">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <#if !user.isActive>
                                        <a href="/admin/users/${user.id}/activate"
                                           class="btn btn-sm btn-success"
                                           title="Активировать">
                                            <i class="fas fa-check"></i>
                                        </a>
                                    <#else>
                                        <a href="/admin/users/${user.id}/deactivate"
                                           class="btn btn-sm btn-warning"
                                           title="Деактивировать"
                                           onclick="return confirm('Вы уверены, что хотите деактивировать пользователя?')">
                                            <i class="fas fa-ban"></i>
                                        </a>
                                    </#if>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">
                                <i class="fas fa-users fa-2x mb-2"></i>
                                <p>Пользователи не найдены</p>
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>
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

    <script>
        $(document).ready(function() {
            $('#usersTable').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/ru.json'
                },
                responsive: true,
                pageLength: 25,
                lengthChange: true,
                lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "Все"]],
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'copy',
                        text: 'Копировать',
                        className: 'btn btn-secondary btn-sm'
                    },
                    {
                        extend: 'excel',
                        text: 'Excel',
                        className: 'btn btn-success btn-sm'
                    },
                    {
                        extend: 'pdf',
                        text: 'PDF',
                        className: 'btn btn-danger btn-sm'
                    },
                    {
                        extend: 'print',
                        text: 'Печать',
                        className: 'btn btn-info btn-sm'
                    }
                ],
                columnDefs: [
                    {
                        targets: [5, 6],
                        orderable: true,
                        searchable: true
                    },
                    {
                        targets: [7],
                        orderable: false,
                        searchable: false
                    }
                ],
                order: [[0, 'asc']],
                searching: true,
                info: true,
                paging: true,
                autoWidth: false,
                stateSave: true,
                initComplete: function() {
                    this.api().columns([5, 6]).every(function() {
                        var column = this;
                        var select = $('<select class="form-select form-select-sm"><option value="">Все</option></select>')
                            .appendTo($(column.header()))
                            .on('change', function() {
                                var val = $.fn.dataTable.util.escapeRegex(
                                    $(this).val()
                                );
                                column
                                    .search(val ? '^' + val + '$' : '', true, false)
                                    .draw();
                            });

                        column.data().unique().sort().each(function(d, j) {
                            var text = $(d).text() || d;
                            if (text && text !== '-') {
                                select.append('<option value="' + text + '">' + text + '</option>');
                            }
                        });
                    });
                }
            });

            $('.dt-buttons').addClass('mb-3');
            $('.dt-button').removeClass('dt-button');
        });
    </script>

    <style>
        .table-responsive {
            overflow-x: auto;
        }

        #usersTable {
            width: 100%;
            margin-bottom: 1rem;
            color: #212529;
        }

        #usersTable th {
            background-color: var(--primary-blue);
            color: white;
            padding: 0.75rem;
            vertical-align: top;
            border-top: 1px solid #dee2e6;
            font-weight: 600;
            position: relative;
        }

        #usersTable td {
            padding: 0.75rem;
            vertical-align: middle;
            border-top: 1px solid #dee2e6;
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
            background-color: #28a745!important;
            color: white;
        }

        .bg-warning {
            background-color: #ffc107!important;
            color: #212529;
        }

        .bg-primary {
            background-color: var(--primary-blue)!important;
            color: white;
        }

        .bg-info {
            background-color: #17a2b8!important;
            color: white;
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            line-height: 1.5;
            border-radius: 0.25rem;
        }

        .text-muted {
            color: #6c757d!important;
        }

        .py-4 {
            padding-top: 1.5rem!important;
            padding-bottom: 1.5rem!important;
        }

        .fa-2x {
            font-size: 2em;
        }

        .mb-2 {
            margin-bottom: 0.5rem!important;
        }

        /* DataTables стили */
        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_processing,
        .dataTables_wrapper .dataTables_paginate {
            color: #212529;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 0.5rem 0.75rem;
            margin-left: -1px;
            line-height: 1.25;
            color: var(--primary-blue);
            text-decoration: none;
            background-color: #fff;
            border: 1px solid #dee2e6;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current,
        .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
            background-color: var(--primary-blue);
            border-color: var(--primary-blue);
            color: white;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background-color: #e9ecef;
            border-color: #dee2e6;
        }

        .dataTables_wrapper .dataTables_filter input {
            margin-left: 0.5em;
            padding: 0.375rem 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 0.375rem;
        }

        .dataTables_wrapper .dataTables_length select {
            padding: 0.375rem 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 0.375rem;
            margin: 0 0.5em;
        }

        th select {
            width: 100%;
            margin-top: 5px;
            padding: 2px 5px;
            font-size: 12px;
            border: 1px solid #ccc;
            border-radius: 3px;
            background-color: white;
            color: #333;
        }

        .dt-buttons {
            margin-bottom: 1rem;
        }

        .dt-buttons .btn {
            margin-right: 0.5rem;
        }
    </style>
</@layout.page>