<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <#assign bcHome><@spring.message code='course.final.tests.list.detail.breadcrumb.home'/></#assign>
    <#assign bcMyCourses><@spring.message code='course.final.tests.list.detail.breadcrumb.myCourses'/></#assign>
    <#assign bcTestsForCourse = springMacroRequestContext.getMessage('course.final.tests.list.detail.breadcrumb.testsForCourse', [test.course.title])>
    <#assign bcTestDetails = springMacroRequestContext.getMessage('course.final.tests.list.detail.breadcrumb.testDetails', [test.title])>

    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMyCourses, "url": "/teacher/my-courses"},
    {"label": bcTestsForCourse, "url": "/courses/${test.course.id}/tests"},
    {"label": bcTestDetails, "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title text-break">
            <i class="fa-solid fa-list-check"></i>
            ${springMacroRequestContext.getMessage('course.final.tests.list.detail.page.title', [test.title])}
        </h1>
    </div>

    <div class="row justify-content-center">
        <div class="col-12 col-md-10 col-lg-8 mx-auto">
            <div class="mb-3 text-end">
                <a href="/test/${test.id}/edit" class="btn btn-warning btn-sm rounded-pill p-2">
                    <i class="fas fa-edit me-1"></i><@spring.message code="course.final.tests.list.detail.button.edit"/>
                </a>
            </div>
            <div class="feature-card">
                <div class="card-body">
                    <h5 class="card-title fs-3 mb-3 border-bottom border-primary-subtle pb-3 text-break">
                        <span class="fw-bold"><@spring.message code="course.final.tests.list.detail.label.testTitle"/></span> ${test.title}
                    </h5>
                    <p class="card-text fs-4 border-bottom border-primary-subtle pb-3 text-break">
                        <span class="fw-bold"><@spring.message code="course.final.tests.list.detail.label.testDescription"/></span>${test.description}
                    </p>
                    <p class="card-text fs-5 border-bottom border-primary-subtle pb-3 text-break">
                        <span class="fw-bold"><@spring.message code="course.final.tests.list.detail.label.questionsCount"/></span> ${test.questions?size}
                    </p>
                    <p class="card-text fs-5 text-break">
                        <span class="fw-bold"><@spring.message code="course.final.tests.list.detail.label.passingScore"/></span>${test.passingScore}
                    </p>
                </div>
            </div>
            <h3 class="text-center mb-4"><@spring.message code="course.final.tests.list.detail.list.questions"/></h3>
            <#list test.questions as question>
                <div class="feature-card">
                    <h4 class="card-title mb-3 border-bottom border-primary-subtle pb-3 text-break">
                        ${springMacroRequestContext.getMessage('course.final.tests.list.detail.question.title', [question?index + 1])}
                        <#if !question.isRequired>
                            ${springMacroRequestContext.getMessage('course.final.tests.list.detail.question.inactive')}
                        </#if>
                    </h4>
                    <h5 class="card-title mb-3 border-bottom border-primary-subtle pb-3 fs-4 text-break">
                        <span class="fw-bold"><@spring.message code="course.final.tests.list.detail.question.text"/></span>${question.question}
                    </h5>
                    <h5 class="card-title mb-3 fw-bold">
                        <@spring.message code="course.final.tests.list.detail.question.options"/>
                    </h5>
                    <ul class="list-group">
                        <#list question.options as option>
                            <li class="list-group-item border-primary-subtle fs-5 text-break">
                                <#if option.isCorrect><i class="fa-solid fa-check text-success"></i><#else><i
                                        class="fa-solid fa-xmark text-danger"></i></#if> ${option.optionText}
                            </li>
                        </#list>
                    </ul>
                </div>
            </#list>
        </div>
    </div>
</@page>
