<#import "../layout.ftlh" as layout>
<@layout.page>
    <div class="hero-section">
        <h1 class="hero-title">${courseInstance.title}</h1>
        <p class="hero-subtitle">
            Начало: ${courseInstance.startDate} |
            Окончание: ${courseInstance.endDate} |
            Статус: <#if courseInstance.isActive>Активен<#else>Завершен</#if>
        </p>
    </div>

    <div class="container">
        <h2>Модули курса</h2>
        <#if courseInstance.modules?has_content>
            <div class="accordion" id="modulesAccordion">
                <#list courseInstance.modules as module>
                    <div class="feature-card mb-3">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="heading${module.id}">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${module.id}" aria-expanded="true" aria-controls="collapse${module.id}">
                                    ${module.title} (Продолжительность: ${module.durationHours} ч.)
                                </button>
                            </h2>
                            <div id="collapse${module.id}" class="accordion-collapse collapse" aria-labelledby="heading${module.id}" data-bs-parent="#modulesAccordion">
                                <div class="accordion-body">
                                    <p>${module.description!''}</p>
                                    <h5>Уроки</h5>
                                    <#if module.lessons?has_content>
                                        <ul>
                                            <#list module.lessons as lesson>
                                                <li>
                                                    ${lesson.title} (${lesson.durationMinutes} мин.)
                                                    <p>${lesson.description!''}</p>
                                                </li>
                                            </#list>
                                        </ul>
                                    <#else>
                                        <p>Уроки отсутствуют</p>
                                    </#if>
                                </div>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        <#else>
            <p>Модули отсутствуют</p>
        </#if>
    </div>
</@layout.page>