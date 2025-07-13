<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#setting date_format="yyyy-MM-dd">

<@layout.page title="Редактировать заявку">
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои заявки", "url": "/applications/student/applications"},
    {"label": "Редактировать заявку", "url": ""}
    ] />

    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center"
             style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-edit me-2"></i> Редактировать заявку на курс
            </h5>
            <a href="/applications/student/applications" class="btn btn-light btn-sm"
               style="border-radius: 25px; background: white; color: var(--primary-blue); border: 1px solid var(--primary-blue);">
                <i class="fas fa-arrow-left me-1" style="color: var(--primary-blue);"></i> Назад
            </a>
        </div>
        <div class="card-body">
            <form method="post">
                <input type="hidden" name="_csrf" value="${_csrf.token}"/>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="courseId" class="form-label">Курс <span class="text-danger">*</span></label>
                        <select class="form-select" id="courseId" name="courseId" required>
                            <option value="">Выберите курс</option>
                            <#list courses as course>
                                <option value="${course.id}" <#if course.id == application.courseId>selected</#if>>
                                    ${course.title}
                                </option>
                            </#list>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label for="preferredTeacherId" class="form-label">Желаемый преподаватель</label>
                        <select class="form-select" id="preferredTeacherId" name="preferredTeacherId">
                            <option value="">Не выбрано</option>
                            <#if teachers??>
                                <#list teachers as teacher>
                                    <option value="${teacher.id}" <#if (application.preferredTeacherId?? && teacher.id == application.preferredTeacherId)>selected</#if>>
                                        ${teacher.fullName} (${teacher.email})
                                    </option>
                                </#list>
                            </#if>
                        </select>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="preferredStartDate" class="form-label">Желаемая дата начала</label>
                        <input type="date" class="form-control" id="preferredStartDate"
                               name="preferredStartDate"
                               value="${application.preferredStartDate}">
                    </div>
                    <div class="col-md-6">
                        <label for="preferredEndDate" class="form-label">Желаемая дата окончания</label>
                        <input type="date" class="form-control" id="preferredEndDate"
                               name="preferredEndDate"
                               value="${application.preferredEndDate}">
                    </div>
                </div>

                <div class="d-flex justify-content-between">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Сохранить изменения
                    </button>
                </div>
            </form>
        </div>
    </div>
    <script>
        document.getElementById('courseId').addEventListener('change', function () {
            const courseId = this.value;
            const teacherSelect = document.getElementById('preferredTeacherId');
            teacherSelect.innerHTML = '<option value="">Не выбрано</option>';

            if (courseId) {
                fetch('/api/courses/' + courseId + '/teachers')
                    .then(response => response.json())
                    .then(data => {
                        data.forEach(teacher => {
                            const option = document.createElement('option');
                            option.value = teacher.id;
                            option.textContent = teacher.fullName + ' (' + teacher.email + ')';
                            teacherSelect.appendChild(option);
                        });
                        const selectedTeacherId = '${application.preferredTeacherId!"-"}';
                        if (selectedTeacherId && selectedTeacherId !== '-') {
                            teacherSelect.value = selectedTeacherId;
                        }
                    })
                    .catch(error => {
                        console.error('Ошибка при загрузке преподавателей:', error);
                    });
            }
        });

        window.addEventListener('DOMContentLoaded', function () {
            const courseSelect = document.getElementById('courseId');
            if (courseSelect.value) {
                courseSelect.dispatchEvent(new Event('change'));
            }
        });
    </script>

</@layout.page>
