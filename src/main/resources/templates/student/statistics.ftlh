<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>

<#assign bcHome><@spring.message code='student.statistic.view.breadcrumb.home'/></#assign>
<#assign bcProfile><@spring.message code='student.statistic.view.breadcrumb.profile'/></#assign>
<#assign bcStat><@spring.message code='student.statistic.view.breadcrumb.statistic'/></#assign>

<@layout.page>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">

    <div class="max-w-5xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <@roadmap.breadcrumbs items=[
        {"label": bcHome, "url": "/"},
        {"label": bcProfile, "url": "/student/profile"},
        {"label": bcStat, "url": ""}
        ] />

        <h2 class="text-3xl font-bold text-gray-900 text-center mb-8">
            <i class="fas fa-chart-bar mr-2 text-blue-600"></i><@spring.message code="student.statistic.view.title.attendance"/>
        </h2>

        <div class="bg-white shadow-sm rounded-lg overflow-hidden mb-8">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-blue-50">
                <tr>
                    <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code="student.statistic.view.table.course"/></th>
                    <th class="hidden"><@spring.message code="student.statistic.view.table.absentHours"/></th>
                    <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code="student.statistic.view.table.attendance"/></th>
                    <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code="student.statistic.view.table.status"/></th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <#if attendanceStatsList?? && attendanceStatsList?size gt 0>
                    <#list attendanceStatsList as stat>
                        <tr class="${stat.courseInstance.isActive?string('', 'bg-red-50')}">
                            <td class="px-4 py-3 text-center text-sm text-gray-900">
                                <#if (stat.courseInstance.title?length gt 20)>
                                    ${stat.courseInstance.title?substring(0, 20)}...
                                <#else>
                                    ${stat.courseInstance.title}
                                </#if>
                            </td>
                            <td class="hidden">${stat.absentHours!'—'}</td>
                            <td class="px-4 py-3 text-center text-sm text-gray-600 relative group cursor-pointer">
                                <#if stat.attendancePercentage??>
                                    ${stat.attendancePercentage}%
                                    <div class="mt-1 bg-gray-200 rounded-full h-2.5">
                                        <div class="bg-blue-600 h-2.5 rounded-full"
                                             style="width: ${stat.attendancePercentage}%"></div>
                                    </div>
                                    <div class="absolute bottom-full mb-2 left-1/2 transform -translate-x-1/2 hidden group-hover:block bg-gray-800 text-white text-xs rounded py-1 px-2 whitespace-nowrap z-10">
                                        Пропущено часов: ${stat.absentHours!'—'}
                                    </div>
                                <#else>
                                    —
                                </#if>
                            </td>
                            <td class="px-4 py-3 text-center text-sm font-semibold">
                                <#if stat.enrollmentStatus?? && stat.enrollmentStatus == "DROPPED">
                                    <span class="text-red-600"><@spring.message code="student.statistic.view.status.dropped"/></span>
                                <#else>
                                    <span class="text-green-600"><@spring.message code="student.statistic.view.status.enrolled"/></span>
                                </#if>
                            </td>
                        </tr>
                    </#list>
                <#else>
                    <tr>
                        <td colspan="5"
                            class="px-4 py-3 text-center text-sm text-gray-500"><@spring.message code="student.statistic.view.noData"/></td>
                    </tr>
                </#if>
                </tbody>
            </table>
        </div>

        <#if testResults?? && testResults?size gt 0>
            <div class="bg-white shadow-sm rounded-lg overflow-hidden">
                <h2 class="text-2xl font-semibold text-gray-900 text-center mb-6 pt-6"><@spring.message code="student.statistic.view.title.tests"/></h2>
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-blue-50">
                    <tr>
                        <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code="student.statistic.view.table.course"/></th>
                        <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code="student.statistic.view.table.score"/></th>
                        <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code="student.statistic.view.table.submissionDate"/></th>
                    </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                    <#list testResults as result>
                        <tr class="${result.isPassed?string('bg-green-50', 'bg-red-50')}">
                            <td class="px-4 py-3 text-sm text-gray-900">
                                <#if (result.courseTitle?length gt 20)>
                                    ${result.courseTitle?substring(0, 20)}...
                                <#else>
                                    ${result.courseTitle!'—'}
                                </#if>
                            </td>
                            <td class="px-4 py-3 text-sm text-gray-600">
                                ${result.score!'—'}
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

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const loc = "${springMacroRequestContext.locale?string}".toLowerCase();
            const lang2 = loc.startsWith("ru") ? "ru" : (loc.startsWith("ky") ? "ky" : "en");
            if (window.jQuery && $.fn.dataTable) {
                $.extend(true, $.fn.dataTable.defaults, {
                    language: {
                        url: '/js/datatables/' + lang2 + '.json',
                        paginate: {previous: '‹', next: '›'}
                    }
                });
            }
        });
    </script>
</@layout.page>
