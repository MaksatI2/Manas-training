<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<#assign pageTitle = springMacroRequestContext.getMessage("statistics.title")>
<#assign tabGeneral = springMacroRequestContext.getMessage("statistics.tab.general")>
<#assign tabTeachers = springMacroRequestContext.getMessage("statistics.tab.teachers")>

<#assign cardStudents = springMacroRequestContext.getMessage("statistics.general.students")>
<#assign cardTeachers = springMacroRequestContext.getMessage("statistics.general.teachers")>
<#assign cardOrganizations = springMacroRequestContext.getMessage("statistics.general.organizations")>
<#assign cardCourses = springMacroRequestContext.getMessage("statistics.general.courses")>
<#assign cardCertificates = springMacroRequestContext.getMessage("statistics.general.certificates")>
<#assign cardCompletedCourses = springMacroRequestContext.getMessage("statistics.general.completedCourses")>
<#assign cardCertificatesMonth = springMacroRequestContext.getMessage("statistics.general.certificatesThisMonth")>
<#assign cardAverageScore = springMacroRequestContext.getMessage("statistics.general.averageTestScore")>

<#assign chartRoles = springMacroRequestContext.getMessage("statistics.general.rolesChart")>
<#assign chartActivity = springMacroRequestContext.getMessage("statistics.general.activityChart")>
<#assign labelInactive = springMacroRequestContext.getMessage("statistics.general.inactive")!'Неактивные'>
<#assign labelTests = springMacroRequestContext.getMessage("statistics.general.tests")!'Тесты'>

<#assign teachersTitle = springMacroRequestContext.getMessage("statistics.teachers.title")>
<#assign monthLabel = springMacroRequestContext.getMessage("statistics.teachers.month")>
<#assign yearLabel = springMacroRequestContext.getMessage("statistics.teachers.year")>
<#assign refreshText = springMacroRequestContext.getMessage("statistics.teachers.refresh")>
<#assign teachersSubtitle = springMacroRequestContext.getMessage("statistics.teachers.subtitle")>
<#assign tName = springMacroRequestContext.getMessage("statistics.teachers.table.name")>
<#assign tLastName = springMacroRequestContext.getMessage("statistics.teachers.table.lastName")>
<#assign tHours = springMacroRequestContext.getMessage("statistics.teachers.table.hours")>
<#assign loadingText = springMacroRequestContext.getMessage("statistics.teachers.loading")>
<#assign noDataText = springMacroRequestContext.getMessage("statistics.teachers.noData")>
<#assign errorText = springMacroRequestContext.getMessage("statistics.teachers.error")>

<@layout.page>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">

    <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold text-gray-900 text-center mb-8">${pageTitle}</h1>

        <div class="border-b border-gray-200">
            <nav class="-mb-px flex space-x-8" aria-label="Tabs">
                <button id="general-tab"
                        class="tab-button border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm active"
                        onclick="showTab('general')">${tabGeneral}
                </button>
                <button id="teacher-tab"
                        class="tab-button border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"
                        onclick="showTab('teacher')">${tabTeachers}
                </button>
            </nav>
        </div>

        <div id="general-content" class="tab-content mt-6">
            <div class="stats-container grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 mb-12">
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">${cardStudents}</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.totalStudents!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">${cardTeachers}</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.totalTeachers!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">${cardOrganizations}</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.totalOrganizations!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">${cardCourses}</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.totalCourses!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">${cardCertificates}</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.totalCertificates!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">${cardCompletedCourses}</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.completedCourses!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">${cardCertificatesMonth}</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.certificatesIssuedThisMonth!0}</div>
                </div>
                <div class="stat-card bg-white border border-gray-200 rounded-lg p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="stat-title text-gray-500 font-semibold text-sm mb-2">${cardAverageScore}</div>
                    <div class="stat-value text-2xl font-bold text-gray-900">${userStats.averageTestScore?string("0.0")!0}
                        %
                    </div>
                </div>
            </div>

            <div class="charts grid grid-cols-1 sm:grid-cols-2 gap-8">
                <div class="chart-container bg-white p-6 rounded-lg shadow-sm mx-auto w-full">
                    <h2 class="text-center text-lg font-semibold text-gray-900 mb-4">${chartRoles}</h2>
                    <div class="relative h-80">
                        <canvas id="rolesPieChart" class="w-full h-full"></canvas>
                    </div>
                </div>
                <div class="chart-container bg-white p-6 rounded-lg shadow-sm mx-auto w-full">
                    <h2 class="text-center text-lg font-semibold text-gray-900 mb-4">${chartActivity}</h2>
                    <div class="relative h-80">
                        <canvas id="barChart" class="w-full h-full"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <div id="teacher-content" class="tab-content mt-6 hidden">
            <div class="bg-white shadow-sm rounded-lg overflow-hidden">
                <div class="px-4 py-5 sm:px-6">
                    <h2 class="text-xl font-semibold text-gray-900">${teachersTitle}</h2>
                    <div class="flex flex-col sm:flex-row gap-4 items-end mt-4">
                        <div class="flex flex-col">
                            <label for="month-select"
                                   class="text-sm font-medium text-gray-700 mb-1">${monthLabel}</label>
                            <div class="relative">
                                <select id="month-select"
                                        class="appearance-none w-48 pl-3 pr-10 py-2 text-sm border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                    <#list months as month>
                                        <option value="${month.monthNumber}">${month.russianName}</option>
                                    </#list>
                                </select>
                                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3 text-gray-400">
                                    <svg class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                        <path fill-rule="evenodd"
                                              d="M10 12a1 1 0 01-.707-.293l-3-3a1 1 0 011.414-1.414L10 9.586l2.293-2.293a1 1 0 111.414 1.414l-3 3A1 1 0 0110 12z"
                                              clip-rule="evenodd"/>
                                    </svg>
                                </div>
                            </div>
                        </div>

                        <div class="flex flex-col">
                            <label for="year-select" class="text-sm font-medium text-gray-700 mb-1">${yearLabel}</label>
                            <div class="relative">
                                <select id="year-select"
                                        class="appearance-none w-32 pl-3 pr-10 py-2 text-sm border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                </select>
                                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3 text-gray-400">
                                    <svg class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                        <path fill-rule="evenodd"
                                              d="M10 12a1 1 0 01-.707-.293l-3-3a1 1 0 011.414-1.414L10 9.586l2.293-2.293a1 1 0 111.414 1.414l-3 3A1 1 0 0110 12z"
                                              clip-rule="evenodd"/>
                                    </svg>
                                </div>
                            </div>
                        </div>
                        <button id="fetch-stats"
                                class="mt-6 bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">${refreshText}</button>
                    </div>

                    <p class="mt-1 text-sm text-gray-600">${teachersSubtitle}</p>
                </div>
                <div class="overflow-x-auto">
                    <table id="teacher-table" class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">${tName}</th>
                            <th scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">${tLastName}</th>
                            <th scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">${tHours}</th>
                        </tr>
                        </thead>
                        <tbody id="teacher-table-body" class="bg-white divide-y divide-gray-200">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        Chart.defaults.font.family = 'Inter, system-ui, sans-serif';
        Chart.defaults.font.size = 14;
        Chart.defaults.color = '#333';

        const pieCtx = document.getElementById('rolesPieChart').getContext('2d');
        new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: ['${cardStudents}', '${cardTeachers}', '${cardOrganizations}', '${labelInactive}'],
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
                            font: {size: 14, weight: '500'},
                            padding: 20,
                            usePointStyle: true,
                            boxWidth: 10
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.85)',
                        titleFont: {size: 16, weight: '600'},
                        bodyFont: {size: 14},
                        padding: 12,
                        cornerRadius: 8,
                        callbacks: {
                            label: function (context) {
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

        const barCtx = document.getElementById('barChart').getContext('2d');
        const barChart = new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: ['${cardCourses}', '${labelTests}', '${cardCertificates}', '${cardCertificatesMonth}', '${cardCompletedCourses}'],
                datasets: [{
                    label: 'Количество',
                    data: [
                        ${userStats.totalCourses!0},
                        ${userStats.totalTests!0},
                        ${userStats.totalCertificates!0},
                        ${userStats.certificatesIssuedThisMonth!0},
                        ${userStats.completedCourses!0}
                    ],
                    backgroundColor: function (context) {
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
                        grid: {display: false},
                        ticks: {
                            font: {size: 12, weight: '500'},
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
                    legend: {display: false},
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.85)',
                        titleFont: {size: 16, weight: '600'},
                        bodyFont: {size: 14},
                        padding: 12,
                        cornerRadius: 8,
                        callbacks: {
                            label: function (context) {
                                return context.dataset.label + ': ' + context.raw;
                            }
                        }
                    }
                },
                animation: {
                    duration: 1200,
                    easing: 'easeOutQuart',
                    onProgress: function (animation) {
                        const chart = animation.chart;
                        chart.data.datasets[0].backgroundColor = chart.data.datasets[0].backgroundColor;
                        chart.update();
                    }
                },
                hover: {mode: 'nearest', intersect: true, animationDuration: 400}
            }
        });

        function showTab(tabName) {
            document.querySelectorAll('.tab-content').forEach(content => content.classList.add('hidden'));
            document.querySelectorAll('.tab-button').forEach(button => {
                button.classList.remove('border-blue-500', 'text-blue-600', 'active');
                button.classList.add('border-transparent', 'text-gray-500', 'hover:text-gray-700', 'hover:border-gray-300');
            });
            document.getElementById(tabName + '-content').classList.remove('hidden');
            document.getElementById(tabName + '-tab').classList.remove('border-transparent', 'text-gray-500', 'hover:text-gray-700', 'hover:border-gray-300');
            document.getElementById(tabName + '-tab').classList.add('border-blue-500', 'text-blue-600', 'active');
            if (tabName === 'teacher') {
                initializeTeacherStats();
            }
        }

        function initializeTeacherStats() {
            const currentDate = new Date();
            const currentMonth = currentDate.getMonth() + 1;
            const currentYear = currentDate.getFullYear();
            document.getElementById('month-select').value = currentMonth;
            fetchYears();
            fetchTeacherStats(currentMonth, currentYear);
        }

        function fetchYears() {
            fetch('/admin/courses/api/years')
                .then(response => response.json())
                .then(years => {
                    const yearSelect = document.getElementById('year-select');
                    yearSelect.innerHTML = '';
                    years.forEach(year => {
                        const option = document.createElement('option');
                        option.value = year;
                        option.textContent = year;
                        yearSelect.appendChild(option);
                    });
                    yearSelect.value = new Date().getFullYear();
                })
                .catch(error => console.error('Error fetching years:', error));
        }

        function fetchTeacherStats(month, year) {
            const tableBody = document.getElementById('teacher-table-body');
            tableBody.innerHTML = '<tr><td colspan="3" class="px-6 py-4 text-center text-sm text-gray-500">${loadingText}</td></tr>';
            const url = "/admin/courses/api/teacher-hours?month=" + month + "&year=" + year;
            fetch(url)
                .then(response => response.json())
                .then(data => {
                    tableBody.innerHTML = '';
                    if (data.length === 0) {
                        tableBody.innerHTML = '<tr><td colspan="3" class="px-6 py-4 text-center text-sm text-gray-500">${noDataText}</td></tr>';
                        return;
                    }
                    data.forEach(teacher => {
                        const row = document.createElement('tr');
                        row.classList.add('hover:bg-gray-50');
                        row.innerHTML =
                            '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">' + (teacher.name || '') + '</td>' +
                            '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">' + (teacher.lastName || '') + '</td>' +
                            '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">' + (teacher.totalHours || 0) + '</td>';
                        tableBody.appendChild(row);
                    });
                })
                .catch(error => {
                    console.error('Error fetching teacher stats:', error);
                    tableBody.innerHTML = '<tr><td colspan="3" class="px-6 py-4 text-center text-sm text-gray-500">${errorText}</td></tr>';
                });
        }

        document.getElementById('fetch-stats').addEventListener('click', () => {
            const month = document.getElementById('month-select').value;
            const year = document.getElementById('year-select').value;
            fetchTeacherStats(month, year);
        });

        showTab('general');
    </script>
</@layout.page>
