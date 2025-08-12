$(document).ready(function () {
    const t = (k, params = {}) => {
        const s = (window.APP_MESSAGES && window.APP_MESSAGES[k]) || k;
        return s.replace(/{(\w+)}/g, (_, p) => (params[p] != null ? params[p] : ''));
    };

    let courseInstanceId = null;
    const $table = $('#courseInstancesTable');
    const $confirmDeleteBtn = $('#confirmDeleteBtn');
    const $modulesList = $('#courseModulesList');
    const $deleteFormContainer = $('#deleteFormContainer');

    $table.on('click', 'button.btn-danger', function (e) {
        e.preventDefault();
        e.stopPropagation();

        courseInstanceId = $(this).data('id');
        if (!courseInstanceId) {
            alert(t('js.instance_list.alert.invalidId'));
            return;
        }

        const modal = new bootstrap.Modal(document.getElementById('deleteCourseInstanceModal'));
        modal.show();

        $modulesList.html(`<li class="list-group-item text-center text-muted">${t('js.instance_list.loading')}</li>`);

        $.ajax({
            url: `/api/courses/${courseInstanceId}/modules`,
            method: 'GET',
            dataType: 'json',
            success: function (modules) {
                if (!modules || modules.length === 0) {
                    $modulesList.html(`<li class="list-group-item text-center text-muted">${t('js.instance_list.empty')}</li>`);
                    $confirmDeleteBtn.prop('disabled', false).text(t('js.instance_list.btn.delete'));
                } else {
                    $modulesList.empty();
                    modules.forEach(function (m) {
                        const duration = (m.durationHours ?? t('js.instance_list.dash')) + (m.durationHours != null ? ` ${t('js.instance_list.hours.suffix')}` : '');
                        const order = m.orderIndex ?? t('js.instance_list.dash');
                        $modulesList.append(
                            `<li class="list-group-item"><strong>${m.title}</strong> — ${duration}, ${t('js.instance_list.order.label')}: ${order}</li>`
                        );
                    });
                    $confirmDeleteBtn.prop('disabled', true).text(t('js.instance_list.btn.disabledHasModules'));
                }
            },
            error: function () {
                $modulesList.html(`<li class="list-group-item text-danger text-center">${t('js.instance_list.error.load')}</li>`);
                $confirmDeleteBtn.prop('disabled', true).text(t('js.instance_list.error.cannotCheck'));
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

    $confirmDeleteBtn.on('click', function () {
        if (!courseInstanceId) return;
        if ($(this).prop('disabled')) return;
        $('#deleteCourseInstanceForm').submit();
    });

    $table.on('click', 'tr', function (e) {
        if ($(e.target).closest('button, a').length > 0) return;
        const instanceId = $(this).data('id');
        if (instanceId) {
            window.location.href = `/admin/course-instances/${instanceId}`;
        }
    });
});
