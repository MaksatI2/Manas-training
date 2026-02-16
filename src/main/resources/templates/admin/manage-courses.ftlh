<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<@layout.page>
    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>
    <div class="card shadow mb-4">

        <div class="card-header py-3" style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <div class="d-flex flex-wrap justify-content-between align-items-center">
                <a href="/teacher/${teacherId}" class="btn btn-light btn-sm me-2"
                   style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-arrow-left me-1"
                       style="color: #0066cc;"></i> ${springMacroRequestContext.getMessage("teacher.manageCourses.back")}
                </a>
                <h5 class="m-0 font-weight-bold text-white mb-2 mb-md-0">
                    <i class="fas fa-book me-2"></i>
                    ${springMacroRequestContext.getMessage("teacher.manageCourses.title", [teacher.teacher.name, teacher.teacher.lastName])}
                </h5>
            </div>
        </div>

        <div class="card-body">
            <form action="/admin/teachers/${teacher.teacher.id}/manage-courses" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div id="courses-container" class="mb-4">
                    <#if allCourses?has_content>
                        <#list allCourses as course>
                            <div class="course-section mb-3 p-3 border rounded" data-course-id="${course.id}">
                                <div class="row align-items-center">
                                    <div class="col-1">
                                        <input type="checkbox" class="form-check-input" name="courseIds"
                                               value="${course.id}"
                                               <#if assignedCourses?seq_contains(course.id)>checked</#if>>
                                    </div>
                                    <div class="col-6">
                                        <span>${course.title}</span>
                                    </div>
                                    <div class="col-5">
                                        <span>${springMacroRequestContext.getMessage("teacher.manageCourses.courseCode", [course.code])}</span>
                                    </div>
                                </div>
                            </div>
                        </#list>
                    <#else>
                        <div class="text-center text-muted py-4">
                            <i class="fas fa-book fa-2x mb-2"></i>
                            <p>${springMacroRequestContext.getMessage("teacher.manageCourses.noCourses")}</p>
                        </div>
                    </#if>
                </div>
                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary btn-sm" style="border-radius: 25px;">
                        <i class="fas fa-save me-1"></i> ${springMacroRequestContext.getMessage("teacher.manageCourses.saveChanges")}
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
        }

        .card-header {
            border-bottom: none;
        }

        .course-section {
            background-color: #f8f9fa;
            transition: all 0.3s ease;
        }

        .course-section:hover {
            background-color: rgba(0, 102, 204, 0.05);
            transform: translateY(-1px);
        }

        .form-check-input {
            cursor: pointer;
        }

        .btn-primary {
            background-color: #0066cc;
            border-color: #0066cc;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
    </style>
</@layout.page>
