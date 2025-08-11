<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>
<#setting date_format="yyyy-MM-dd">

<#assign tTitle = springMacroRequestContext.getMessage("student.applications.edit.title")>
<#assign bcHome = springMacroRequestContext.getMessage("student.applications.edit.breadcrumb.home")>
<#assign bcMyApps = springMacroRequestContext.getMessage("student.applications.edit.breadcrumb.myApplications")>
<#assign bcEdit = springMacroRequestContext.getMessage("student.applications.edit.breadcrumb.edit")>
<#assign headerText = springMacroRequestContext.getMessage("student.applications.edit.header")>
<#assign backText = springMacroRequestContext.getMessage("student.applications.edit.back")>
<#assign lblCourse = springMacroRequestContext.getMessage("student.applications.edit.course")>
<#assign optSelectCourse = springMacroRequestContext.getMessage("student.applications.edit.course.select")>
<#assign lblTeacher = springMacroRequestContext.getMessage("student.applications.edit.teacher")>
<#assign optNoneTeacher = springMacroRequestContext.getMessage("student.applications.edit.teacher.none")>
<#assign lblStart = springMacroRequestContext.getMessage("student.applications.edit.startDate")>
<#assign lblEnd = springMacroRequestContext.getMessage("student.applications.edit.endDate")>
<#assign btnSave = springMacroRequestContext.getMessage("student.applications.edit.save")>
<#assign errLoadTeachers = springMacroRequestContext.getMessage("student.applications.edit.error.loadTeachers")>

<@layout.page title="${tTitle}">
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMyApps, "url": "/applications/student/applications"},
    {"label": bcEdit, "url": ""}
    ] />

    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center"
             style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-edit me-2"></i> ${headerText}
            </h5>
            <a href="/applications/student/applications" class="btn btn-light btn-sm"
               style="border-radius: 25px; background: white; color: var(--primary-blue); border: 1px solid var(--primary-blue);">
                <i class="fas fa-arrow-left me-1" style="color: var(--primary-blue);"></i> ${backText}
            </a>
        </div>
        <div class="card-body">
            <form method="post">
                <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                <#if errors?? && errors.hasGlobalErrors()>
                    <div class="alert alert-danger small">
                        <#list errors.globalErrors as err>
                            ${err.defaultMessage}<br/>
                        </#list>
                    </div>
                </#if>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="courseId" class="form-label">${lblCourse} <span class="text-danger">*</span></label>
                        <select class="form-select" id="courseId" name="courseId" required>
                            <option value="">${optSelectCourse}</option>
                            <#list courses as course>
                                <option value="${course.id}" <#if course.id == application.courseId>selected</#if>>
                                    ${course.title}
                                </option>
                            </#list>
                        </select>
                        <#if errors?? && errors.hasFieldErrors("courseId")>
                            <div class="text-danger small mt-1">${errors.getFieldError("courseId").defaultMessage}</div>
                        </#if>
                    </div>

                    <div class="col-md-6">
                        <label for="preferredTeacherId" class="form-label">${lblTeacher}</label>
                        <select class="form-select" id="preferredTeacherId" name="preferredTeacherId">
                            <option value="">${optNoneTeacher}</option>
                            <#if teachers??>
                                <#list teachers as teacher>
                                    <option value="${teacher.id}"
                                            <#if (application.preferredTeacherId?? && teacher.id == application.preferredTeacherId)>selected</#if>>
                                        ${teacher.fullName} (${teacher.email})
                                    </option>
                                </#list>
                            </#if>
                        </select>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="preferredStartDate" class="form-label">${lblStart}</label>
                        <input type="date" class="form-control" id="preferredStartDate"
                               name="preferredStartDate"
                               value="${application.preferredStartDate}">
                        <#if errors?? && errors.hasFieldErrors("preferredStartDate")>
                            <div class="text-danger small mt-1">${errors.getFieldError("preferredStartDate").defaultMessage}</div>
                        </#if>
                    </div>
                    <div class="col-md-6">
                        <label for="preferredEndDate" class="form-label">${lblEnd}</label>
                        <input type="date" class="form-control" id="preferredEndDate"
                               name="preferredEndDate"
                               value="${application.preferredEndDate}">
                        <#if errors?? && errors.hasFieldErrors("preferredEndDate")>
                            <div class="text-danger small mt-1">${errors.getFieldError("preferredEndDate").defaultMessage}</div>
                        </#if>
                    </div>
                </div>

                <div class="d-flex justify-content-between">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> ${btnSave}
                    </button>
                </div>
            </form>
        </div>
    </div>
    <script>
        const optNoneTeacher = "${optNoneTeacher?js_string}";
        const errTeachers = "${errLoadTeachers?js_string}";

        document.getElementById('courseId').addEventListener('change', function () {
            const courseId = this.value;
            const teacherSelect = document.getElementById('preferredTeacherId');
            teacherSelect.innerHTML = '<option value="">' + optNoneTeacher + '</option>';

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
                        console.error(errTeachers + ':', error);
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
