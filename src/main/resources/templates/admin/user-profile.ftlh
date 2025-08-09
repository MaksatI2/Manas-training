<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>

    <div class="max-w-6xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <@roadmap.breadcrumbs items=[
        {"label": "Главная", "url": "/"},
        {"label": "Пользователи", "url": "/admin/users"},
        {"label": "Профиль", "url": ""}
        ] />

        <#if successMessage??>
            <div class="mb-6 p-4 bg-green-100 border-l-4 border-green-500 text-green-700 rounded-lg">
                <i class="fas fa-check-circle mr-2"></i>${successMessage}
            </div>
        </#if>
        <#if errorMessage??>
            <div class="mb-6 p-4 bg-red-100 border-l-4 border-red-500 text-red-700 rounded-lg">
                <i class="fas fa-exclamation-circle mr-2"></i>${errorMessage}
            </div>
        </#if>

        <h1 class="text-3xl font-bold text-gray-900 text-center mb-8">
            <i class="fas fa-user-circle mr-2 text-blue-600"></i>Профиль пользователя
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
                    <h2 class="text-2xl font-semibold text-gray-900 break-words">${profile.user.name} ${profile.user.lastName}</h2>
                    <p class="text-lg text-blue-600 mt-1 break-words">
                        <i class="fas fa-envelope mr-2"></i>${profile.user.email}
                    </p>
                    <div class="mt-2 flex flex-col gap-2 items-start">
        <span class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-full text-sm font-semibold w-auto max-w-max">
            <i class="fas fa-user-tag mr-2"></i>Роль: ${profile.user.role.name}
        </span>
                    </div>
                </div>

            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mt-6">
                <#if profile.user.phone?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                        <div class="text-sm font-semibold text-blue-800"><i class="fas fa-phone mr-2"></i>Телефон</div>
                        <div class="text-gray-700 break-words">${profile.user.phone}</div>
                    </div>
                </#if>
                <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                    <div class="text-sm font-semibold text-blue-800"><i class="fas fa-calendar-check mr-2"></i>Статус</div>
                    <div class="text-sm font-semibold ${profile.user.isActive?string('text-green-600', 'text-red-600')}">
                        <i class="fas ${profile.user.isActive?string('fa-check-circle', 'fa-times-circle')} mr-1"></i>
                        ${profile.user.isActive?string('Активный', 'Неактивный')}
                    </div>
                </div>
                <#if profile.specialization?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                        <div class="text-sm font-semibold text-blue-800"><i class="fas fa-laptop-code mr-2"></i>Специализация</div>
                        <div class="text-gray-700 break-words">${profile.specialization}</div>
                    </div>
                </#if>
                <#if profile.organizationName?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                        <div class="text-sm font-semibold text-blue-800"><i class="fas fa-building mr-2"></i>Организация</div>
                        <div class="text-gray-700 break-words">${profile.organizationName}</div>
                    </div>
                </#if>
                <#if profile.department?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                        <div class="text-sm font-semibold text-blue-800"><i class="fas fa-building mr-2"></i>Отделение</div>
                        <div class="text-gray-700 break-words">${profile.department}</div>
                    </div>
                </#if>
                <#if profile.qualifications?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                        <div class="text-sm font-semibold text-blue-800"><i class="fas fa-certificate mr-2"></i>Квалификация</div>
                        <div class="text-gray-700 break-words">${profile.qualifications}</div>
                    </div>
                </#if>
                <#if profile.organization?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200">
                        <div class="text-sm font-semibold text-blue-800"><i class="fas fa-building mr-2"></i>Код организации</div>
                        <div class="text-gray-700 break-words">${profile.organization.code}</div>
                    </div>
                    <#if profile.organization.description?has_content>
                        <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200 col-span-1 sm:col-span-2">
                            <div class="text-sm font-semibold text-blue-800"><i class="fas fa-info-circle mr-2"></i>Описание организации</div>
                            <div class="text-gray-700 break-words">${profile.organization.description}</div>
                        </div>
                    </#if>
                </#if>
                <#if profile.bio?has_content>
                    <div class="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-200 col-span-1 sm:col-span-2">
                        <div class="text-sm font-semibold text-blue-800"><i class="fas fa-info-circle mr-2"></i>О себе</div>
                        <div class="text-gray-700 break-words">${profile.bio}</div>
                    </div>
                </#if>
            </div>
        </div>

        <#if profile.user.role.name == "STUDENT">
            <div class="mb-8">
                <h2 class="text-2xl font-semibold text-gray-900 text-center mb-6">
                    <i class="fas fa-chart-bar mr-2 text-blue-600"></i>Статистика посещаемости
                </h2>
                <div class="bg-white shadow-sm rounded-lg overflow-hidden">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-blue-50">
                        <tr>
                            <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">Курс</th>
                            <th class="hidden">Пропущено</th>
                            <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">Пропуски</th>
                            <th class="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">Статус</th>
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
                                                <div class="bg-blue-600 h-2.5 rounded-full" style="width: ${stat.attendancePercentage}%"></div>
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
                                <td colspan="4" class="px-4 py-3 text-center text-sm text-gray-500">Нет данных по статистике.</td>
                            </tr>
                        </#if>

                        </tbody>
                    </table>
                </div>

                <#if testResults?? && testResults?size gt 0>
                    <h2 class="text-2xl font-semibold text-gray-900 text-center mt-8 mb-6">Результаты тестов</h2>
                    <div class="bg-white shadow-sm rounded-lg overflow-hidden">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-blue-50">
                            <tr>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Курс</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Оценка</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Дата сдачи</th>
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
                    <i class="fas fa-book mr-2 text-blue-600"></i>Курсы преподавателя
                </h2>
                <#if courses?size == 0>
                    <div class="p-4 bg-blue-100 text-blue-700 rounded-lg text-center">У преподавателя нет курсов.</div>
                <#else>
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                        <#list courses as course>
                            <div class="relative bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                                <i class="fas fa-book-open absolute top-4 left-4 text-blue-200 text-xl opacity-50 group-hover:opacity-75 transition-opacity"></i>
                                <span class="absolute top-4 right-4 px-2 py-1 text-xs font-semibold text-white rounded-full ${course.isActive?string('bg-blue-600', 'bg-red-600')}">
                                    ${course.isActive?string('Активный', 'Завершён')}
                                </span>
                                <a href="/admin/course-instances/${course.courseInstanceId}" class="block text-decoration-none text-gray-900">
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
                    <i class="fas fa-users mr-2 text-blue-600"></i>Студенты организации
                </h2>
                <div class="bg-white shadow-sm rounded-lg overflow-hidden">
                    <table class="min-w-full divide-y divide-gray-200" id="studentsTable">
                        <thead class="bg-blue-50">
                        <tr>
                            <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">ФИО</th>
                            <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Email</th>
                            <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Телефон</th>
                            <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Курсы</th>
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
                                                    <#if c.finalGrade??>, оценка: ${c.finalGrade}</#if>
                                                </li>
                                            </#list>
                                        </ul>
                                    </td>
                                </tr>
                            </#list>
                        <#else>
                            <tr>
                                <td colspan="4" class="px-4 py-3 text-center text-sm text-gray-500">Нет студентов в организации.</td>
                            </tr>
                        </#if>
                        </tbody>
                    </table>
                </div>
                <script>
                    $(document).ready(function () {
                        $('#studentsTable').DataTable({
                            language: { url: '/js/datatables/ru.json', paginate: { previous: '‹', next: '›' } },
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