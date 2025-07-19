<#include "../layout.ftlh">
<#import "/spring.ftl" as spring />
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Итоговый тест для потока ${courseInstance.title}
        </h1>
    </div>
    <form method="post" action="/instance/add/test">
        <div class="row justify-content-center" id="test">
            <div class="col-lg-10 col-md-10">
                <div class="feature-card">

                    <div class="mb-3">
                        <label for="testId" class="form-label required">Тест <#if !tests?has_content><span class="text-danger">(Нет активных тестов)</span></#if></label>
                        <select class="form-select" id="testId" name="testId" required <#if !tests?has_content> disabled </#if>>
                            <#if tests?has_content>
                                <option value="" disabled>Выберите тест для данного потока</option>
                                <#list tests as test>
                                    <option value="${test.id}">
                                        ${test.title}
                                    </option>
                                </#list>
                                <#else>
                                    <option value="" disabled>Нет активных тестов</option>
                            </#if>

                        </select>
                    </div>

                    <div class="mb-3">
                        <h3 class="mb-3">Доступен с:</h3>
                        <div class="row">
                            <div class="col-lg-4 col-md-6">
                                <label for="startDate" class="form-label fw-bold">Дата</label>
                                <@spring.formInput "testInstanceDto.startDate" 'type="date" class="form-control input-date" id="startDate"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                            <div class="col-lg-4 col-md-6">
                                <label for="startTime" class="form-label fw-bold">Время</label>
                                <@spring.formInput "testInstanceDto.startTime" 'type="time" class="form-control input-time" id="startTime"' />
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
                                <label for="endDate" class="form-label fw-bold">Дата</label>
                                <@spring.formInput "testInstanceDto.endDate" 'type="date" class="form-control input-date" id="endDate"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                            <div class="col-lg-4 col-md-6">
                                <label for="endTime" class="form-label fw-bold">Время</label>
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
        document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll(".input-date").forEach(input => {
                input.setAttribute("type", "date");
                const today = new Date().toISOString().split("T")[0];
                input.setAttribute("min", today);
            });
            document.querySelectorAll(".input-time").forEach(input => {
                input.setAttribute("type", "time");
            });
        });
    </script>

</@page>