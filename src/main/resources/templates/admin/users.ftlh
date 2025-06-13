<#import "../layout.ftlh" as layout>
<@layout.page>
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center" style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <h5 class="m-0 font-weight-bold text-white">Управление пользователями</h5>
            <div>
                <a href="/admin/teachers/add" class="btn btn-light btn-sm" style="border-radius: 25px; background: white; color: #0066cc;">
                    <i class="fas fa-plus me-1" style="color: #0066cc;"></i> Добавить преподавателя
                </a>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="usersTable" width="100%" cellspacing="0">
                    <thead style="background: linear-gradient(135deg, #0066cc, #003d7a); color: white;">
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
            var table = $('#usersTable').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/ru.json'
                },
                responsive: true,
                pageLength: 10,
                lengthChange: true,
                lengthMenu: [[5, 10, 25, 50, 100, -1], [5, 10, 25, 50, 100, "Все"]],
                order: [[0, 'asc']],
                searching: true,
                info: true,
                paging: true,
                autoWidth: false,
                stateSave: true,
                dom: '<"top"f>rt<"bottom"lip><"clear">',
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
                initComplete: function() {
                    this.api().page.len(10).draw();
                }
            });

            $('.dataTables_paginate').addClass('pagination');
            $('.paginate_button').addClass('page-item');
            $('.paginate_button a').addClass('page-link');
            $('.dt-buttons').addClass('mb-3');
            $('.dt-button').removeClass('dt-button');

            table.on('draw', function() {
                $('.paginate_button').removeClass('disabled active');
                $('.paginate_button.current').addClass('active');
            });
        });
    </script>

    <style>
        .card-header {
            border-bottom: none;
        }

        .table-responsive {
            overflow-x: auto;
            border-radius: 10px;
        }

        #usersTable {
            width: 100%;
            margin-bottom: 1rem;
            color: #2c3e50;
            border-collapse: separate;
            border-spacing: 0;
        }

        #usersTable th {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            color: white;
            padding: 0.75rem;
            vertical-align: middle;
            border: none;
            font-weight: 600;
        }

        #usersTable td {
            padding: 0.75rem;
            vertical-align: middle;
            border-top: 1px solid #e3e6f0;
            border-bottom: 1px solid #e3e6f0;
        }

        #usersTable tr:hover {
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

        .pagination {
            display: flex;
            padding-left: 0;
            list-style: none;
            border-radius: 25px;
        }

        .page-item:first-child .page-link {
            margin-left: 0;
            border-top-left-radius: 25px;
            border-bottom-left-radius: 25px;
        }

        .page-item:last-child .page-link {
            border-top-right-radius: 25px;
            border-bottom-right-radius: 25px;
        }

        .page-item.active .page-link {
            z-index: 1;
            color: #fff;
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }

        .page-link {
            position: relative;
            display: block;
            padding: 0.5rem 0.75rem;
            margin-left: -1px;
            line-height: 1.25;
            color: #0066cc;
            background-color: #fff;
            border: 1px solid #dddfeb;
        }

        .page-link:hover {
            z-index: 2;
            color: #003d7a;
            text-decoration: none;
            background-color: rgba(0,102,204,0.1);
            border-color: #dddfeb;
        }

        .btn-light {
            transition: all 0.3s ease;
        }

        .btn-light:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
        }


        @media (max-width: 768px) {
            .card-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .card-header h5 {
                margin-bottom: 1rem;
                font-size: 2rem;
            }
        }
    </style>
</@layout.page>