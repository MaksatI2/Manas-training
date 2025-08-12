<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <#assign bcHome><@spring.message code='test.result.view.breadcrumb.home'/></#assign>
    <#assign bcMy><@spring.message code='test.result.view.breadcrumb.myCourses'/></#assign>
    <#assign bcResults = springMacroRequestContext.getMessage('test.result.view.breadcrumb.resultsForTest', [test.title])>

    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMy, "url": "/teacher/my-courses"},
    {"label": "${result.testInstance.courseInstance.title}", "url": "/teacher/courses/${result.testInstance.courseInstance.id}"},
    {"label": bcResults, "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i
                    class="fa-solid fa-list-check"></i> ${springMacroRequestContext.getMessage('test.result.view.hero.title', [test.title])}
        </h1>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-8">
            <div class="mb-3 text-end"></div>
            <div class="feature-card">
                <div class="card-body">
                    <h5 class="card-title fs-3 mb-3 border-bottom border-primary-subtle pb-3"><span
                                class="fw-bold">${test.title}</span></h5>
                    <p class="card-text fs-4 border-bottom border-primary-subtle pb-3">${test.description}</p>
                    <p class="card-text fs-5 border-bottom border-primary-subtle pb-3">
                        <span class="fw-bold"><@spring.message code="test.result.view.label.questionsCount"/></span> ${test.questions?size}
                    </p>
                    <p class="card-text fs-5 border-bottom border-primary-subtle pb-3">
                        ${springMacroRequestContext.getMessage('test.result.view.label.pointsScored', [result.totalPoints, test.passingScore])}
                    </p>
                    <p class="card-text fs-5 fw-bold">
                        <@spring.message code="test.result.view.label.finalResult"/>
                        <#if result.isPassed>
                            <span class="text-success"><@spring.message code="test.result.view.status.passed"/></span>
                        <#else>
                            <span class="text-danger"><@spring.message code="test.result.view.status.failed"/></span>
                        </#if>
                    </p>
                </div>
            </div>
            <h3 class="text-center mb-4"><@spring.message code="test.result.view.section.yourAnswers"/></h3>
            <#list test.questions as question>
                <#if question?? && question.isRequired>
                    <div class="feature-card">
                        <h4 class="card-title mb-3 border-bottom border-primary-subtle pb-3">
                            ${springMacroRequestContext.getMessage('test.result.view.question.title', [question?index + 1])}
                        </h4>
                        <h5 class="card-title mb-3 fs-4">${question.question}</h5>
                        <ul class="list-group">
                            <#list question.options as option>
                                <#if option??>
                                    <li class="list-group-item border-primary-subtle fs-5">
                                        <#if option.isCorrect>
                                            <i class="fa-solid fa-check text-success"></i>
                                        <#else>
                                            <i class="fa-solid fa-xmark text-danger"></i>
                                        </#if>
                                        ${option.optionText}
                                        <#if (answers?filter(a -> a.questionId == question.id)?size > 0)
                                        && (option.id == (answers?filter(a -> a.questionId == question.id)?first).answerId)>
                                            <span class="fw-bold <#if option.isCorrect>text-success<#else>text-danger</#if>">
                                                ${springMacroRequestContext.getMessage('test.result.view.answer.yours', [(answers?filter(a -> a.questionId == question.id)?first).points])}
                                            </span>
                                        </#if>
                                    </li>
                                </#if>
                            </#list>
                        </ul>
                    </div>
                </#if>
            </#list>
        </div>
    </div>
</@page>
