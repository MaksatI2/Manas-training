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
    <div class="container-fluid my-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="display-5 fw-bold text-primary mb-1">Аналитика урока</h1>
                        <h2 class="h4 text-muted">${analytics.lessonTitle}</h2>
                    </div>
                    <button onclick="window.history.back()" class="btn btn-outline-primary">
                        <i class="fas fa-arrow-left me-2"></i>Назад
                    </button>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-chart-line me-2"></i>Общая статистика</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-4">
                            <div class="col-md-6 col-lg-3">
                                <div class="stat-card bg-info">
                                    <div class="stat-icon">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h3>${analytics.totalDurationMinutes}</h3>
                                        <p>Минут урока</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-3">
                                <div class="stat-card bg-success">
                                    <div class="stat-icon">
                                        <i class="fas fa-users"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h3>${analytics.totalParticipants}</h3>
                                        <p>Участников</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-3">
                                <div class="stat-card bg-warning">
                                    <div class="stat-icon">
                                        <i class="fas fa-percentage"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h3>${analytics.averageParticipationPercentage}%</h3>
                                        <p>Средняя активность</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-3">
                                <div class="stat-card bg-purple">
                                    <div class="stat-icon">
                                        <i class="fas fa-user-tie"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h3>1</h3>
                                        <p>Преподаватель</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-4">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <span class="info-label">
                                        <i class="fas fa-calendar me-2"></i>Время начала:
                                    </span>
                                    <span class="info-value">
                                        ${analytics.startedAt}
                                    </span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <span class="info-label">
                                        <i class="fas fa-calendar me-2"></i>Время окончания:
                                    </span>
                                    <span class="info-value">
                                        <#if analytics.endedAt??>
                                            ${analytics.endedAt}
                                        <#else>
                                            <span class="text-warning">Урок активен</span>
                                        </#if>
                                    </span>
                                </div>
                            </div>
                            <div class="col-12 mt-2">
                                <div class="info-item">
                                    <span class="info-label">
                                        <i class="fas fa-chalkboard-teacher me-2"></i>Преподаватель:
                                    </span>
                                    <span class="info-value fw-semibold">
                                        ${analytics.teacherName}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-secondary text-white">
                        <h5 class="mb-0"><i class="fas fa-users me-2"></i>Детальная аналитика участников</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-dark">
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
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="participant-avatar me-2">
                                                    <#if participant.userRole == "TEACHER">
                                                        <i class="fas fa-chalkboard-teacher text-primary"></i>
                                                    <#elseif participant.userRole == "STUDENT">
                                                        <i class="fas fa-user-graduate text-success"></i>
                                                    <#else>
                                                        <i class="fas fa-user text-secondary"></i>
                                                    </#if>
                                                </div>
                                                <div>
                                                    <div class="fw-semibold">${participant.participantName}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <#if participant.userRole == "TEACHER">
                                                <span class="badge bg-primary">Преподаватель</span>
                                            <#elseif participant.userRole == "STUDENT">
                                                <span class="badge bg-success">Студент</span>
                                            <#else>
                                                <span class="badge bg-secondary">Гость</span>
                                            </#if>
                                        </td>
                                        <td>
                                            <small class="text-muted">
                                                <#if participant.joinedAt?is_date_like>
                                                    ${participant.joinedAt}
                                                <#else>
                                                    ${participant.joinedAt}
                                                </#if>
                                            </small>
                                        </td>
                                        <td>
                                            <small class="text-muted">
                                                <#if participant.leftAt??>
                                                    <#if participant.leftAt?is_date_like>
                                                        ${participant.leftAt}
                                                    <#else>
                                                        ${participant.leftAt}
                                                    </#if>
                                                <#else>
                                                    <span class="text-warning">Активен</span>
                                                </#if>
                                            </small>
                                        </td>
                                        <td>
                                            <span class="fw-semibold">${participant.totalDurationMinutes} мин</span>
                                        </td>
                                        <td>

                                        </td>
                                        <td>
                                            <span class="badge bg-info">${participant.activePings}/${participant.totalPings}</span>
                                        </td>
                                        <td>
                                            <#if participant.wasFullyPresent>
                                                <span class="badge bg-success">
                                                        <i class="fas fa-check-circle me-1"></i>Полное присутствие
                                                    </span>
                                            <#else>
                                                <span class="badge bg-warning">
                                                        <i class="fas fa-exclamation-circle me-1"></i>Частичное присутствие
                                                    </span>
                                            </#if>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary"
                                                    type="button"
                                                    data-bs-toggle="collapse"
                                                    data-bs-target="#details-${participant.participantId}"
                                                    aria-expanded="false">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr class="collapse" id="details-${participant.participantId}">
                                        <td colspan="9" class="bg-light">
                                            <div class="p-3">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <h6 class="text-primary mb-3">
                                                            <i class="fas fa-info-circle me-2"></i>Детальная информация
                                                        </h6>
                                                        <div class="detail-info">
                                                            <div class="detail-item">
                                                                <span class="detail-label">Активный период:</span>
                                                                <span class="detail-value">${participant.activePeriodMinutes} минут</span>
                                                            </div>
                                                            <#if participant.firstPing??>
                                                                <div class="detail-item">
                                                                    <span class="detail-label">Первый пинг:</span>
                                                                    <span class="detail-value">
                                                                        <#if participant.firstPing?is_date_like>
                                                                            ${participant.firstPing}
                                                                        <#else>
                                                                            ${participant.firstPing}
                                                                        </#if>
                                                                    </span>
                                                                </div>
                                                            </#if>
                                                            <#if participant.lastPing??>
                                                                <div class="detail-item">
                                                                    <span class="detail-label">Последний пинг:</span>
                                                                    <span class="detail-value">
                                                                        <#if participant.lastPing?is_date_like>
                                                                            ${participant.lastPing}
                                                                        <#else>
                                                                            ${participant.lastPing}
                                                                        </#if>
                                                                    </span>
                                                                </div>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <#if participant.inactiveGaps?has_content>
                                                            <h6 class="text-warning mb-3">
                                                                <i class="fas fa-exclamation-triangle me-2"></i>Периоды неактивности
                                                            </h6>
                                                            <div class="inactive-gaps">
                                                                <#list participant.inactiveGaps as gap>
                                                                    <div class="gap-item mb-2 p-2 bg-warning bg-opacity-10 rounded">
                                                                        <div class="gap-time">
                                                                            <strong>
                                                                                <#if gap.gapStartTime?is_date_like>
                                                                                    ${gap.gapStartTime}
                                                                                <#else>
                                                                                    ${gap.gapStartTime}
                                                                                </#if>
                                                                                -
                                                                                <#if gap.gapEndTime?is_date_like>
                                                                                    ${gap.gapEndTime}
                                                                                <#else>
                                                                                    ${gap.gapEndTime}
                                                                                </#if>
                                                                            </strong>
                                                                            <span class="text-muted">(${gap.gapDurationMinutes} мин)</span>
                                                                        </div>
                                                                        <div class="gap-reason">
                                                                            <small class="text-muted">
                                                                                Причина:
                                                                                <#if gap.reason == "INACTIVE">
                                                                                    Неактивен
                                                                                <#elseif gap.reason == "NO_PING">
                                                                                    Нет пинга
                                                                                <#elseif gap.reason == "NO_FINAL_PING">
                                                                                    Нет финального пинга
                                                                                <#else>
                                                                                    ${gap.reason}
                                                                                </#if>
                                                                            </small>
                                                                        </div>
                                                                    </div>
                                                                </#list>
                                                            </div>
                                                        <#else>
                                                            <h6 class="text-success mb-3">
                                                                <i class="fas fa-check-circle me-2"></i>Без разрывов связи
                                                            </h6>
                                                            <p class="text-muted">Участник был активен на протяжении всего урока</p>
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
        </div>

        <div class="row mt-4">
            <div class="col-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Визуализация активности</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="participationChart" width="400" height="200"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .stat-card {
            display: flex;
            align-items: center;
            padding: 1.5rem;
            border-radius: 0.75rem;
            color: white;
            height: 100%;
            min-height: 120px;
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-right: 1rem;
            opacity: 0.8;
        }

        .stat-content h3 {
            font-size: 2rem;
            font-weight: bold;
            margin: 0;
            line-height: 1.2;
        }

        .stat-content p {
            margin: 0;
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .bg-purple {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .info-label {
            font-weight: 500;
            min-width: 150px;
            color: #6c757d;
        }

        .info-value {
            flex: 1;
        }

        .participant-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .progress {
            min-width: 100px;
        }

        .detail-info {
            display: grid;
            gap: 0.5rem;
        }

        .detail-item {
            display: grid;
            grid-template-columns: 1fr 1fr;
            align-items: center;
        }

        .detail-label {
            font-weight: 500;
            color: #6c757d;
        }

        .detail-value {
            color: #212529;
        }

        .gap-item {
            border-left: 4px solid #ffc107;
        }

        .table td, .table th {
            vertical-align: middle;
        }

        .chart-container {
            position: relative;
            height: 300px;
        }

        @media (max-width: 768px) {
            .stat-card {
                flex-direction: column;
                text-align: center;
                min-height: 140px;
            }

            .stat-icon {
                margin-right: 0;
                margin-bottom: 0.5rem;
            }

            .info-item {
                flex-direction: column;
                align-items: flex-start;
            }

            .info-label {
                min-width: auto;
                margin-bottom: 0.25rem;
            }

            .detail-item {
                grid-template-columns: 1fr;
                gap: 0.25rem;
            }
        }

        .table-responsive {
            border-radius: 0.375rem;
        }

        .badge {
            font-size: 0.75rem;
        }

        .progress-bar {
            font-size: 0.75rem;
            font-weight: 600;
        }
    </style>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const participants = [
                <#list analytics.participantAnalytics as participant>
                {
                    name: '${participant.participantName?js_string}',
                    participation: ${participant.participationPercentage},
                    role: '${participant.userRole?js_string}',
                    duration: ${participant.totalDurationMinutes}
                }<#if participant?has_next>,</#if>
                </#list>
            ];

            const colors = participants.map(p => {
                switch(p.role) {
                    case 'TEACHER': return '#0d6efd';
                    case 'STUDENT': return '#198754';
                    default: return '#6c757d';
                }
            });

            const ctx = document.getElementById('participationChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: participants.map(p => p.name),
                    datasets: [{
                        label: 'Процент активности',
                        data: participants.map(p => p.participation),
                        backgroundColor: colors,
                        borderColor: colors,
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
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
                            ticks: {
                                callback: function(value) {
                                    return value + '%';
                                }
                            }
                        },
                        x: {
                            ticks: {
                                maxRotation: 45,
                                minRotation: 0
                            }
                        }
                    }
                }
            });
        });
    </script>
</@layout.page>