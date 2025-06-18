<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring />
<@layout.page>
    <div class="hero-section">
        <h1 class="hero-title">${courseInstance.title}</h1>
        <p class="hero-subtitle">
            Начало: ${courseInstance.startDate} |
            Окончание: ${courseInstance.endDate} |
            Статус: <#if courseInstance.isActive>Активен<#else>Завершен</#if>
        </p>
    </div>

    <#if success??>
        <div class="alert alert-success">${success}</div>
    </#if>
    <#if error??>
        <div class="alert alert-danger">${error}</div>
    </#if>


    <div class="d-flex flex-wrap align-items-center gap-2 mb-4">
        <a href="/admin/course-instances/${courseInstance.id}/modules" class="btn btn-primary">Модули</a>
        <a href="/admin/course-instances/${courseInstance.id}/participants" class="btn btn-primary">Участники</a>
        <a href="/admin/course-instances" class="btn btn-secondary">Назад</a>
    </div>
    <div class="container">
        <h2>Модули курса</h2>
        <#if courseInstance.modules?has_content>
            <div class="accordion" id="modulesAccordion">
                <#list courseInstance.modules as module>
                    <div class="feature-card mb-3">
                        <div class="accordion-item">
                            <div class="d-flex justify-content-between align-items-center px-3 py-2 bg-light rounded-top">
                                <button class="accordion-button collapsed flex-grow-1 text-start" type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse${module.id}" aria-expanded="false"
                                        aria-controls="collapse${module.id}">
                                    ${module.title} (Продолжительность: ${module.durationHours} ч.)
                                </button>
                                <a href="/admin/course-instances/${courseInstance.id}/modules/${module.id}/lessons/new" class="btn btn-success btn-sm ms-3">
                                    + Урок
                                </a>
                            </div>


                            <div id="collapse${module.id}" class="accordion-collapse collapse"
                                 aria-labelledby="heading${module.id}" data-bs-parent="#modulesAccordion">
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
    <#if moduleIdWithErrors??>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var moduleId = "${moduleIdWithErrors}";
                var modalId = "#createLessonModal" + moduleId;
                var myModal = new bootstrap.Modal(document.querySelector(modalId));
                myModal.show();
            });
        </script>
    </#if>
    <style>
        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }
    </style>
</@layout.page>