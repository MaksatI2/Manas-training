<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring />

<@layout.page>
    <div class="container">
        <h2 class="section-title">Редактировать поток курса</h2>
        <div class="card feature-card-enhanced">
            <div class="card-body">
                <form action="/admin/course-instances/${courseInstanceDto.id}/edit" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="mb-3">
                        <label for="title" class="form-label">
                            <i class="fas fa-heading me-1"></i>Название *
                        </label>
                        <@spring.formInput "courseInstanceDto.title", "class='form-control' id='title'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "title", "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="startDate" class="form-label">
                            <i class="fas fa-calendar-alt me-1"></i>Дата начала *
                        </label>
                        <@spring.formInput "courseInstanceDto.startDate", "class='form-control' id='startDate' type='text' autocomplete='off'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "startDate", "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="endDate" class="form-label">
                            <i class="fas fa-calendar-alt me-1"></i>Дата окончания *
                        </label>
                        <@spring.formInput "courseInstanceDto.endDate", "class='form-control' id='endDate' type='text' autocomplete='off'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "endDate", "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="isActive" class="form-label">
                            <i class="fas fa-toggle-on me-1"></i>Активен
                        </label>
                        <@spring.formCheckbox "courseInstanceDto.isActive", "class='form-check-input' id='isActive'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "isActive", "error-message" />
                        </div>
                    </div>

                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save me-2"></i>Сохранить изменения
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            flatpickr("#startDate", {
                dateFormat: "Y-m-d",
                minDate: "today",
                defaultDate: "${courseInstanceDto.startDate!}"
            });

            flatpickr("#endDate", {
                dateFormat: "Y-m-d",
                minDate: "today",
                defaultDate: "${courseInstanceDto.endDate!}"
            });
        });
    </script>

</@layout.page>
