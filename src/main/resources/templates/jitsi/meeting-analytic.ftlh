<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<#assign known = Session.SPRING_SECURITY_CONTEXT??>
<#if known>
    <#assign user = Session.SPRING_SECURITY_CONTEXT.authentication.principal>
    <#assign roles = user.getAuthorities()?join(",")>
    <#assign isAdmin = roles?contains("ADMIN")>
    <#assign isTeacher = roles?contains("TEACHER")>
</#if>

<@layout.page>
    <div class="analytics-container">
        <div class="analytics-header">
            <div class="header-content">
                <div class="header-text">
                    <h1 class="page-title">Аналитика урока</h1>
                    <h2 class="lesson-title">${analytics.lessonTitle}</h2>
                </div>
                <button onclick="window.history.back()" class="btn-back">
                    <i class="fas fa-arrow-left"></i>
                    Вернуться назад
                </button>
            </div>
        </div>

        <div class="statistics-section">
            <div class="section-card">
                <div class="card-header">
                    <i class="fas fa-chart-line"></i>
                    <h3>Общая статистика урока</h3>
                </div>
                <div class="card-body">
                    <div class="stats-grid">
                        <div class="stat-item stat-duration">
                            <div class="stat-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-content">
                                <h4>${analytics.totalDurationMinutes}</h4>
                                <p>Минут урока</p>
                            </div>
                        </div>
                        <div class="stat-item stat-participants">
                            <div class="stat-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-content">
                                <h4>${analytics.totalParticipants}</h4>
                                <p>Участников</p>
                            </div>
                        </div>
                        <div class="stat-item stat-activity">
                            <div class="stat-icon">
                                <i class="fas fa-percentage"></i>
                            </div>
                            <div class="stat-content">
                                <h4>${analytics.averageParticipationPercentage}%</h4>
                                <p>Средняя активность</p>
                            </div>
                        </div>
                        <div class="stat-item stat-teacher">
                            <div class="stat-icon">
                                <i class="fas fa-chalkboard-teacher"></i>
                            </div>
                            <div class="stat-content">
                                <h4>1</h4>
                                <p>Преподаватель</p>
                            </div>
                        </div>
                    </div>

                    <div class="lesson-info">
                        <div class="info-row">
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-calendar-alt"></i>Время начала:
                                </span>
                                <span class="info-value">
                                    ${analytics.startedAtFormatted}
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-calendar-check"></i>Время окончания:
                                </span>
                                <span class="info-value">
                                    <#if analytics.endedAt??>
                                        ${analytics.endedAtFormatted}
                                    <#else>
                                        <span class="status-active">Урок активен</span>
                                    </#if>
                                </span>
                            </div>
                        </div>
                        <div class="info-item teacher-info">
                            <span class="info-label">
                                <i class="fas fa-user-tie"></i>Преподаватель:
                            </span>
                            <span class="info-value teacher-name">
                                ${analytics.teacherName}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="participants-section">
            <div class="section-card">
                <div class="card-header">
                    <i class="fas fa-users-cog"></i>
                    <h3>Детальная аналитика участников</h3>
                </div>
                <div class="card-body">
                    <div class="table-container">
                        <table class="participants-table">
                            <thead>
                            <tr>
                                <th>Участник</th>
                                <th>Роль</th>
                                <th>Время входа</th>
                                <th>Время выхода</th>
                                <th>Длительность</th>
                                <th>Активность</th>
                                <th>Пинги</th>
                                <th>Статус</th>
                                <th>Детали</th>
                            </tr>
                            </thead>
                            <tbody>
                            <#list analytics.participantAnalytics as participant>
                                <tr class="participant-row">
                                    <td>
                                        <div class="participant-info">
                                            <div class="participant-avatar ${participant.userRole?lower_case}">
                                                <#if participant.userRole == "TEACHER">
                                                    <i class="fas fa-chalkboard-teacher"></i>
                                                <#elseif participant.userRole == "STUDENT">
                                                    <i class="fas fa-user-graduate"></i>
                                                <#else>
                                                    <i class="fas fa-user"></i>
                                                </#if>
                                            </div>
                                            <div class="participant-name">
                                                ${participant.participantName}
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <#if participant.userRole == "TEACHER">
                                            <span class="role-badge teacher">Преподаватель</span>
                                        <#elseif participant.userRole == "STUDENT">
                                            <span class="role-badge student">Студент</span>
                                        <#else>
                                            <span class="role-badge guest">Гость</span>
                                        </#if>
                                    </td>
                                    <td class="time-cell">
                                        <#if participant.joinedAt?is_date_like>
                                            ${participant.joinedAtFormatted}
                                        <#else>
                                            ${participant.joinedAtFormatted}
                                        </#if>
                                    </td>
                                    <td class="time-cell">
                                        <#if participant.leftAt??>
                                            <#if participant.leftAt?is_date_like>
                                                ${participant.leftAtFormatted}
                                            <#else>
                                                ${participant.leftAtFormatted}
                                            </#if>
                                        <#else>
                                            <span class="status-active">Активен</span>
                                        </#if>
                                    </td>
                                    <td class="duration-cell">
                                        ${participant.totalDurationMinutes} мин
                                    </td>
                                    <td>
                                        <div class="activity-indicator">
                                            <div class="progress-container">
                                                <div class="progress-bar" style="width: ${(participant.participationPercentage)!0}%"></div>
                                            </div>
                                            <span class="activity-percentage">${(participant.participationPercentage)!0}%</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="ping-badge">${participant.activePings}/${participant.totalPings}</span>
                                    </td>
                                    <td>
                                        <#if participant.wasFullyPresent>
                                            <span class="status-badge full-presence">
                                                    <i class="fas fa-check-circle"></i>Полное присутствие
                                                </span>
                                        <#else>
                                            <span class="status-badge partial-presence">
                                                    <i class="fas fa-exclamation-triangle"></i>Частичное присутствие
                                                </span>
                                        </#if>
                                    </td>
                                    <td>
                                        <button class="btn-details"
                                                data-bs-toggle="collapse"
                                                data-bs-target="#details-${participant.participantId}"
                                                aria-expanded="false">
                                            <i class="fas fa-chevron-down"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr class="collapse details-row" id="details-${participant.participantId}">
                                    <td colspan="9">
                                        <div class="details-content">
                                            <div class="details-grid">
                                                <div class="details-info">
                                                    <h5 class="details-title">
                                                        <i class="fas fa-info-circle"></i>Детальная информация
                                                    </h5>
                                                    <div class="detail-items">
                                                        <div class="detail-item">
                                                            <span class="detail-label">Активный период:</span>
                                                            <span class="detail-value">${participant.activePeriodMinutes} минут</span>
                                                        </div>
                                                        <#if participant.firstPing??>
                                                            <div class="detail-item">
                                                                <span class="detail-label">Первый пинг:</span>
                                                                <span class="detail-value">
                                                                        <#if participant.firstPing?is_date_like>
                                                                            ${participant.firstPingFormatted}
                                                                        <#else>
                                                                            ${participant.firstPingFormatted}
                                                                        </#if>
                                                                    </span>
                                                            </div>
                                                        </#if>
                                                        <#if participant.lastPing??>
                                                            <div class="detail-item">
                                                                <span class="detail-label">Последний пинг:</span>
                                                                <span class="detail-value">
                                                                        <#if participant.lastPing?is_date_like>
                                                                            ${participant.lastPingFormatted}
                                                                        <#else>
                                                                            ${participant.lastPingFormatted}
                                                                        </#if>
                                                                    </span>
                                                            </div>
                                                        </#if>
                                                    </div>
                                                </div>
                                                <div class="gaps-info">
                                                    <#if participant.inactiveGaps?has_content>
                                                        <h5 class="details-title warning">
                                                            <i class="fas fa-exclamation-triangle"></i>Периоды неактивности
                                                        </h5>
                                                        <div class="gaps-list">
                                                            <#list participant.inactiveGaps as gap>
                                                                <div class="gap-item">
                                                                    <div class="gap-time">
                                                                        <strong>
                                                                            <#if gap.gapStartTime?is_date_like>
                                                                                ${gap.gapStartTimeFormatted}
                                                                            <#else>
                                                                                ${gap.gapStartTimeFormatted}
                                                                            </#if>
                                                                            -
                                                                            <#if gap.gapEndTime?is_date_like>
                                                                                ${gap.gapEndTimeFormatted}
                                                                            <#else>
                                                                                ${gap.gapEndTimeFormatted}
                                                                            </#if>
                                                                        </strong>
                                                                        <span class="gap-duration">(${gap.gapDurationMinutes} мин)</span>
                                                                    </div>
                                                                    <div class="gap-reason">
                                                                        <#if gap.reason == "INACTIVE">
                                                                            Неактивен
                                                                        <#elseif gap.reason == "NO_PING">
                                                                            Нет пинга
                                                                        <#elseif gap.reason == "NO_FINAL_PING">
                                                                            Нет финального пинга
                                                                        <#else>
                                                                            ${gap.reason}
                                                                        </#if>
                                                                    </div>
                                                                </div>
                                                            </#list>
                                                        </div>
                                                    <#else>
                                                        <h5 class="details-title success">
                                                            <i class="fas fa-check-circle"></i>Без разрывов связи
                                                        </h5>
                                                        <p class="no-gaps-text">Участник был активен на протяжении всего урока</p>
                                                    </#if>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </#list>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="chart-section">
            <div class="section-card">
                <div class="card-header">
                    <i class="fas fa-chart-bar"></i>
                    <h3>Визуализация активности участников</h3>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="participationChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        :root {
            --primary-blue: #0066cc;
            --light-blue: #87ceeb;
            --white: #ffffff;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --light-gray: #f8f9fa;
            --border-gray: #dee2e6;
        }

        .analytics-container {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
            color: var(--text-dark);
        }

        .analytics-header {
            margin-bottom: 2rem;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 2rem;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-blue);
            margin: 0 0 0.5rem 0;
            line-height: 1.2;
        }

        .lesson-title {
            font-size: 1.2rem;
            color: var(--text-dark);
            margin: 0;
            font-weight: 400;
        }

        .btn-back {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            border: none;
            border-radius: 25px;
            padding: 0.8rem 2rem;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
        }

        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,102,204,0.3);
        }

        .section-card {
            background: var(--white);
            border-radius: 15px;
            border-left: 4px solid var(--primary-blue);
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
            margin-bottom: 2rem;
            transition: all 0.3s ease;
        }

        .section-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,102,204,0.15);
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            padding: 1.5rem 2rem;
            border-radius: 15px 15px 0 0;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .card-header i {
            font-size: 1.5rem;
        }

        .card-header h3 {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 600;
        }

        .card-body {
            padding: 2rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-item {
            background: var(--white);
            border-radius: 10px;
            padding: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid var(--primary-blue);
        }

        .stat-duration { border-left-color: var(--primary-blue); }
        .stat-participants { border-left-color: var(--success-color); }
        .stat-activity { border-left-color: var(--warning-color); }
        .stat-teacher { border-left-color: var(--dark-blue); }

        .stat-icon {
            font-size: 2.5rem;
            color: var(--primary-blue);
            width: 60px;
            text-align: center;
        }

        .stat-content h4 {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
            color: var(--text-dark);
        }

        .stat-content p {
            margin: 0;
            font-size: 0.9rem;
            color: #6c757d;
        }

        .lesson-info {
            background: var(--light-gray);
            border-radius: 10px;
            padding: 1.5rem;
            border-left: 4px solid var(--light-blue);
        }

        .info-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-bottom: 1rem;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-label {
            font-weight: 600;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            min-width: 150px;
        }

        .info-label i {
            color: var(--primary-blue);
        }

        .info-value {
            font-weight: 500;
        }

        .teacher-name {
            color: var(--primary-blue);
            font-weight: 600;
        }

        .status-active {
            color: var(--success-color);
            font-weight: 600;
        }

        .table-container {
            overflow-x: auto;
            border-radius: 10px;
            border: 1px solid var(--border-gray);
        }

        .participants-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        .participants-table thead {
            background: var(--dark-blue);
            color: var(--white);
        }

        .participants-table th,
        .participants-table td {
            padding: 1rem 0.75rem;
            text-align: left;
            vertical-align: middle;
            border-bottom: 1px solid var(--border-gray);
        }

        .participants-table th {
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .participant-row:hover {
            background-color: rgba(0,102,204,0.05);
        }

        .participant-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .participant-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .participant-avatar.teacher {
            background: rgba(0,102,204,0.1);
            color: var(--primary-blue);
        }

        .participant-avatar.student {
            background: rgba(40,167,69,0.1);
            color: var(--success-color);
        }

        .participant-avatar.guest {
            background: rgba(108,117,125,0.1);
            color: #6c757d;
        }

        .participant-name {
            font-weight: 600;
            color: var(--text-dark);
        }

        .role-badge {
            padding: 0.3rem 0.8rem;
            border-radius: 25px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .role-badge.teacher {
            background: rgba(0,102,204,0.1);
            color: var(--primary-blue);
        }

        .role-badge.student {
            background: rgba(40,167,69,0.1);
            color: var(--success-color);
        }

        .role-badge.guest {
            background: rgba(108,117,125,0.1);
            color: #6c757d;
        }

        .time-cell {
            font-size: 0.85rem;
            color: #6c757d;
        }

        .duration-cell {
            font-weight: 600;
            color: var(--text-dark);
        }

        .activity-indicator {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .progress-container {
            width: 80px;
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, var(--primary-blue), var(--light-blue));
            border-radius: 4px;
            transition: width 0.3s ease;
        }

        .activity-percentage {
            font-weight: 600;
            color: var(--primary-blue);
            min-width: 35px;
        }

        .ping-badge {
            background: rgba(0,102,204,0.1);
            color: var(--primary-blue);
            padding: 0.3rem 0.6rem;
            border-radius: 25px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .status-badge {
            padding: 0.3rem 0.8rem;
            border-radius: 25px;
            font-size: 0.75rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.3rem;
        }

        .status-badge.full-presence {
            background: rgba(40,167,69,0.1);
            color: var(--success-color);
        }

        .status-badge.partial-presence {
            background: rgba(255,193,7,0.1);
            color: var(--warning-color);
        }

        .btn-details {
            background: transparent;
            border: 1px solid var(--primary-blue);
            color: var(--primary-blue);
            border-radius: 25px;
            padding: 0.4rem 0.8rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-details:hover {
            background: var(--primary-blue);
            color: var(--white);
            transform: translateY(-1px);
        }

        .details-row {
            background: rgba(0,102,204,0.02);
        }

        .details-content {
            padding: 2rem;
        }

        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
        }

        .details-title {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--primary-blue);
        }

        .details-title.warning {
            color: var(--warning-color);
        }

        .details-title.success {
            color: var(--success-color);
        }

        .detail-items {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e9ecef;
        }

        .detail-label {
            font-weight: 500;
            color: #6c757d;
        }

        .detail-value {
            font-weight: 600;
            color: var(--text-dark);
        }

        .gaps-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .gap-item {
            background: rgba(255,193,7,0.1);
            border-left: 4px solid var(--warning-color);
            padding: 1rem;
            border-radius: 5px;
        }

        .gap-time {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.25rem;
        }

        .gap-duration {
            color: #6c757d;
            font-weight: normal;
        }

        .gap-reason {
            font-size: 0.85rem;
            color: #6c757d;
        }

        .no-gaps-text {
            color: #6c757d;
            font-style: italic;
            margin: 0;
        }

        .chart-container {
            position: relative;
            height: 400px;
            padding: 1rem;
        }

        @media (max-width: 768px) {
            .analytics-container {
                padding: 1rem;
            }

            .page-title {
                font-size: 2rem;
            }

            .header-content {
                flex-direction: column;
                gap: 1rem;
            }

            .card-body {
                padding: 1.5rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .info-row {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .details-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }

            .participants-table {
                font-size: 0.8rem;
            }

            .participants-table th,
            .participants-table td {
                padding: 0.75rem 0.5rem;
            }

            .activity-indicator {
                flex-direction: column;
                gap: 0.5rem;
                align-items: flex-start;
            }

            .chart-container {
                height: 300px;
            }
        }
    </style>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof Chart === 'undefined') {
                console.error('Chart.js не загружен');
                document.querySelector('.chart-container').innerHTML =
                    '<div class="text-center text-muted p-4">График недоступен: Chart.js не загружен</div>';
                return;
            }

            const participants = [
                <#list analytics.participantAnalytics as participant>
                {
                    name: '${participant.participantName?js_string}',
                    participation: ${participant.participationPercentage?c},
                    role: '${participant.userRole?js_string}',
                    duration: ${participant.totalDurationMinutes?c}
                }<#if participant?has_next>,</#if>
                </#list>
            ];

            if (participants.length === 0) {
                document.querySelector('.chart-container').innerHTML =
                    '<div style="text-align: center; color: #6c757d; padding: 2rem;">Нет данных для отображения</div>';
                return;
            }

            const colors = participants.map(p => {
                switch(p.role) {
                    case 'TEACHER': return '#0066cc';
                    case 'STUDENT': return '#28a745';
                    default: return '#6c757d';
                }
            });

            const backgroundColors = participants.map(p => {
                switch(p.role) {
                    case 'TEACHER': return 'rgba(0, 102, 204, 0.1)';
                    case 'STUDENT': return 'rgba(40, 167, 69, 0.1)';
                    default: return 'rgba(108, 117, 125, 0.1)';
                }
            });

            const ctx = document.getElementById('participationChart');
            if (!ctx) {
                console.error('Элемент canvas не найден');
                return;
            }

            const chartCtx = ctx.getContext('2d');

            try {
                new Chart(chartCtx, {
                    type: 'bar',
                    data: {
                        labels: participants.map(p => p.name),
                        datasets: [{
                            label: 'Активность участников (%)',
                            data: participants.map(p => p.participation),
                            backgroundColor: backgroundColors,
                            borderColor: colors,
                            borderWidth: 2,
                            borderRadius: 8,
                            borderSkipped: false,
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: true,
                                position: 'top',
                                labels: {
                                    font: {
                                        family: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
                                        size: 14,
                                        weight: '600'
                                    },
                                    color: '#2c3e50',
                                    padding: 20
                                }
                            },
                            tooltip: {
                                backgroundColor: 'rgba(44, 62, 80, 0.95)',
                                titleColor: '#ffffff',
                                bodyColor: '#ffffff',
                                borderColor: '#0066cc',
                                borderWidth: 2,
                                cornerRadius: 8,
                                titleFont: {
                                    family: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
                                    size: 14,
                                    weight: '600'
                                },
                                bodyFont: {
                                    family: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
                                    size: 13
                                },
                                callbacks: {
                                    title: function(context) {
                                        return context[0].label;
                                    },
                                    label: function(context) {
                                        return 'Активность: ' + context.parsed.y + '%';
                                    },
                                    afterLabel: function(context) {
                                        const participant = participants[context.dataIndex];
                                        return [
                                            'Длительность: ' + participant.duration + ' мин',
                                            'Роль: ' + (participant.role === 'TEACHER' ? 'Преподаватель' :
                                                participant.role === 'STUDENT' ? 'Студент' : 'Гость')
                                        ];
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                max: 100,
                                grid: {
                                    color: 'rgba(0, 102, 204, 0.1)',
                                    lineWidth: 1
                                },
                                ticks: {
                                    callback: function(value) {
                                        return value + '%';
                                    },
                                    color: '#2c3e50',
                                    font: {
                                        family: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
                                        size: 12,
                                        weight: '500'
                                    }
                                },
                                title: {
                                    display: true,
                                    text: 'Процент активности',
                                    color: '#2c3e50',
                                    font: {
                                        family: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
                                        size: 14,
                                        weight: '600'
                                    }
                                }
                            },
                            x: {
                                grid: {
                                    display: false
                                },
                                ticks: {
                                    maxRotation: 45,
                                    minRotation: 0,
                                    color: '#2c3e50',
                                    font: {
                                        family: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
                                        size: 12,
                                        weight: '500'
                                    }
                                },
                                title: {
                                    display: true,
                                    text: 'Участники',
                                    color: '#2c3e50',
                                    font: {
                                        family: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
                                        size: 14,
                                        weight: '600'
                                    }
                                }
                            }
                        },
                        elements: {
                            bar: {
                                borderWidth: 2,
                                borderRadius: 8,
                                borderSkipped: false,
                            }
                        },
                        animation: {
                            duration: 1500,
                            easing: 'easeInOutQuart'
                        }
                    }
                });
                console.log('График успешно создан');
            } catch (error) {
                console.error('Ошибка при создании графика:', error);
                document.querySelector('.chart-container').innerHTML =
                    '<div style="text-align: center; color: #dc3545; padding: 2rem;">Ошибка при создании графика</div>';
            }
        });

        document.addEventListener('click', function(e) {
            if (e.target.closest('.btn-details')) {
                const button = e.target.closest('.btn-details');
                const icon = button.querySelector('i');
                const isExpanded = button.getAttribute('aria-expanded') === 'true';

                if (isExpanded) {
                    icon.style.transform = 'rotate(0deg)';
                } else {
                    icon.style.transform = 'rotate(180deg)';
                }
            }
        });

        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        document.querySelectorAll('.stat-item, .section-card').forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            observer.observe(card);
        });
    </script>
</@layout.page>