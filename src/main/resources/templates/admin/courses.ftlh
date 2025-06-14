<#import "../layout.ftlh" as layout>

<@layout.page>
    <div class="container py-5">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h1 class="h4 mb-0">Управление курсами</h1>
                    <a href="/admin/courses/add" class="btn btn-light">
                        <i class="fas fa-plus me-2"></i>Добавить курс
                    </a>
            </div>
            <div class="card-body">
                <table id="coursesTable" class="table table-striped table-bordered" style="width:100%">
                    <thead>
                    <tr>
                        <th>Код</th>
                        <th>Название</th>
                        <th>Категория</th>
                        <th>Продолжительность (часы)</th>
                        <th>Активен</th>
                        <th>Индивидуальный</th>
                        <th>Действия</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list coursePage.content as course>
                        <tr>
                            <td>${course.code}</td>
                            <td>${course.title}</td>
                            <td>${course.category.name}</td>
                            <td>${course.duration}</td>
                            <td>${course.active?string('Да', 'Нет')}</td>
                            <td>${course.individual?string('Да', 'Нет')}</td>
                            <td>
                                <a href="/admin/courses/edit/${course.id}" class="btn btn-sm btn-primary">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="/admin/courses/delete/${course.id}" class="btn btn-sm btn-danger"
                                   onclick="return confirm('Вы уверены, что хотите удалить курс?')">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.html5.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#coursesTable').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.4/i18n/ru.json'
                },
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'copy',
                        text: '<i class="fas fa-copy"></i> Копировать',
                        className: 'btn btn-outline-primary bg-transparent btn-custom'
                    },
                    {
                        extend: 'excel',
                        text: '<i class="fas fa-file-excel"></i> Excel',
                        className: 'btn btn-outline-primary bg-transparent btn-custom'
                    },
                    {
                        extend: 'pdf',
                        text: '<i class="fas fa-file-pdf"></i> PDF',
                        className: 'btn btn-outline-primary bg-transparent btn-custom'
                    }
                ],
                pageLength: 10,
                responsive: true
            });
        });
    </script>
</@layout.page>