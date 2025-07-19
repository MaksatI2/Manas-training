<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Профиль", "url": "/student/profile"},
    {"label": "Статистика", "url": ""}
    ] />

    <style>
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

    <div class="statistics-container">
        <h2 class="statistics-title">
            <i class="fas fa-chart-bar" style="color: var(--primary-blue); margin-right: 0.5rem;"></i>
            Моя статистика посещаемости
        </h2>

        <table class="stats-table">
            <thead>
            <tr>
                <th>Курс</th>
                <th>Всего часов</th>
                <th>Пропущено</th>
                <th>Пропуски</th>
                <th>Статус</th>
            </tr>
            </thead>
            <tbody>

            <#list attendanceStatsList as stat>
                <tr <#if !stat.courseInstance.isActive>style="background-color: #f8d7da;"</#if>>
                    <td>${stat.courseInstance.title}</td>
                    <td>${stat.totalHours}</td>
                    <td>${stat.absentHours}</td>
                    <td>
                        ${stat.attendancePercentage}%
                        <div class="percentage-bar">
                            <div class="percentage-fill" style="width: ${stat.attendancePercentage}%;"></div>
                        </div>
                    </td>
                    <td>
                        <#if stat.enrollmentStatus == "DROPPED">
                            <span class="status-dropped">${stat.localisedStatus}</span>
                        <#else>
                            <span class="status-enrolled">${stat.localisedStatus}</span>
                        </#if>
                    </td>
                </tr>
            </#list>
            <#if attendanceStatsList?size == 0>
                <tr>
                    <td colspan="5">Нет данных по статистике.</td>
                </tr>
            </#if>
            </tbody>
        </table>

        <#if testResults?? && (testResults?size > 0)>
            <div class="test-results">
                <h2 style="margin-bottom: 1rem;" class="statistics-title">Результаты тестов</h2>
                <table style="width: 100%; border-collapse: collapse; text-align: left;">
                    <thead>
                    <tr style="background-color: #f0f8ff;">
                        <th style="padding: 0.75rem; border-bottom: 2px solid #ccc;">Курс</th>
                        <th style="padding: 0.75rem; border-bottom: 2px solid #ccc;">Тест</th>
                        <th style="padding: 0.75rem; border-bottom: 2px solid #ccc;">Оценка</th>
                        <th style="padding: 0.75rem; border-bottom: 2px solid #ccc;">Статус</th>
                        <th style="padding: 0.75rem; border-bottom: 2px solid #ccc;">Дата сдачи</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list testResults as result>
                        <tr style="
                                background-color: ${result.isPassed?string('#d4edda', '#f8d7da')};
                                color: ${result.isPassed?string('#155724', '#721c24')};
                                ">
                            <td style="padding: 0.75rem; border-bottom: 1px solid #eee;">${result.courseTitle}</td>
                            <td style="padding: 0.75rem; border-bottom: 1px solid #eee;">${result.testTitle}</td>
                            <td style="padding: 0.75rem; border-bottom: 1px solid #eee;">${result.score}%</td>
                            <td style="padding: 0.75rem; border-bottom: 1px solid #eee;">
                                <#if result.isPassed>
                                    Пройден
                                <#else>
                                    Не пройден
                                </#if>
                            </td>
                            <td style="padding: 0.75rem; border-bottom: 1px solid #eee;">
                                <#if result.submittedAt??>
                                    ${result.localisedTime}
                                <#else>
                                    —
                                </#if>
                            </td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </#if>


    </div>
</@layout.page>
