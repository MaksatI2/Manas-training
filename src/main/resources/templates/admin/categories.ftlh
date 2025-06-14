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
                <i class="fas fa-folder me-2"></i>
                Управление категориями
            </h5>
            <a href="/admin/categories/add" class="btn btn-light">
                <i class="fas fa-plus me-2"></i>Добавить категорию
            </a>
        </div>
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-9 d-flex justify-content-end align-items-center">
                    <div id="categoriesTable_info" class="text-muted small me-3" style="color: #2c3e50 !important;"></div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="categoriesTable" width="100%" cellspacing="0">
                    <thead style="background: linear-gradient(135deg, #0066cc, #003d7a); color: white;">
                    <tr>
                        <th>Название</th>
                        <th>Описание</th>
                        <th>Действия</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list categories as category>
                        <tr onclick="window.location.href='/admin/categories/edit/${category.id}'" style="cursor: pointer;">
                            <td>
                                <span class="badge" style="background: #003d7a; color: white;">${category.name}</span>
                            </td>
                            <td style="color: #2c3e50;">${category.description!''}</td>
                            <td>
                                <form action="/admin/categories/delete/${category.id}" method="post" style="display: inline;">
                                    <#if _csrf??>
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    </#if>
                                    <button type="submit" class="btn btn-sm" style="background: #dc3545; color: white; border: none;"
                                            onclick="event.stopPropagation(); return confirm('Вы уверены, что хотите удалить категорию?')">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>

            <div class="row mt-3">
                <div class="col-md-6">
                    <div id="categoriesTable_paginate" class="dataTables_paginate"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.html5.min.js"></script>

    <script>
        $(document).ready(function() {
            var table = $('#categoriesTable').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/ru.json'
                },
                dom: '<"top"f>rt<"bottom"lip><"clear">',
                buttons: [],
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
                initComplete: function() {
                    this.api().page.len(10).draw();
                }
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

        #categoriesTable {
            width: 100%;
            margin-bottom: 1rem;
            color: #2c3e50;
            border-collapse: separate;
            border-spacing: 0;
        }

        #categoriesTable th {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            color: white;
            padding: 0.75rem;
            vertical-align: middle;
            border: none;
            font-weight: 600;
        }

        #categoriesTable td {
            padding: 0.75rem;
            vertical-align: middle;
            border-top: 1px solid #e3e6f0;
            border-bottom: 1px solid #e3e6f0;
        }

        #categoriesTable tr:hover {
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

        .export-btn {
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
            background: #f0f0f0;
            color: #333;
            border: 1px solid #ddd;
            transition: all 0.3s ease;
        }

        .export-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.2);
        }

        .excel-btn {
            background: #1d6f42;
            color: white;
            border: 1px solid #1a633b;
        }

        .excel-btn:hover {
            background: #155e37;
            color: white;
        }

        .pdf-btn {
            background: #d30f0f;
            color: white;
            border: 1px solid #c00;
        }

        .pdf-btn:hover {
            background: #b50d0d;
            color: white;
        }

        .btn-sm {
            transition: all 0.3s ease;
        }

        .btn-sm:hover {
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

            .btn-light {
                margin-top: 1rem;
            }

            .row.mb-3 {
                flex-direction: column;
            }

            .col-md-9 {
                width: 100%;
                max-width: 100%;
                margin-top: 1rem;
                justify-content: flex-start!important;
            }
        }
    </style>
</@layout.page>