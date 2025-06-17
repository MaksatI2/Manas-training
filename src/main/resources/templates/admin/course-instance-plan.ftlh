<#import "../layout.ftlh" as layout>

<@layout.page>
    <h1>Редактирование плана: ${instance.courseTitle} - ${instance.title}</h1>
    <p>Длительность курса: ${instance.durationHours} часов</p>

    <h2>Текущие модули</h2>
    <div id="modules">
        <#if instance.modules?has_content>
            <#list instance.modules as module>
                <div class="module card mb-3">
                    <div class="card-body">
                        <h3>${module.title} (${module.durationHours} часов)</h3>
                        <p>${module.description!"Без описания"}</p>
                        <h4>Уроки</h4>
                        <ul>
                            <#if module.lessons?has_content>
                                <#list module.lessons as lesson>
                                    <li>${lesson.title} (${lesson.durationMinutes} минут)</li>
                                </#list>
                            <#else>
                                <li>Уроки не добавлены</li>
                            </#if>
                        </ul>
                    </div>
                </div>
            </#list>
        <#else>
            <p>Модули не добавлены</p>
        </#if>
    </div>

    <h2>Добавить модули</h2>
    <form method="post" action="/admin/course-instances/${instance.id}/plan" id="plan-form">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="courseInstanceId" value="${instance.id}">
        <div id="module-container">
        </div>
        <button type="button" class="btn btn-secondary mb-3" id="add-module">Добавить модуль</button>
        <button type="submit" class="btn btn-primary-custom">Сохранить план</button>
    </form>

    <script>
        let moduleIndex = 0;

        function addModule() {
            const container = document.getElementById('module-container');
            const moduleDiv = document.createElement('div');
            moduleDiv.className = 'module card mb-3';
            moduleDiv.innerHTML = `
                <div class="card-body">
                    <h4>Модуль ${moduleIndex + 1}</h4>
                    <div class="mb-3">
                        <label>Название модуля</label>
                        <input type="text" name="modules[${moduleIndex}].title" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Описание</label>
                        <textarea name="modules[${moduleIndex}].description" class="form-control"></textarea>
                    </div>
                    <div class="mb-3">
                        <label>Длительность (часы)</label>
                        <input type="number" name="modules[${moduleIndex}].durationHours" class="form-control" required min="1">
                    </div>
                    <div class="mb-3">
                        <label>Порядок</label>
                        <input type="number" name="modules[${moduleIndex}].orderIndex" class="form-control" required min="1" value="${moduleIndex + 1}">
                    </div>
                    <button type="button" class="btn btn-danger remove-module">Удалить модуль</button>
                </div>
            `;
            container.appendChild(moduleDiv);
            moduleIndex++;

            moduleDiv.querySelector('.remove-module').addEventListener('click', () => {
                moduleDiv.remove();
            });
        }

        document.getElementById('add-module').addEventListener('click', addModule);

        addModule();
    </script>
</@layout.page>