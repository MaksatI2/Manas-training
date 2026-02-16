<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring />
<#import "../RoadMap.ftlh" as roadmap>

<#assign bcHome><@spring.message code='courseInstances.admin.add.breadcrumb.home'/></#assign>
<#assign bcList><@spring.message code='courseInstances.admin.add.breadcrumb.list'/></#assign>
<#assign bcCurrent><@spring.message code='courseInstances.admin.add.breadcrumb.current'/></#assign>

<@layout.page title="<@spring.message code='courseInstances.admin.add.header'/>">
    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcList, "url": "/admin/course-instances"},
    {"label": bcCurrent, "url": ""}
    ] />

    <div class="container">
        <div class="card" style="border-radius: 10px; box-shadow: 0 4px 15px rgba(0,102,204,0.1);">
            <div class="card-header py-3 d-flex justify-content-between align-items-center"
                 style="background: linear-gradient(135deg, #0066cc, #003d7a); border-top-left-radius: 10px; border-top-right-radius: 10px;">
                <h5 class="m-0 font-weight-bold text-white">
                    <i class="fas fa-plus-circle me-2"></i>
                    <@spring.message code="courseInstances.admin.add.header"/>
                </h5>
                <div>
                    <a href="/admin/course-instances" class="btn btn-light btn-sm"
                       style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                        <i class="fas fa-arrow-left me-1"
                           style="color: #0066cc;"></i> <@spring.message code="courseInstances.admin.add.breadcrumb.list"/>
                    </a>
                </div>
            </div>

            <div class="card-body">
                <form action="/admin/course-instances/create" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="mb-3">
                        <#assign errors = Request["org.springframework.validation.BindingResult.courseInstanceDto"] />
                        <label for="courseId" class="form-label">
                            <@spring.message code="courseInstances.admin.add.field.course"/> *
                        </label>
                        <select class="form-select" id="courseId" name="courseId">
                            <#list courses as course>
                                <option value="${course.id}"
                                        <#if (courseInstanceDto.courseId)?? && (courseInstanceDto.courseId == course.id)>selected</#if>>${course.title}</option>
                            </#list>
                        </select>
                        <div class="error-block text-danger">
                            <#if errors??>
                                <#list errors.fieldErrors as error>
                                    <#if error.field == "courseId">
                                        <div class="error-message">${error.defaultMessage}</div>
                                    </#if>
                                </#list>
                            </#if>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="title" class="form-label">
                            <@spring.message code="courseInstances.admin.add.field.title"/> *
                        </label>
                        <@spring.formInput "courseInstanceDto.title", "class='form-control' id='title'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "title", "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="startDate" class="form-label">
                            <@spring.message code="courseInstances.admin.add.field.startDate"/> *
                        </label>
                        <@spring.formInput "courseInstanceDto.startDate", "class='form-control' id='startDate' type='text' autocomplete='off'" />
                        <div class="error-block text-danger">
                            <@spring.showErrors "startDate", "error-message" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="endDate" class="form-label">
                            <@spring.message code="courseInstances.admin.add.field.endDate"/> *
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
                                <@spring.message code="courseInstances.admin.add.field.isActive"/>
                            </label>
                            <div class="error-block text-danger">
                                <@spring.showErrors "isActive", "error-message" />
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary-custom">
                        <i class="fas fa-plus me-2"></i><@spring.message code="courseInstances.admin.add.button.submit"/>
                    </button>
                </form>
            </div>
        </div>
    </div>

    <style>
        .required::after {
            content: " *";
            color: #dc3545;
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

        .btn-primary-custom {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
            color: white;
        }

        .btn-primary-custom:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }

        .form-check-input:checked {
            background-color: #0066cc;
            border-color: #0066cc;
        }

        .error-block {
            margin-top: 0.25rem;
        }
    </style>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            flatpickr("#startDate", {dateFormat: "Y-m-d", minDate: "today"});
            flatpickr("#endDate", {dateFormat: "Y-m-d", minDate: "today"});
        });
    </script>

</@layout.page>
