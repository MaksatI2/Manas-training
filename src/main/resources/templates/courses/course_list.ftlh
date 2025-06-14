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
                <i class="fas fa-graduation-cap me-2"></i>
                Каталог курсов
            </h5>
        </div>
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-3">
                    <div class="input-group">
                        <span class="input-group-text" style="background: #0066cc; color: white;"><i class="fas fa-filter"></i></span>
                        <select id="categoryFilter" class="form-select">
                            <option value="">Все категории</option>
                            <#list categories as category>
                                <option value="${category.name}">${category.name}</option>
                            </#list>
                        </select>
                    </div>
                </div>
                <div class="col-md-9 d-flex justify-content-end align-items-center">
                    <div id="coursesTable_info" class="text-muted small me-3" style="color: #2c3e50 !important;"></div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="coursesTable" width="100%" cellspacing="0">
                    <thead style="background: linear-gradient(135deg, #0066cc, #003d7a); color: white;">
                    <tr>
                        <th>ID</th>
                        <th>Название</th>
                        <th>Код курса</th>
                        <th>Категория</th>
                        <th>Длительность</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if courses?has_content>
                        <#list courses as course>
                            <tr style="cursor: pointer;" onclick="window.location.href='/courses/${course.id}'">
                                <td>${course.id}</td>
                                <td>${course.title}</td>
                                <td>
                                    <span class="badge" style="background: #87ceeb; color: #2c3e50;">${course.code}</span>
                                </td>
                                <td>
                                    <span class="badge" style="background: #003d7a; color: white;">${course.category.name}</span>
                                </td>
                                <td>
                                    <i class="fas fa-clock me-1" style="color: #0066cc;"></i>${course.duration}
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="5" class="text-center text-muted py-4">
                                <i class="fas fa-graduation-cap fa-2x mb-2" style="color: #0066cc;"></i>
                                <p style="color: #2c3e50;">Курсы не найдены</p>
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>
            </div>

            <div class="row mt-3">
                <div class="col-md-6">
                    <div id="coursesTable_paginate" class="dataTables_paginate"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>

    <script>
        $(document).ready(function() {
            var table = $('#coursesTable').DataTable({
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
                initComplete: function() {
                    this.api().page.len(10).draw();
                }
            });

            $('#categoryFilter').on('change', function() {
                table.column(3).search(this.value).draw();
            });

            $('.dataTables_paginate').addClass('pagination');
            $('.paginate_button').addClass('page-item');
            $('.paginate_button a').addClass('page-link');

            table.on('draw', function() {
                $('.paginate_button').removeClass('disabled active');
                $('.paginate_button.current').addClass('active');
            });
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

        #coursesTable {
            width: 100%;
            margin-bottom: 1rem;
            color: #2c3e50;
            border-collapse: separate;
            border-spacing: 0;
        }

        #coursesTable th {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            color: white;
            padding: 0.75rem;
            vertical-align: middle;
            border: none;
            font-weight: 600;
        }

        #coursesTable td {
            padding: 0.75rem;
            vertical-align: middle;
            border-top: 1px solid #e3e6f0;
            border-bottom: 1px solid #e3e6f0;
        }

        #coursesTable tr:hover {
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

        @media (max-width: 768px) {
            .card-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .card-header h5 {
                margin-bottom: 1rem;
                font-size: 2rem;
            }

            .row.mb-3 {
                flex-direction: column;
            }

            .col-md-3, .col-md-9 {
                width: 100%;
                max-width: 100%;
            }

            .col-md-9 {
                margin-top: 1rem;
                justify-content: flex-start!important;
            }
        }
    </style>
</@layout.page>