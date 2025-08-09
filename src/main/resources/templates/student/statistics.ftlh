<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">

    <div class="max-w-5xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <@roadmap.breadcrumbs items=[
        {"label": "Главная", "url": "/"},
        {"label": "Профиль", "url": "/student/profile"},
        {"label": "Статистика", "url": ""}
        ] />

        <h2 class="text-3xl font-bold text-gray-900 text-center mb-8">
            <i class="fas fa-chart-bar mr-2 text-blue-600"></i>Моя статистика посещаемости
        </h2>

        <div class="bg-white shadow-sm rounded-lg overflow-hidden mb-8">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-blue-50">
                <tr>
                    <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">Курс</th>
                    <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">Всего часов</th>
                    <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">Пропущено</th>
                    <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">Пропуски</th>
                    <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">Статус</th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <#if attendanceStatsList?? && attendanceStatsList?size gt 0>
                    <#list attendanceStatsList as stat>
                        <tr class="${stat.courseInstance.isActive?string('', 'bg-red-50')}">
                            <td class="px-4 py-3 text-center text-sm text-gray-900">
                                <#if stat.courseInstance.title?length gt 20>
                                    ${stat.courseInstance.title?substring(0, 20)}...
                                <#else>
                                    ${stat.courseInstance.title}
                                </#if>
                            </td>
                            <td class="px-4 py-3 text-center text-sm text-gray-600">
                                ${stat.totalHours!'—'}
                            </td>
                            <td class="px-4 py-3 text-center text-sm text-gray-600">
                                ${stat.absentHours!'—'}
                            </td>
                            <td class="px-4 py-3 text-center text-sm text-gray-600">
                                <#if stat.attendancePercentage??>
                                    ${stat.attendancePercentage}%
                                    <div class="mt-1 bg-gray-200 rounded-full h-2.5">
                                        <div class="bg-blue-600 h-2.5 rounded-full" style="width: ${stat.attendancePercentage}%"></div>
                                    </div>
                                <#else>
                                    —
                                </#if>
                            </td>
                            <td class="px-4 py-3 text-center text-sm font-semibold">
                                <#if stat.enrollmentStatus?? && stat.enrollmentStatus == "DROPPED">
                                    <span class="text-red-600">${stat.localisedStatus!'Неизвестно'}</span>
                                <#else>
                                    <span class="text-green-600">${stat.localisedStatus!'Неизвестно'}</span>
                                </#if>
                            </td>
                        </tr>
                    </#list>
                <#else>
                    <tr>
                        <td colspan="5" class="px-4 py-3 text-center text-sm text-gray-500">Нет данных по статистике.</td>
                    </tr>
                </#if>
                </tbody>
            </table>
        </div>

        <#if testResults?? && testResults?size gt 0>
            <div class="bg-white shadow-sm rounded-lg overflow-hidden">
                <h2 class="text-2xl font-semibold text-gray-900 text-center mb-6 pt-6">Результаты тестов</h2>
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-blue-50">
                    <tr>
                        <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Курс</th>
                        <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Тест</th>
                        <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Оценка</th>
                        <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Статус</th>
                        <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Дата сдачи</th>
                    </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                    <#list testResults as result>
                        <tr class="${result.isPassed?string('bg-green-50', 'bg-red-50')}">
                            <td class="px-4 py-3 text-sm text-gray-900">
                                <#if result.courseTitle?length gt 20>
                                    ${result.courseTitle?substring(0, 20)}...
                                <#else>
                                    ${result.courseTitle!'—'}
                                </#if>
                            </td>
                            <td class="px-4 py-3 text-sm text-gray-600">
                                <#if result.testTitle?length gt 20>
                                    ${result.testTitle?substring(0, 20)}...
                                <#else>
                                    ${result.testTitle!'—'}
                                </#if>
                            </td>
                            <td class="px-4 py-3 text-sm text-gray-600">
                                ${result.score!'—'}
                            </td>
                            <td class="px-4 py-3 text-sm font-semibold ${result.isPassed?string('text-green-600', 'text-red-600')}">
                                ${result.isPassed?string('Пройден', 'Не пройден')}
                            </td>
                            <td class="px-4 py-3 text-sm text-gray-600">
                                ${result.localisedTime!'—'}
                            </td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </#if>
    </div>
</@layout.page>