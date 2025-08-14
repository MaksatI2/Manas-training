<#import "/spring.ftl" as spring>
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>

<@page>
    <#assign bcHome = springMacroRequestContext.getMessage("admin.test.resultDetails.breadcrumb.home")>
    <#assign bcAll = springMacroRequestContext.getMessage("admin.test.resultDetails.breadcrumb.all")>
    <#assign bcDetails = springMacroRequestContext.getMessage("admin.test.resultDetails.breadcrumb.details", [test.title])>

    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcAll, "url": "/admin/test-results"},
    {"label": bcDetails, "url": ""}
    ] />

    <div class="hero-section">
        <h1 class="hero-title text-break">
            <i class="fa-solid fa-list-check"></i>
            ${springMacroRequestContext.getMessage("admin.test.resultDetails.heroTitle", [test.title])}
        </h1>
        <p class="hero-subtitle fs-4">
            <@spring.message code="admin.test.resultDetails.student"/> <span
                    class="fw-bold">${result.student.name} ${result.student.lastName}</span>
        </p>
    </div>

    <div class="row justify-content-center">
        <div class="col-12 col-md-10 col-lg-8 mx-auto">
            <div class="mb-3 text-end"></div>
            <div class="feature-card">
                <div class="card-body">
                    <h5 class="card-title fs-3 mb-3 border-bottom border-primary-subtle pb-3 text-break"><span
                                class="fw-bold">${test.title}</span></h5>
                    <p class="card-text fs-4 border-bottom border-primary-subtle pb-3 text-break">${test.description}</p>
                    <p class="card-text fs-5 border-bottom border-primary-subtle pb-3 text-break">
                        <span class="fw-bold"><@spring.message code="admin.test.resultDetails.questionsCount"/></span> ${test.questions?size}
                    </p>
                    <p class="card-text fs-5 border-bottom border-primary-subtle pb-3 text-break">
                        <span class="fw-bold"><@spring.message code="admin.test.resultDetails.gotPoints"/></span> ${result.score} <@spring.message code="admin.test.resultDetails.of"/> ${test.passingScore}
                    </p>
                    <p class="card-text fs-5 border-bottom border-primary-subtle pb-3 text-break">
                        <span class="fw-bold"><@spring.message code="admin.test.resultDetails.timeSpentLabel"/></span> ${result.timeSpentMinutes} <@spring.message code="admin.test.resultDetails.minutes"/>
                    </p>
                    <p class="card-text fs-5 fw-bold text-break">
                        <@spring.message code="admin.test.resultDetails.finalResult"/>
                        <#if result.isPassed>
                            <span class="text-success"><@spring.message code="admin.test.resultDetails.passed"/></span>
                        <#else>
                            <span class="text-danger"><@spring.message code="admin.test.resultDetails.failed"/></span>
                        </#if>
                    </p>
                </div>
            </div>

            <h3 class="text-center mb-4"><@spring.message code="admin.test.resultDetails.answersTitle"/></h3>

            <#list test.questions as question>
                <#if question?? && question.isRequired>
                    <#assign userAnswer = answers?filter(a -> a.questionId == question.id)?first>
                    <div class="feature-card">
                        <h4 class="card-title mb-3 border-bottom border-primary-subtle pb-3">
                            <@spring.message code="admin.test.resultDetails.questionPrefix"/> №${question?index + 1}
                        </h4>
                        <h5 class="card-title mb-3 fs-4 text-break">${question.question}</h5>
                        <ul class="list-group">
                            <#list question.options as option>
                                <#if option??>
                                    <li class="list-group-item border-primary-subtle fs-5 text-break">
                                        <#if option.isCorrect>
                                            <i class="fa-solid fa-check text-success"></i>
                                        <#else>
                                            <i class="fa-solid fa-xmark text-danger"></i>
                                        </#if>
                                        ${option.optionText}
                                        <#if userAnswer?? && option.id == userAnswer.answerId>
                                            <span class="fw-bold <#if option.isCorrect>text-success<#else>text-danger</#if>">
                                                ${springMacroRequestContext.getMessage("admin.test.resultDetails.chosenWithPoints", [userAnswer.points])}
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
