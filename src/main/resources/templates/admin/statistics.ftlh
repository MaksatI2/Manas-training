<#import "../layout.ftlh" as layout>
<@layout.page>
    <!-- Include Tailwind CSS via CDN for modern styling -->
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">

    <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold text-gray-900 text-center mb-8">Статистика системы</h1>

        <!-- Tabs Navigation -->
        <div class="border-b border-gray-200">
            <nav class="-mb-px flex space-x-8" aria-label="Tabs">
                <button id="general-tab" class="tab-button border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm active" onclick="showTab('general')">Общая статистика</button>
                <button id="teacher-tab" class="tab-button border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" onclick="showTab('teacher')">Статистика преподавателей</button>
            </nav>
        </div>

        <!-- Tab Content -->
        <div id="general-content" class="tab-content mt-6">
            <div class="stats-container grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 mb-12">
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">Студенты</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.totalStudents!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">Преподаватели</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.totalTeachers!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">Организации</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.totalOrganizations!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">Курсы</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.totalCourses!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">Сертификаты</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.totalCertificates!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">Завершённые курсы</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.completedCourses!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">Сертификаты в этом месяце</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.certificatesIssuedThisMonth!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">Средний балл по тестам</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.averageTestScore?string("0.0")!0}%</div>
                </div>
            </div>

            <div class="charts grid grid-cols-1 sm:grid-cols-2 gap-8">
                <div class="chart-container bg-white p-6 rounded-lg shadow-sm mx-auto w-full">
                    <h2 class="text-center text-lg font-semibold text-gray-900 mb-4">Соотношение ролей</h2>
                    <div class="relative h-80">
                        <canvas id="rolesPieChart" class="w-full h-full"></canvas>
                    </div>

                </div>
                <div class="chart-container bg-white p-6 rounded-lg shadow-sm mx-auto w-full">
                    <h2 class="text-center text-lg font-semibold text-gray-900 mb-4">Активность по категориям</h2>
                    <div class="relative h-80">
                        <canvas id="barChart" class="w-full h-full"></canvas>
                    </div>

                </div>
            </div>

        </div>

        <div id="teacher-content" class="tab-content mt-6 hidden">
            <div class="bg-white shadow-sm rounded-lg overflow-hidden">
                <div class="px-4 py-5 sm:px-6">
                    <h2 class="text-xl font-semibold text-gray-900">
                        Статистика преподавателей на
                        <span class="font-bold">${monthYear}</span>
                    </h2>
                    <p class="mt-1 text-sm text-gray-600">Ежемесячные часы преподавания по преподавателям</p>
                </div>

                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Имя</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Фамилия</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Часы преподавания</th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <#list teacherHourStats as teacher>
                            <tr class="hover:bg-gray-50">
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${teacher.name!''}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${teacher.lastName!''}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${teacher.totalHours!0}</td>
                            </tr>
                        <#else>
                            <tr>
                                <td colspan="3" class="px-6 py-4 text-center text-sm text-gray-500">Нет данных о преподавателях</td>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Общие настройки для Chart.js
        Chart.defaults.font.family = 'Inter, system-ui, sans-serif';
        Chart.defaults.font.size = 14;
        Chart.defaults.color = '#333';

        // Круговая диаграмма (Pie Chart)
        const pieCtx = document.getElementById('rolesPieChart').getContext('2d');
        new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: ['Студенты', 'Преподаватели', 'Организации', 'Неактивные'],
                datasets: [{
                    label: 'Пользователи',
                    data: [
                        ${userStats.totalStudents!0},
                        ${userStats.totalTeachers!0},
                        ${userStats.totalOrganizations!0},
                        ${userStats.totalInactiveUsers!0}
                    ],
                    backgroundColor: ['#a3bffa', '#f9a8d4', '#a7f3d0', '#d4d4d8'],
                    borderColor: '#ffffff',
                    borderWidth: 2,
                    hoverOffset: 30,
                    hoverBorderWidth: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            font: {
                                size: 14,
                                weight: '500'
                            },
                            padding: 20,
                            usePointStyle: true,
                            boxWidth: 10
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.85)',
                        titleFont: { size: 16, weight: '600' },
                        bodyFont: { size: 14 },
                        padding: 12,
                        cornerRadius: 8,
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.raw;
                                const total = context.dataset.data.reduce((sum, val) => sum + val, 0);
                                const percentage = ((value / total) * 100).toFixed(1);
                                return label + ': ' + value + ' (' + percentage + '%)';
                            }
                        }
                    }
                },
                animation: {
                    animateScale: true,
                    animateRotate: true,
                    duration: 1200,
                    easing: 'easeOutQuart'
                }
            }
        });

        // Столбчатая диаграмма (Bar Chart)
        const barCtx = document.getElementById('barChart').getContext('2d');
        const barChart = new Chart(barCtx, {
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
                        ${userStats.totalCourses!0},
                        ${userStats.totalTests!0},
                        ${userStats.totalCertificates!0},
                        ${userStats.certificatesIssuedThisMonth!0},
                        ${userStats.completedCourses!0}
                    ],
                    backgroundColor: function(context) {
                        const chart = context.chart;
                        const {ctx, chartArea} = chart;
                        if (!chartArea) return;
                        const gradient = ctx.createLinearGradient(0, chartArea.bottom, 0, chartArea.top);
                        gradient.addColorStop(0, 'rgba(59, 130, 246, 0.8)');
                        gradient.addColorStop(1, 'rgba(59, 130, 246, 0.2)');
                        return gradient;
                    },
                    borderColor: '#3b82f6',
                    borderWidth: 2,
                    borderRadius: 12,
                    barThickness: 36,
                    hoverBackgroundColor: 'rgba(59, 130, 246, 0.9)',
                    hoverBorderColor: '#1d4ed8',
                    hoverBorderWidth: 3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            font: {
                                size: 12,
                                weight: '500'
                            },
                            color: '#4b5563'
                        }
                    },
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: '#e5e7eb',
                            drawBorder: false
                        },
                        ticks: {
                            font: {
                                size: 12
                            },
                            color: '#4b5563',
                            stepSize: Math.ceil(Math.max(
                                ${userStats.totalCourses!0},
                                ${userStats.totalTests!0},
                                ${userStats.totalCertificates!0},
                                ${userStats.certificatesIssuedThisMonth!0},
                                ${userStats.completedCourses!0}
                            ) / 5)
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.85)',
                        titleFont: { size: 16, weight: '600' },
                        bodyFont: { size: 14 },
                        padding: 12,
                        cornerRadius: 8,
                        callbacks: {
                            label: function(context) {
                                return context.dataset.label + ': ' + context.raw;
                            }
                        }
                    }
                },
                animation: {
                    duration: 1200,
                    easing: 'easeOutQuart',
                    onProgress: function(animation) {
                        const chart = animation.chart;
                        chart.data.datasets[0].backgroundColor = chart.data.datasets[0].backgroundColor;
                        chart.update();
                    }
                },
                hover: {
                    mode: 'nearest',
                    intersect: true,
                    animationDuration: 400
                }
            }
        });

        // Tab switching logic
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

        // Initialize with General Statistics tab active
        showTab('general');
    </script>
</@layout.page>