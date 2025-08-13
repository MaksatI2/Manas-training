<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>

<#assign bcHome><@spring.message code='breadcrumb.home'/></#assign>
<#assign bcUsers><@spring.message code='breadcrumb.users'/></#assign>
<#assign bcProfile><@spring.message code='breadcrumb.profile'/></#assign>

<@layout.page>
    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>

    <div class="max-w-6xl mx-auto py-6 px-4 sm:px-6 lg:px-8">


        <@roadmap.breadcrumbs items=[
        {"label": bcHome, "url": "/"},
        {"label": bcUsers, "url": "/admin/users"},
        {"label": bcProfile, "url": ""}
        ] />

        <h1 class="text-3xl font-bold text-gray-900 text-center mb-8">
            <i class="fas fa-user-circle mr-2 text-blue-600"></i><@spring.message code='page.user.profile'/>
        </h1>

        <div class="bg-white shadow-sm rounded-lg p-6 mb-8">
            <div class="flex flex-col md:flex-row items-center md:items-start gap-6">
                <div class="relative group">
                    <img src="${profile.user.avatarUrl?has_content?then('/data/images/' + profile.user.avatarUrl, '/static/images/default_avatar.jpg')}"
                         class="w-32 h-32 rounded-full object-cover border-4 border-blue-200 shadow-md group-hover:scale-105 transition-transform duration-300"
                         alt="Фото профиля">
                    <div class="absolute inset-0 rounded-full bg-black bg-opacity-50 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                        <span class="text-white font-semibold text-sm">Изменить</span>
                    </div>
                </div>
                <div class="flex-1 text-left md:text-left">
                    <h2 class="text-2xl font-semibold text-gray-900 break-all overflow-wrap-anywhere">${profile.user.name} ${(profile.user.lastName?has_content && profile.user.lastName != "null")?then(profile.user.lastName, "")}
                    </h2>
                    <p class="text-lg text-blue-600 mt-1 break-all overflow-wrap-anywhere">
                        <i class="fas fa-envelope mr-2"></i>${profile.user.email}
                    </p>
                    <div class="mt-2 flex flex-col gap-2 items-start">
                        <span class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-full text-sm font-semibold w-auto max-w-max">
                            <i class="fas fa-user-tag mr-2"></i><@spring.message code='label.role'/>: ${profile.user.role.name}
                        </span>
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mt-6">
                <#if profile.user.phone?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                        <div class="text-sm font-semibold text-blue-800"><i
                                    class="fas fa-phone mr-2"></i><@spring.message code='label.phone'/></div>
                        <div class="text-gray-700 break-words">${profile.user.phone}</div>
                    </div>
                </#if>
                <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                    <div class="text-sm font-semibold text-blue-800"><i
                                class="fas fa-calendar-check mr-2"></i><@spring.message code='label.status'/></div>
                    <div class="text-sm font-semibold ${profile.user.isActive?string('text-green-600', 'text-red-600')}">
                        <i class="fas ${profile.user.isActive?string('fa-check-circle', 'fa-times-circle')} mr-1"></i>
                        <#if profile.user.isActive>
                            <@spring.message code="status.active"/>
                        <#else>
                            <@spring.message code="status.inactive"/>
                        </#if>
                    </div>
                </div>
                <#if profile.specialization?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                        <div class="text-sm font-semibold text-blue-800"><i
                                    class="fas fa-laptop-code mr-2"></i><@spring.message code='label.specialization'/>
                        </div>
                        <div class="text-gray-700 break-words">${profile.specialization}</div>
                    </div>
                </#if>
                <#if profile.organizationName?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                        <div class="text-sm font-semibold text-blue-800"><i
                                    class="fas fa-building mr-2"></i><@spring.message code='label.organization'/></div>
                        <div class="text-gray-700 break-words">${profile.organizationName}</div>
                    </div>
                </#if>
                <#if profile.department?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                        <div class="text-sm font-semibold text-blue-800"><i
                                    class="fas fa-building mr-2"></i><@spring.message code='label.department'/></div>
                        <div class="text-gray-700 break-words">${profile.department}</div>
                    </div>
                </#if>
                <#if profile.qualifications?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                        <div class="text-sm font-semibold text-blue-800"><i
                                    class="fas fa-certificate mr-2"></i><@spring.message code='label.qualification'/>
                        </div>
                        <div class="text-gray-700 break-words">${profile.qualifications}</div>
                    </div>
                </#if>
                <#if profile.organization?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                        <div class="text-sm font-semibold text-blue-800"><i
                                    class="fas fa-building mr-2"></i><@spring.message code='label.organization.code'/>
                        </div>
                        <div class="text-gray-700 break-words">${profile.organization.code}</div>
                    </div>
                    <#if profile.organization.description?has_content>
                        <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200 col-span-1 sm:col-span-2">
                            <div class="text-sm font-semibold text-blue-800"><i
                                        class="fas fa-info-circle mr-2"></i><@spring.message code='label.organization.description'/>
                            </div>
                            <div class="text-gray-700 break-words">${profile.organization.description}</div>
                        </div>
                    </#if>
                </#if>
                <#if profile.bio?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200 col-span-1 sm:col-span-2">
                        <div class="text-sm font-semibold text-blue-800"><i
                                    class="fas fa-info-circle mr-2"></i><@spring.message code='label.about'/></div>
                        <div class="text-gray-700 break-words">${profile.bio}</div>
                    </div>
                </#if>
            </div>
        </div>

        <#if profile.user.role.name == "STUDENT">
            <div class="mb-8">
                <h2 class="text-2xl font-semibold text-gray-900 text-center mb-6">
                    <i class="fas fa-chart-bar mr-2 text-blue-600"></i><@spring.message code='title.attendance.stats'/>
                </h2>
                <div class="bg-white shadow-sm rounded-lg overflow-hidden">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-blue-50">
                        <tr>
                            <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code='table.course'/></th>
                            <th class="hidden"><@spring.message code='table.missed.hours'/></th>
                            <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code='table.attendance'/></th>
                            <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code='table.status'/></th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <#if attendanceStatsList?? && attendanceStatsList?size gt 0>
                            <#list attendanceStatsList as stat>
                                <tr class="${stat.courseInstance.isActive?string('', 'bg-red-50')}">
                                    <td class="px-4 py-3 text-center text-sm text-gray-900">
                                        <#if stat.courseInstance.title?length gt 15>
                                            ${stat.courseInstance.title?substring(0, 15)}...
                                        <#else>
                                            ${stat.courseInstance.title!'—'}
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
                                            <span class="text-red-600">${stat.localisedStatus!'Неизвестно'}</span>
                                        <#else>
                                            <span class="text-green-600">${stat.localisedStatus!'Неизвестно'}</span>
                                        </#if>
                                    </td>
                                </tr>
                            </#list>
                        <#else>
                            <tr>
                                <td colspan="4"
                                    class="px-4 py-3 text-center text-sm text-gray-500"><@spring.message code='table.no.attendance.data'/></td>
                            </tr>
                        </#if>
                        </tbody>
                    </table>
                </div>

                <#if testResults?? && testResults?size gt 0>
                    <h2 class="text-2xl font-semibold text-gray-900 text-center mt-8 mb-6"><@spring.message code='title.test.results'/></h2>
                    <div class="bg-white shadow-sm rounded-lg overflow-hidden">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-blue-50">
                            <tr>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code='table.course'/></th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code='table.score'/></th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code='table.pass.date'/></th>
                            </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                            <#list testResults as result>
                                <tr class="${result.isPassed?string('bg-green-50', 'bg-red-50')}">
                                    <td class="px-4 py-3 text-sm text-gray-900">
                                        <#if result.courseTitle?length gt 15>
                                            ${result.courseTitle?substring(0, 15)}...
                                        <#else>
                                            ${result.courseTitle!'—'}
                                        </#if>
                                    </td>
                                    <td class="px-4 py-3 text-sm text-gray-600">${result.score!'—'}</td>
                                    <td class="px-4 py-3 text-sm text-gray-600">${result.localisedTime!'—'}</td>
                                </tr>
                            </#list>
                            </tbody>
                        </table>
                    </div>
                </#if>
            </div>
        </#if>

        <#if profile.user.role.name == "TEACHER">
            <div class="mb-8">
                <h2 class="text-2xl font-semibold text-gray-900 text-center mb-6">
                    <i class="fas fa-book mr-2 text-blue-600"></i><@spring.message code='title.teacher.courses'/>
                </h2>
                <#if courses?size == 0>
                    <div class="p-4 bg-blue-100 text-blue-700 rounded-lg text-center"><@spring.message code='teacher.no.courses'/></div>
                <#else>
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                        <#list courses as course>
                            <div class="relative bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                                <i class="fas fa-book-open absolute top-4 left-4 text-blue-200 text-xl opacity-50 group-hover:opacity-75 transition-opacity"></i>
                                <span class="absolute top-4 right-4 px-2 py-1 text-xs font-semibold text-white rounded-full ${course.isActive?string('bg-blue-600', 'bg-red-600')}">
                                    <#if course.isActive>
                                        <@spring.message code="status.active"/>
                                    <#else>
                                        <@spring.message code="status.inactive"/>
                                    </#if>
                                </span>
                                <a href="/admin/course-instances/${course.courseInstanceId}"
                                   class="block text-decoration-none text-gray-900">
                                    <h5 class="text-lg font-semibold mb-2">
                                        <#if course.courseTitle?length gt 15>
                                            ${course.courseTitle?substring(0, 15)}...
                                        <#else>
                                            ${course.courseTitle}
                                        </#if>
                                    </h5>
                                    <h6 class="text-sm text-blue-600 mb-3">
                                        <#if course.instanceTitle?length gt 15>
                                            ${course.instanceTitle?substring(0, 15)}...
                                        <#else>
                                            ${course.instanceTitle!'—'}
                                        </#if>
                                    </h6>
                                    <p class="text-sm text-gray-600 flex items-center gap-2">
                                        <i class="fas fa-calendar-alt text-blue-200"></i>
                                        ${course.startDate!'—'} – ${course.endDate!'—'}
                                    </p>
                                </a>
                            </div>
                        </#list>
                    </div>
                </#if>
            </div>
        </#if>

        <#if profile.user.role.name == "ORGANIZATION">
            <div class="mb-8">
                <h2 class="text-2xl font-semibold text-gray-900 text-center mb-6">
                    <i class="fas fa-users mr-2 text-blue-600"></i><@spring.message code='title.organization.students'/>
                </h2>
                <div class="bg-white shadow-sm rounded-lg overflow-hidden">
                    <table class="min-w-full divide-y divide-gray-200" id="studentsTable">
                        <thead class="bg-blue-50">
                        <tr>
                            <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code='table.fullname'/></th>
                            <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code='table.email'/></th>
                            <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code='table.phone'/></th>
                            <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider"><@spring.message code='table.courses'/></th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <#assign grouped = {} />
                        <#list students as s>
                            <#assign sid = s.studentId?string>
                            <#assign grouped = grouped + { (sid): (grouped[sid]![]) + [s] } >
                        </#list>
                        <#if grouped?size gt 0>
                            <#list grouped?keys as sid>
                                <#assign courseList = grouped[sid]>
                                <#assign first = courseList[0]>
                                <tr>
                                    <td class="px-4 py-3 text-sm text-gray-900 break-words">${first.fullName!'—'}</td>
                                    <td class="px-4 py-3 text-sm text-gray-600 break-words">${first.email!'—'}</td>
                                    <td class="px-4 py-3 text-sm text-gray-600 break-words">${first.phone!'—'}</td>
                                    <td class="px-4 py-3 text-sm text-gray-600">
                                        <ul class="list-disc pl-4 mb-0">
                                            <#list courseList as c>
                                                <li>
                                                    <#if c.courseTitle?length gt 15>
                                                        ${c.courseTitle?substring(0, 15)}...
                                                    <#else>
                                                        ${c.courseTitle!'—'}
                                                    </#if>
                                                    — ${c.localizedStatus!'Неизвестно'}, ${c.progress!'0'}%
                                                    <#if c.finalGrade??>, <@spring.message code='label.grade'/>: ${c.finalGrade}</#if>
                                                </li>
                                            </#list>
                                        </ul>
                                    </td>
                                </tr>
                            </#list>
                        <#else>
                            <tr>
                                <td colspan="4"
                                    class="px-4 py-3 text-center text-sm text-gray-500"><@spring.message code='organization.no.students'/></td>
                            </tr>
                        </#if>
                        </tbody>
                    </table>
                </div>

                <script>
                    $(document).ready(function () {
                        var dtLangUrl = "<#if springMacroRequestContext.locale?string?lower_case?starts_with('ru')>/js/datatables/ru_RU.json" +
                            "<#elseif springMacroRequestContext.locale?string?lower_case?starts_with('ky')>/js/datatables/ky_KG.json" +
                            "<#else>/js/datatables/en_US.json</#if>";
                        $('#studentsTable').DataTable({
                            language: {url: dtLangUrl, paginate: {previous: '‹', next: '›'}},
                            responsive: true,
                            pageLength: 10,
                            order: [[0, 'asc']],
                            autoWidth: false,
                            info: false
                        });
                    });
                </script>
            </div>
        </#if>
    </div>
</@layout.page>
