<#import "../layout.ftlh" as layout>
<@layout.page>

    <h1 style="text-align: center; margin-bottom: 2rem;">Общая статистика системы</h1>

    <style>
        .stats-container {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            justify-content: center;
            margin-bottom: 3rem;
        }

        .stat-card {
            flex: 1 1 220px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            text-align: center;
        }

        .stat-title {
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: 0.5rem;
            color: #6c757d;
        }

        .stat-value {
            font-size: 1.8rem;
            color: #343a40;
        }

        .charts {
            max-width: 1000px;
            margin: 0 auto 3rem;
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            justify-content: center;
        }

        .chart-container {
            flex: 1 1 400px;
            max-width: 500px;
        }

        canvas {
            max-width: 100%;
        }

        #rolesPieChart {
            display: block;
            width: 400px !important;
            height: 400px !important;
            margin: 0 auto;
        }

        #barChart {
            display: block;
            width: 100% !important;
            height: 400px !important;
            margin: 0 auto;
        }

        @media (max-width: 768px) {
            .charts {
                flex-direction: column;
                align-items: center;
            }

            .chart-container {
                max-width: 400px;
            }
        }
    </style>

    <div class="stats-container">
        <div class="stat-card">
            <div class="stat-title">Студенты</div>
            <div class="stat-value">${userStats.totalStudents}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Преподаватели</div>
            <div class="stat-value">${userStats.totalTeachers}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Организации</div>
            <div class="stat-value">${userStats.totalOrganizations}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Курсы</div>
            <div class="stat-value">${userStats.totalCourses}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Тесты</div>
            <div class="stat-value">${userStats.totalTests}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Сертификаты</div>
            <div class="stat-value">${userStats.totalCertificates}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Неактивные пользователи</div>
            <div class="stat-value">${userStats.totalInactiveUsers}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Завершённые курсы</div>
            <div class="stat-value">${userStats.completedCourses}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Сертификаты в этом месяце</div>
            <div class="stat-value">${userStats.certificatesIssuedThisMonth}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Средний балл по тестам</div>
            <div class="stat-value">${userStats.averageTestScore?string("0.0")}%</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Пройденные тесты</div>
            <div class="stat-value">${userStats.totalPassedTests}</div>
        </div>
    </div>

    <div class="charts">
        <div class="chart-container">
            <h2 style="text-align:center; margin-bottom:1rem;">Соотношение ролей</h2>
            <canvas id="rolesPieChart"></canvas>
        </div>
        <div class="chart-container">
            <h2 style="text-align:center; margin-bottom:1rem;">Активность по категориям</h2>
            <canvas id="barChart"></canvas>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const pieCtx = document.getElementById('rolesPieChart').getContext('2d');
        new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: ['Студенты', 'Преподаватели', 'Организации', 'Неактивные'],
                datasets: [{
                    label: 'Пользователи',
                    data: [
                        ${userStats.totalStudents},
                        ${userStats.totalTeachers},
                        ${userStats.getTotalOrganizations()},
                        ${userStats.totalInactiveUsers}
                    ],
                    backgroundColor: ['#1770d1', '#1fb341', '#ba3441', '#6c757d'],
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        const barCtx = document.getElementById('barChart').getContext('2d');
        new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: [
                    'Курсы',
                    'Тесты',
                    'Сертификаты',
                    'Сертификаты (мес)',
                    'Завершённые курсы'
                ],
                datasets: [{
                    label: 'Количество',
                    data: [
                        ${userStats.totalCourses},
                        ${userStats.totalTests},
                        ${userStats.totalCertificates},
                        ${userStats.certificatesIssuedThisMonth},
                        ${userStats.completedCourses}
                    ],
                    backgroundColor: '#26818f'
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>

</@layout.page>