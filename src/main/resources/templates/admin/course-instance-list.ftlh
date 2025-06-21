<#import "../layout.ftlh" as layout>
<@layout.page>
    <div class="card shadow mb-4">
        <#if successMessage??>
            <div id="successMessage" data-message="${successMessage?js_string}"></div>
        </#if>
        <#if errorMessage??>
            <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
        </#if>
        <div class="card-header py-3 d-flex justify-content-between align-items-center" style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-book me-2"></i>
                Управление потоками курсов
            </h5>
            <div>
                <a href="/admin/course-instances/create" class="btn btn-light btn-sm" style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-plus me-1" style="color: #0066cc;"></i> Добавить поток курса
                </a>
            </div>
        </div>
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-3">
                    <div class="input-group">
                        <span class="input-group-text" style="background: #0066cc; color: white;"><i class="fas fa-filter"></i></span>
                        <select class="form-select form-select-sm" id="statusFilter">
                            <option value="">Все статусы</option>
                            <option value="Активен">Активен</option>
                            <option value="Неактивен">Неактивен</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-9 d-flex justify-content-end align-items-center">
                    <div id="courseInstancesTable_info" class="text-muted small me-3" style="color: #2c3e50 !important;"></div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="courseInstancesTable" width="100%" cellspacing="0">
                    <thead style="background: linear-gradient(135deg, #0066cc, #003d7a); color: white;">
                    <tr>
                        <th>ID</th>
                        <th>Курс</th>
                        <th>Название потока</th>
                        <th>Дата начала</th>
                        <th>Дата окончания</th>
                        <th>Статус</th>
                        <th>Действия</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if courseInstances?has_content>
                        <#list courseInstances as instance>
                            <tr>
                                <td>${instance.id}</td>
                                <td>${instance.title!"-"}</td>
                                <td>${instance.title}</td>
                                <td>${instance.startDate}</td>
                                <td>${instance.endDate}</td>
                                <td>
                                    <#if instance.isActive>
                                        <span class="badge bg-success">Активен</span>
                                    <#else>
                                        <span class="badge bg-warning">Неактивен</span>
                                    </#if>
                                </td>
                                <td>
                                    <a href="/admin/course-instances/${instance.id}" class="btn btn-sm btn-info" title="Просмотр">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="/admin/course-instances/${instance.id}/edit" class="btn btn-sm btn-primary" title="Редактировать">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="/admin/course-instances/${instance.id}/delete" class="btn btn-sm btn-danger" title="Удалить"
                                       onclick="return confirm('Вы уверены, что хотите удалить этот поток курса?')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">
                                <i class="fas fa-book fa-2x mb-2"></i>
                                <p>Потоки курсов не найдены</p>
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>
            </div>

            <div class="row mt-3">
                <div class="col-md-6">
                    <div id="courseInstancesTable_paginate" class="dataTables_paginate"></div>
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

    <script>
        $(document).ready(function() {
            var table = $('#courseInstancesTable').DataTable({
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
                dom: '<"top"Bf>rt<"bottom"lip><"clear">',
                buttons: [
                    {
                        extend: 'collection',
                        text: '<i class="fas fa-download me-1"></i> Экспорт',
                        className: 'btn btn-primary btn-sm dropdown-toggle',
                        buttons: [
                            {
                                extend: 'copy',
                                text: '<i class="fas fa-copy me-1"></i> Копировать',
                                className: 'dropdown-item',
                                exportOptions: {
                                    columns: ':visible'
                                },
                                title: 'Список потоков курсов',
                                messageTop: 'Список потоков курсов на ' + new Date().toLocaleDateString()
                            },
                            {
                                extend: 'excel',
                                text: '<i class="fas fa-file-excel me-1"></i> Excel',
                                className: 'dropdown-item',
                                exportOptions: {
                                    columns: ':visible'
                                },
                                title: 'Список потоков курсов',
                                messageTop: 'Список потоков курсов на ' + new Date().toLocaleDateString(),
                                autoFilter: true,
                                customize: function(xlsx) {
                                    var sheet = xlsx.xl.worksheets['sheet1.xml'];
                                    $('row c[r^="A"]', sheet).attr('s', '2');
                                }
                            },
                            {
                                extend: 'pdf',
                                text: '<i class="fas fa-file-pdf me-1"></i> PDF',
                                className: 'dropdown-item',
                                exportOptions: {
                                    columns: ':visible'
                                },
                                title: 'Список потоков курсов Manas - ' + new Date().toLocaleDateString(),
                                customize: function(doc) {
                                    if (!doc.content || doc.content.length < 2 || !doc.content[1].table) {
                                        console.error('PDF generation error: Invalid document structure', doc);
                                        return;
                                    }
                                    doc.defaultStyle = {
                                        fontSize: 8,
                                        color: '#2c3e50'
                                    };
                                    doc.styles.title = {
                                        color: '#0066cc',
                                        fontSize: 14,
                                        alignment: 'center',
                                        margin: [0, 0, 0, 15]
                                    };
                                    const table = doc.content[1].table;
                                    table.widths = Array(table.body[0].length).fill('*');
                                    table.body[0].forEach(function(cell) {
                                        cell.fillColor = '#003d7a';
                                        cell.color = '#ffffff';
                                        cell.alignment = 'center';
                                        cell.bold = true;
                                    });
                                    for (let i = 1; i < table.body.length; i++) {
                                        if (i % 2 === 0) {
                                            table.body[i].forEach(function(cell) {
                                                cell.fillColor = '#f8f9fa';
                                            });
                                        }
                                    }
                                    doc.pageMargins = [20, 60, 20, 30];
                                },
                                orientation: 'landscape'
                            },
                            {
                                extend: 'print',
                                text: '<i class="fas fa-print me-1"></i> Печать',
                                className: 'dropdown-item',
                                exportOptions: {
                                    columns: ':visible'
                                },
                                title: 'Список потоков курсов',
                                messageTop: '<h3 class="text-center">Список потоков курсов</h3><p class="text-center">На ' + new Date().toLocaleDateString() + '</p>',
                                customize: function(win) {
                                    $(win.document.body).find('table').addClass('display').css('font-size', '10px');
                                    $(win.document.body).find('tr:nth-child(odd) td').each(function(index){
                                        $(this).css('background-color','#f8f9fa');
                                    });
                                    $(win.document.body).find('h1').css('text-align','center');
                                }
                            }
                        ]
                    }
                ],
                columnDefs: [
                    {
                        targets: [1, 2, 3, 4, 5],
                        orderable: true,
                        searchable: true
                    },
                    {
                        targets: [6],
                        orderable: false,
                        searchable: false
                    }
                ],
                initComplete: function() {
                    this.api().page.len(10).draw();
                    $('.dt-buttons').appendTo('.col-md-9.d-flex');
                }
            });

            $('#statusFilter').on('change', function() {
                table.column(5).search(this.value).draw();
            });

            $('.dataTables_paginate').addClass('pagination');
            $('.paginate_button').addClass('page-item');
            $('.paginate_button a').addClass('page-link');

            table.on('draw', function() {
                $('.paginate_button').removeClass('disabled active');
                $('.paginate_button.current').addClass('active');
            });

            $('.dt-buttons').addClass('btn-group');
            $('.dt-button').addClass('btn').removeClass('dt-button');
            $('.dropdown-toggle').dropdown();
        });
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

        #courseInstancesTable,
        #usersTable {
            width: 100%;
            margin-bottom: 1rem;
            color: #2c3e50;
            border-collapse: separate;
            border-spacing: 0;
        }

        #courseInstancesTable th,
        #usersTable th {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            color: white;
            padding: 0.75rem;
            vertical-align: middle;
            border: none;
            font-weight: 600;
        }

        #courseInstancesTable td,
        #usersTable td {
            padding: 0.75rem;
            vertical-align: middle;
            border-top: 1px solid #e3e6f0;
            border-bottom: 1px solid #e3e6f0;
        }

        #courseInstancesTable tr:hover,
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

        .bg-primary {
            background-color: #0066cc !important;
        }

        .bg-success {
            background-color: #28a745 !important;
        }

        .bg-warning {
            background-color: #ffc107 !important;
            color: #212529 !important;
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

        .input-group-text {
            background: #0066cc;
            border: 1px solid #0066cc;
            color: white;
        }

        .form-select {
            border-left: 0;
            border-color: #d1d3e2;
        }

        .form-select:focus {
            box-shadow: none;
            border-color: #d1d3e2;
        }

        .btn-light {
            transition: all 0.3s ease;
        }

        .btn-light:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
        }

        .dt-buttons {
            margin-bottom: 0;
            margin-left: 15px;
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.375rem;
            margin-right: 0.25rem;
            transition: all 0.3s ease;
        }

        .btn-sm:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
        }

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .btn-info {
            background-color: #17a2b8;
            border-color: #17a2b8;
        }

        .btn-primary {
            background-color: #0066cc;
            border-color: #0066cc;
        }

        .form-select-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.375rem;
            border: 1px solid #ced4da;
            background-color: white;
            color: #495057;
        }

        .form-select-sm:focus {
            border-color: #0066cc;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(0, 102, 204, 0.25);
        }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .dropdown-menu {
            border-radius: 0.375rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(0, 0, 0, 0.1);
        }

        .dropdown-item {
            padding: 0.25rem 1rem;
            font-size: 0.875rem;
            color: #212529;
        }

        .dropdown-item:hover {
            background-color: #f8f9fa;
            color: #0066cc;
        }

        .dropdown-item i {
            width: 18px;
            text-align: center;
            margin-right: 5px;
        }

        @media (max-width: 768px) {
            .card-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .card-header h5 {
                margin-bottom: 1rem;
                font-size: 1.25rem;
            }
            .dt-buttons {
                flex-wrap: wrap;
                margin-left: 0;
                margin-top: 10px;
            }
            .btn-sm {
                margin-bottom: 0.5rem;
            }
            .row.mb-3 {
                flex-direction: column;
            }
            .row.mb-3 .col-md-3,
            .row.mb-3 .col-md-6 {
                width: 100%;
                margin-bottom: 1rem;
            }
            .col-md-6.d-flex {
                justify-content: flex-start !important;
                margin-top: 1rem;
                flex-direction: column;
            }
        }

    </style>
</@layout.page>