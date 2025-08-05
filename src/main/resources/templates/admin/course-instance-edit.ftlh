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
                            Название *
                        </label>
                        <@spring.formInput "courseInstanceDto.title", "class='form-control' id='title'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "title", "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="startDate" class="form-label">
                            Дата начала *
                        </label>
                        <@spring.formInput "courseInstanceDto.startDate", "class='form-control' id='startDate' type='text' autocomplete='off'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "startDate", "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="endDate" class="form-label">
                            Дата окончания *
                        </label>
                        <@spring.formInput "courseInstanceDto.endDate", "class='form-control' id='endDate' type='text' autocomplete='off'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "endDate", "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="form-check form-switch">
                            <@spring.formCheckbox "courseInstanceDto.isActive", "class='form-check-input' id='isActive', name='isActive'"/>

                            <label class="form-check-label" for="isActive">
                                Активный курс
                            </label>
                            <div class="error-block text-danger">
                                <@spring.showErrors "isActive", "error-message" />
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Сохранить изменения
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
    <style>
        .required::after {
            content: " *";
            color: #dc3545;
        }

        .card {
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #ced4da;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0066cc;
            box-shadow: 0 0 0 0.2rem rgba(0, 102, 204, 0.25);
        }

        .btn {
            border-radius: 8px;
            padding: 0.5rem 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
        }

        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        .btn-secondary:hover {
            background-color: #545b62;
            transform: translateY(-1px);
        }

        .form-check-input:checked {
            background-color: #0066cc;
            border-color: #0066cc;
        }

        .alert {
            border-radius: 8px;
            border: none;
        }

        .form-text {
            font-size: 0.875rem;
            color: #6c757d;
        }

        .gap-2 {
            gap: 0.5rem;
        }
    </style>
</@layout.page>
