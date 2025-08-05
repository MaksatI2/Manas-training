<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">

    <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <@roadmap.breadcrumbs items=[
        {"label": "Главная", "url": "/"},
        {"label": "Мои курсы", "url": ""}
        ] />
        <h1 class="text-3xl font-bold text-gray-900 text-center mb-8"><i class="fas fa-book me-2"></i>Мои курсы</h1>

        <div class="border-b border-gray-200">
            <nav class="-mb-px flex space-x-8" aria-label="Tabs">
                <button id="active-tab"
                        class="tab-button border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm active"
                        onclick="showTab('active')">Активные курсы
                </button>
                <button id="finished-tab"
                        class="tab-button border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"
                        onclick="showTab('finished')">Завершенные курсы
                </button>
            </nav>
        </div>

        <div id="active-content" class="tab-content mt-6">
            <#if courses?size == 0>
                <p class="text-center text-gray-500">У вас пока нет активных курсов.</p>
            <#else>
                <div class="row grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    <#list courses as course>
                        <div class="col">
                            <a href="/student/course/${course.courseInstanceId}" class="text-decoration-none text-dark">
                                <div class="card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow h-100">
                                    <div class="card-body">
                                        <h5 class="card-title text-xl font-semibold text-gray-900">${course.instanceTitle}</h5>
                                        <h6 class="card-subtitle mb-2 text-gray-500">${course.courseTitle}</h6>
                                        <p class="card-text text-sm text-gray-600">
                                            Статус: <strong>${course.localizedStatus}</strong><br>
                                            Срок: ${course.startDate} – ${course.endDate}
                                        </p>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </#list>
                </div>
            </#if>
        </div>

        <div id="finished-content" class="tab-content mt-6 hidden">
            <#if finishedCourses?size == 0>
                <p class="text-center text-gray-500">У вас пока нет завершенных курсов.</p>
            <#else>
                <div class="row grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    <#list finishedCourses as course>
                        <div class="col">
                            <a href="/student/course/${course.courseInstanceId}" class="text-decoration-none text-dark">
                                <div class="card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow h-100">
                                    <div class="card-body">
                                        <h5 class="card-title text-xl font-semibold text-gray-900">${course.instanceTitle}</h5>
                                        <h6 class="card-subtitle mb-2 text-gray-500">${course.courseTitle}</h6>
                                        <p class="card-text text-sm text-gray-600">
                                            Статус: <strong>${course.localizedStatus}</strong><br>
                                            Срок: ${course.startDate} – ${course.endDate}
                                        </p>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </#list>
                </div>
            </#if>
        </div>
    </div>

    <script>
        function showTab(tabName) {
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.add('hidden');
            });

            document.querySelectorAll('.tab-button').forEach(button => {
                button.classList.remove('border-blue-500', 'text-blue-600', 'active');
                button.classList.add('border-transparent', 'text-gray-500', 'hover:text-gray-700', 'hover:border-gray-300');
            });

            document.getElementById(tabName + '-content').classList.remove('hidden');
            document.getElementById(tabName + '-tab').classList.remove('border-transparent', 'text-gray-500', 'hover:text-gray-700', 'hover:border-gray-300');
            document.getElementById(tabName + '-tab').classList.add('border-blue-500', 'text-blue-600', 'active');
        }

        showTab('active');
    </script>
</@layout.page>