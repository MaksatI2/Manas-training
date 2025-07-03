$(document).ready(function() {
    let courseInstanceId = null;
    const $table = $('#courseInstancesTable');
    const $confirmDeleteBtn = $('#confirmDeleteBtn');
    const $modulesList = $('#courseModulesList');
    const $deleteFormContainer = $('#deleteFormContainer');

    $table.on('click', 'button.btn-danger', function(e) {
        e.preventDefault();
        e.stopPropagation();

        courseInstanceId = $(this).data('id');
        if (!courseInstanceId) {
            alert('Неверный ID потока курса');
            return;
        }

        const modal = new bootstrap.Modal(document.getElementById('deleteCourseInstanceModal'));
        modal.show();

        $modulesList.html('<li class="list-group-item text-center text-muted">Загрузка модулей...</li>');

        $.ajax({
            url: `/api/courses/${courseInstanceId}/modules`,
            method: 'GET',
            dataType: 'json',
            success: function(modules) {
                if (!modules || modules.length === 0) {
                    $modulesList.html('<li class="list-group-item text-center text-muted">Модули отсутствуют.</li>');
                    $confirmDeleteBtn.prop('disabled', false).text('Удалить поток курса');
                } else {
                    $modulesList.empty();
                    modules.forEach(function(m) {
                        const duration = m.durationHours ?? '—';
                        const order = m.orderIndex ?? '—';
                        $modulesList.append(
                            `<li class="list-group-item"><strong>${m.title}</strong> — ${duration} ч., порядок: ${order}</li>`
                        );
                    });
                    $confirmDeleteBtn.prop('disabled', true).text('Удаление невозможно — есть модули');
                }
            },
            error: function() {
                $modulesList.html('<li class="list-group-item text-danger text-center">Ошибка при загрузке модулей.</li>');
                $confirmDeleteBtn.prop('disabled', true).text('Невозможно проверить модули');
            }
        });

        const csrfToken = $('meta[name="_csrf"]').attr('content');
        const formHtml = `
            <form id="deleteCourseInstanceForm" method="POST" action="/admin/course-instances/${courseInstanceId}/delete">
                <input type="hidden" name="_csrf" value="${csrfToken}">
            </form>
        `;
        $deleteFormContainer.html(formHtml);
    });

    $confirmDeleteBtn.on('click', function() {
        if (!courseInstanceId) return;
        if ($(this).prop('disabled')) return;

        $('#deleteCourseInstanceForm').submit();
    });

    $table.on('click', 'tr', function(e) {
        if ($(e.target).closest('button, a').length > 0) return;

        const instanceId = $(this).data('id');
        if (instanceId) {
            window.location.href = `/admin/course-instances/${instanceId}`;
        }
    });
});
