<#include "../layout.ftlh">
<#import "/spring.ftl" as spring />
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": "/teacher/my-courses"},
    {"label": "Поток #${courseInstance.title}", "url": "/teacher/course/${courseInstance.id}"},
    {"label": "Переназначить тест для потока: ${courseInstance.title}", "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Доступ к тесту ${testInstanceDto.test.title}
        </h1>
    </div>
    <form method="post" action="/instance/change-time" id="test-instance-edit">
        <div class="row justify-content-center" id="test">
            <div class="col-lg-10 col-md-10">
                <div class="feature-card">

                    <div class="mb-3">
                        <h3 class="mb-3">Доступен с:</h3>
                        <div class="row">
                            <div class="col-lg-4 col-md-6">
                                <label for="startDate" class="form-label fw-bold">Дата <span class="text-danger">*</span></label>
                                <@spring.formInput "testInstanceDto.startDate" 'type="date" class="form-control input-date flatpickr" id="startDate"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                            <div class="col-lg-4 col-md-6">
                                <label for="startTime" class="form-label fw-bold">Время <span class="text-danger">*</span></label>
                                <@spring.formInput "testInstanceDto.startTime" 'type="time" class="form-control input-time flatpickr" id="startTime"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                        </div>
                        <#if error??>
                            <span class="error text-danger">${error}</span>
                        </#if>
                    </div>
                    <div class="mb-3">
                        <h3 class="mb-3">Доступен по:</h3>
                        <div class="row">
                            <div class="col-lg-4 col-md-6">
                                <label for="endDate" class="form-label fw-bold">Дата <span class="text-danger">*</span></label>
                                <@spring.formInput "testInstanceDto.endDate" 'type="date" class="form-control input-date" id="endDate"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                            <div class="col-lg-4 col-md-6">
                                <label for="endTime" class="form-label fw-bold">Время <span class="text-danger">*</span></label>
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
                <button type="submit" class="btn btn-primary-custom w-75">Сохранить</button>
            </div>
        </div>
    </form>


    <script>
        let form = document.getElementById("test-instance-edit")
    </script>
    <script src="/static/js/test_form_validation_error.js"></script>
    <script src="/static/js/test_instance_form.js"></script>

</@page>