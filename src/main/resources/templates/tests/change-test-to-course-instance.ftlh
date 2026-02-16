<#include "../layout.ftlh">
<#import "/spring.ftl" as spring />
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <#assign bcHome><@spring.message code='change.test.to.course.instance.breadcrumb.home'/></#assign>
    <#assign bcMyCourses><@spring.message code='change.test.to.course.instance.breadcrumb.myCourses'/></#assign>
    <#assign bcInstance = springMacroRequestContext.getMessage('change.test.to.course.instance.breadcrumb.instance', [courseInstance.title])>
    <#assign bcReassign = springMacroRequestContext.getMessage('change.test.to.course.instance.breadcrumb.reassign', [courseInstance.title])>

    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMyCourses, "url": "/teacher/my-courses"},
    {"label": bcInstance, "url": "/teacher/course/${courseInstance.id}"},
    {"label": bcReassign, "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i
                    class="fa-solid fa-list-check"></i> ${springMacroRequestContext.getMessage('change.test.to.course.instance.page.title', [courseInstance.title])}
        </h1>
    </div>
    <form method="post" action="/instance/change/test" id="test-instance-edit">
        <div class="row justify-content-center" id="test">
            <div class="col-lg-10 col-md-10">
                <div class="feature-card">
                    <div class="mb-3">
                        <label for="testId"
                               class="form-label fw-bold"><@spring.message code="change.test.to.course.instance.label.test"/>
                            <span class="text-danger"><@spring.message code="change.test.to.course.instance.required"/></span></label>
                        <select class="form-select" id="testId" name="testId" required>
                            <option value="${testInstanceDto.test.id!}" selected>
                                ${(testInstanceDto.test.title)!springMacroRequestContext.getMessage('change.test.to.course.instance.select.placeholder')}
                                (${springMacroRequestContext.getMessage('change.test.to.course.instance.select.current')}
                                )
                            </option>
                            <#list tests as test>
                                <#if test.id != testInstanceDto.test.id>
                                    <option value="${test.id}">${test.title}</option>
                                </#if>
                            </#list>
                        </select>
                    </div>
                    <div class="mb-3">
                        <h3 class="mb-3"><@spring.message code="change.test.to.course.instance.section.availableFrom"/></h3>
                        <div class="row">
                            <div class="col-lg-4 col-md-6">
                                <label for="startDate"
                                       class="form-label fw-bold"><@spring.message code="change.test.to.course.instance.label.date"/>
                                    <span class="text-danger"><@spring.message code="change.test.to.course.instance.required"/></span></label>
                                <@spring.formInput "testInstanceDto.startDate" 'type="date" class="form-control input-date" id="startDate"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                            <div class="col-lg-4 col-md-6">
                                <label for="startTime"
                                       class="form-label fw-bold"><@spring.message code="change.test.to.course.instance.label.time"/>
                                    <span class="text-danger"><@spring.message code="change.test.to.course.instance.required"/></span></label>
                                <@spring.formInput "testInstanceDto.startTime" 'type="time" class="form-control input-time" id="startTime"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                        </div>
                        <#if error??>
                            <span class="error text-danger">${error}</span>
                        </#if>
                    </div>
                    <div class="mb-3">
                        <h3 class="mb-3"><@spring.message code="change.test.to.course.instance.section.availableUntil"/></h3>
                        <div class="row">
                            <div class="col-lg-4 col-md-6">
                                <label for="endDate"
                                       class="form-label fw-bold"><@spring.message code="change.test.to.course.instance.label.date"/>
                                    <span class="text-danger"><@spring.message code="change.test.to.course.instance.required"/></span></label>
                                <@spring.formInput "testInstanceDto.endDate" 'type="date" class="form-control input-date" id="endDate"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                            <div class="col-lg-4 col-md-6">
                                <label for="endTime"
                                       class="form-label fw-bold"><@spring.message code="change.test.to.course.instance.label.time"/>
                                    <span class="text-danger"><@spring.message code="change.test.to.course.instance.required"/></span></label>
                                <@spring.formInput "testInstanceDto.endTime" 'type="time" class="form-control input-time" id="endTime"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                        </div>
                        <#if error??>
                            <span class="error text-danger">${error}</span>
                        </#if>
                    </div>
                </div>
            </div>
            <#if _csrf??>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </#if>
            <input type="hidden" name="courseInstanceId" value="${courseInstanceId}">
            <div class="text-center">
                <button type="submit"
                        class="btn btn-primary-custom w-75"><@spring.message code="change.test.to.course.instance.button.save"/></button>
            </div>
        </div>
    </form>
    <script>
        let form = document.getElementById("test-instance-edit")
    </script>
    <script src="/static/js/test_form_validation_error.js"></script>
    <script src="/static/js/test_instance_form.js"></script>
</@page>
