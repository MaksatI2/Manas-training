<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring/>

<#assign bcHome><@spring.message code='teacher.course.statistics.breadcrumb.home'/></#assign>
<#assign bcMyCourses><@spring.message code='teacher.course.statistics.breadcrumb.myCourses'/></#assign>
<#assign bcCourse><@spring.message code='teacher.course.statistics.breadcrumb.course'/></#assign>
<#assign bcStatistics><@spring.message code='teacher.course.statistics.breadcrumb.statistics'/></#assign>

<#assign attendanceTitle><@spring.message code='teacher.course.statistics.attendance.title'/></#assign>
<#assign thStudent><@spring.message code='teacher.course.statistics.attendance.header.student'/></#assign>
<#assign thAbsentHours><@spring.message code='teacher.course.statistics.attendance.header.absentHours'/></#assign>
<#assign thAbsentPercent><@spring.message code='teacher.course.statistics.attendance.header.absentPercent'/></#assign>
<#assign thStatus><@spring.message code='teacher.course.statistics.attendance.header.status'/></#assign>

<#assign testsTitle><@spring.message code='teacher.course.statistics.tests.title'/></#assign>
<#assign testsThName><@spring.message code='teacher.course.statistics.tests.header.name'/></#assign>
<#assign testsThTest><@spring.message code='teacher.course.statistics.tests.header.test'/></#assign>
<#assign testsThScore><@spring.message code='teacher.course.statistics.tests.header.score'/></#assign>
<#assign testsThStatus><@spring.message code='teacher.course.statistics.tests.header.status'/></#assign>
<#assign testsThDate><@spring.message code='teacher.course.statistics.tests.header.date'/></#assign>
<#assign statusPassed><@spring.message code='teacher.course.statistics.tests.status.passed'/></#assign>
<#assign statusFailed><@spring.message code='teacher.course.statistics.tests.status.failed'/></#assign>
<#assign testsNoDate><@spring.message code='teacher.course.statistics.tests.noDate'/></#assign>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMyCourses, "url": "/teacher/my-courses"},
    {"label": "${courseInstance.title}", "url": "/teacher/course/${courseInstance.id}"},
    {"label": bcStatistics, "url": "/"}
    ] />
    <div class="statistics-container">
        <h2 class="statistics-title">
            <i class="fas fa-chart-bar" style="color: var(--primary-blue); margin-right: 0.5rem;"></i>
            ${attendanceTitle}</h2>
        <table class="stats-table">
            <thead>
            <tr>
                <th>${thStudent}</th>
                <th>${thAbsentHours}</th>
                <th>${thAbsentPercent}</th>
                <th>${thStatus}</th>
            </tr>
            </thead>
            <tbody>
            <#list attendanceStatsList as stat>
                <tr class="<#if (stat.attendancePercentage >= 30)>attendance-bad<#else>attendance-good</#if>">
                    <td>${stat.student.name} ${stat.student.lastName}</td>
                    <td>${stat.absentHours}</td>
                    <td>${stat.attendancePercentage?string("0.0")}%
                        <div class="percentage-bar">
                            <div class="percentage-fill" style="width: ${stat.attendancePercentage}%;"></div>
                        </div>
                    </td>
                    <td><#if stat.enrollmentStatus == "DROPPED">
                            <span class="status-dropped">${stat.localisedStatus}</span>
                        <#else>
                            <span class="status-enrolled">${stat.localisedStatus}</span>
                        </#if></td>
                </tr>
            </#list>
            </tbody>
        </table>

        <#if results?? && (results?size > 0)>
            <div class="test-results">
                <h2 style="margin-bottom: 1rem;" class="statistics-title">${testsTitle}</h2>
                <table style="width: 100%; border-collapse: collapse; text-align: left;">
                    <thead>
                    <tr style="background-color: #f0f8ff;">
                        <th style="padding: 0.75rem; border-bottom: 2px solid #ccc;">${testsThName}</th>
                        <th style="padding: 0.75rem; border-bottom: 2px solid #ccc;">${testsThTest}</th>
                        <th style="padding: 0.75rem; border-bottom: 2px solid #ccc;">${testsThScore}</th>
                        <th style="padding: 0.75rem; border-bottom: 2px solid #ccc;">${testsThStatus}</th>
                        <th style="padding: 0.75rem; border-bottom: 2px solid #ccc;">${testsThDate}</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list results as result>
                        <tr style="
                                background-color: ${result.isPassed?string('#d4edda', '#f8d7da')};
                                color: ${result.isPassed?string('#155724', '#721c24')};
                                ">
                            <td style="padding: 0.75rem; border-bottom: 1px solid #eee;">${result.studentName}</td>
                            <td style="padding: 0.75rem; border-bottom: 1px solid #eee;">${result.testTitle}</td>
                            <td style="padding: 0.75rem; border-bottom: 1px solid #eee;">${result.score}</td>
                            <td style="padding: 0.75rem; border-bottom: 1px solid #eee;">
                                <#if result.isPassed>
                                    ${statusPassed}
                                <#else>
                                    ${statusFailed}
                                </#if>
                            </td>
                            <td style="padding: 0.75rem; border-bottom: 1px solid #eee;">
                                <#if result.submittedAt??>
                                    ${result.localisedTime}
                                <#else>
                                    ${testsNoDate}
                                </#if>
                            </td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </#if>
    </div>

    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin-bottom: 30px;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f0f0f0;
        }

        .passed {
            background-color: #d4edda;
        }

        .failed {
            background-color: #f8d7da;
        }

        .attendance-good {
        }

        .attendance-bad {
            background-color: #f8d7da;
        }

        .statistics-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .statistics-title {
            font-size: 2.5rem;
            text-align: center;
            margin-bottom: 2rem;
        }

        .stats-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 3rem;
        }

        .stats-table th,
        .stats-table td {
            padding: 1rem;
            border: 1px solid #e1ecf4;
            text-align: center;
        }

        .stats-table th {
            background-color: #f0f8ff;
            color: #003366;
            text-transform: uppercase;
            font-weight: 600;
        }

        .stats-table td {
            font-size: 1rem;
        }

        .status-enrolled {
            color: #28a745;
            font-weight: 600;
        }

        .status-dropped {
            color: #dc3545;
            font-weight: 600;
        }

        .percentage-bar {
            background-color: #e6f2ff;
            border-radius: 5px;
            overflow: hidden;
            height: 20px;
            margin-top: 5px;
        }

        .percentage-fill {
            height: 100%;
            background-color: #007bff;
            transition: width 0.4s ease;
        }

        @media (max-width: 768px) {
            .statistics-title {
                font-size: 2rem;
            }

            .stats-table th,
            .stats-table td {
                font-size: 0.9rem;
                padding: 0.7rem;
            }
        }
    </style>
</@layout.page>