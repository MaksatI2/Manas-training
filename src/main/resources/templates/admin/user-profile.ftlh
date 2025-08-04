
<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Пользователи", "url": "/admin/users"},
    {"label": "Профиль", "url": ""}
    ] />

    <style>
        .profile-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .page-title {
            font-size: 2.5rem;
            text-align: center;
            margin-bottom: 2rem;
        }

        .profile-card {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
            padding: 2rem;
            transition: all 0.3s ease;
        }

        .profile-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 102, 204, 0.15);
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 2rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .avatar-container {
            position: relative;
            flex-shrink: 0;
            cursor: pointer;
        }

        .avatar-image {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--light-blue);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.2);
            transition: all 0.3s ease;
        }

        .avatar-image:hover {
            transform: scale(1.03);
            box-shadow: 0 6px 20px rgba(0, 102, 204, 0.3);
        }

        .avatar-edit-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .avatar-container:hover .avatar-edit-overlay {
            opacity: 1;
        }

        .avatar-edit-text {
            color: white;
            font-weight: 600;
            text-align: center;
            padding: 0.5rem;
        }

        .user-info {
            flex: 1;
            min-width: 250px;
        }

        .user-name {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .user-email {
            font-size: 1.2rem;
            color: var(--primary-blue);
            margin-bottom: 1rem;
        }

        .profile-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .detail-item {
            background: rgba(135, 206, 235, 0.05);
            padding: 1.5rem;
            border-radius: 10px;
            border-left: 3px solid var(--light-blue);
        }

        .detail-label {
            font-size: 0.9rem;
            color: var(--dark-blue);
            font-weight: 600;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .detail-value {
            font-size: 1rem;
            font-weight: 500;
        }

        .bio-section {
            grid-column: 1 / -1;
            background: rgba(135, 206, 235, 0.05);
            padding: 1.5rem;
            border-radius: 10px;
            border-left: 3px solid var(--light-blue);
        }

        .user-role,
        .edit-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            gap: 0.5rem;
            text-decoration: none;
            min-width: 220px;
            text-align: center;
            box-sizing: border-box;
        }

        .edit-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
            color: var(--white);
        }

        .user-role-and-edit {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            gap: 0.5rem;
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 8px;
            font-weight: 500;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .statistics-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .statistics-title {
            font-size: 2rem;
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
            background: linear-gradient(135deg, #0066cc, #003d7a);
            color: white;
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

        .card.course-card {
            border: none;
            border-radius: 10px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card.course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 102, 204, 0.15);
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
        }

        .card-subtitle {
            font-size: 1rem;
        }

        .btn-outline-primary {
            border-color: var(--primary-blue);
            color: var(--primary-blue);
        }

        .btn-outline-primary:hover {
            background-color: var(--primary-blue);
            color: var(--white);
        }

        .table-responsive {
            overflow-x: auto;
        }

        @media (max-width: 768px) {
            .page-title, .statistics-title {
                font-size: 1.8rem;
            }

            .profile-card, .statistics-container {
                padding: 1.5rem;
            }

            .profile-header {
                flex-direction: column;
                text-align: center;
                gap: 1.5rem;
            }

            .avatar-image {
                width: 120px;
                height: 120px;
            }

            .user-name {
                font-size: 1.5rem;
            }

            .profile-details {
                grid-template-columns: 1fr;
            }

            .stats-table th,
            .stats-table td {
                font-size: 0.9rem;
                padding: 0.7rem;
            }
        }
    </style>

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>

    <div class="profile-container">
        <#if successMessage??>
            <div class="alert alert-success">
                <i class="fas fa-check-circle" style="margin-right: 0.5rem;"></i>
                ${successMessage}
            </div>
        </#if>

        <#if errorMessage??>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle" style="margin-right: 0.5rem;"></i>
                ${errorMessage}
            </div>
        </#if>

        <h1 class="page-title">
            <i class="fas fa-user-circle" style="color: var(--primary-blue); margin-right: 0.5rem;"></i>
            Профиль пользователя
        </h1>

        <div class="profile-card">
            <div class="profile-header">
                <div class="avatar-container" >
                    <#if profile.user.avatarUrl?has_content>
                        <img src="/data/images/${profile.user.avatarUrl}"
                             class="avatar-image"
                             alt="Фото профиля">
                    <#else>
                        <img src="/static/images/default_avatar.jpg"
                             class="avatar-image"
                             alt="Фото профиля по умолчанию">
                    </#if>
                </div>

                <div class="user-info">
                    <h2 class="user-name">${profile.user.name} ${profile.user.lastName}</h2>
                    <p class="user-email">
                        <i class="fas fa-envelope" style="margin-right: 0.5rem;"></i>
                        ${profile.user.email}
                    </p>
                    <div class="user-role-and-edit">
                        <div class="user-role">
                            <i class="fas fa-user-tag" style="margin-right: 0.5rem;"></i>
                            Роль: ${profile.user.role.name}
                        </div>
                    </div>
                </div>
            </div>

            <div class="profile-details">
                <#if profile.user.phone?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-phone" style="margin-right: 0.5rem;"></i>
                            Телефон
                        </div>
                        <div class="detail-value">${profile.user.phone}</div>
                    </div>
                </#if>

                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-calendar-check" style="margin-right: 0.5rem;"></i>
                        Статус
                    </div>
                    <div class="detail-value">
                        <#if profile.user.isActive>
                            <span style="color: #28a745;">
                                <i class="fas fa-check-circle"></i> Активный
                            </span>
                        <#else>
                            <span style="color: #dc3545;">
                                <i class="fas fa-times-circle"></i> Неактивный
                            </span>
                        </#if>
                    </div>
                </div>

                <#if profile.specialization?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-laptop-code" style="margin-right: 0.5rem;"></i>
                            Специализация
                        </div>
                        <div class="detail-value">${profile.specialization}</div>
                    </div>
                </#if>

                <#if profile.organizationName?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-building" style="margin-right: 0.5rem;"></i>
                            Организация
                        </div>
                        <div class="detail-value">${profile.organizationName}</div>
                    </div>
                </#if>

                <#if profile.department?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-building" style="margin-right: 0.5rem;"></i>
                            Отделение
                        </div>
                        <div class="detail-value">${profile.department}</div>
                    </div>
                </#if>

                <#if profile.qualifications?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-certificate" style="margin-right: 0.5rem;"></i>
                            Квалификация
                        </div>
                        <div class="detail-value">${profile.qualifications}</div>
                    </div>
                </#if>

                <#if profile.organization?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-building" style="margin-right: 0.5rem;"></i>
                            Код организации
                        </div>
                        <div class="detail-value">${profile.organization.code}</div>
                    </div>
                    <#if profile.organization.description?has_content>
                        <div class="bio-section">
                            <div class="detail-label">
                                <i class="fas fa-info-circle" style="margin-right: 0.5rem;"></i>
                                Описание организации
                            </div>
                            <div class="detail-value">${profile.organization.description}</div>
                        </div>
                    </#if>
                </#if>

                <#if profile.bio?has_content>
                    <div class="bio-section">
                        <div class="detail-label">
                            <i class="fas fa-info-circle" style="margin-right: 0.5rem;"></i>
                            О себе
                        </div>
                        <div class="detail-value">${profile.bio}</div>
                    </div>
                </#if>
            </div>
        </div>

        <#if profile.user.role.name == "STUDENT">
            <div class="statistics-container">
                <h2 class="statistics-title">
                    <i class="fas fa-chart-bar" style="color: var(--primary-blue); margin-right: 0.5rem;"></i>
                    Статистика посещаемости
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
                    <h2 class="statistics-title">Результаты тестов</h2>
                    <table class="stats-table">
                        <thead>
                        <tr>
                            <th>Курс</th>
                            <th>Тест</th>
                            <th>Оценка</th>
                            <th>Статус</th>
                            <th>Дата сдачи</th>
                        </tr>
                        </thead>
                        <tbody>
                        <#list testResults as result>
                            <tr style="background-color: ${result.isPassed?string('#d4edda', '#f8d7da')}; color: ${result.isPassed?string('#155724', '#721c24')};">
                                <td>${result.courseTitle}</td>
                                <td>${result.testTitle}</td>
                                <td>${result.score}%</td>
                                <td>
                                    <#if result.isPassed>
                                        Пройден
                                    <#else>
                                        Не пройден
                                    </#if>
                                </td>
                                <td>
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
                </#if>
            </div>
        </#if>

        <#if profile.user.role.name == "TEACHER">
            <div class="statistics-container">
                <h2 class="statistics-title">
                    <i class="fas fa-book" style="color: var(--primary-blue); margin-right: 0.5rem;"></i>
                    Курсы преподавателя
                </h2>
                <#if courses?size == 0>
                    <div class="alert alert-info text-center" role="alert">
                        У преподавателя нет курсов.
                    </div>
                <#else>
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                        <#list courses as course>
                            <div class="col">
                                <div class="card course-card h-100 shadow-sm border-0 d-flex flex-column">
                                    <a href="/admin/course-instances/${course.courseInstanceId}" class="text-decoration-none text-body flex-grow-1 d-flex flex-column p-3">
                                        <h5 class="card-title mb-2">${course.courseTitle}</h5>
                                        <h6 class="card-subtitle mb-3 text-muted">${course.instanceTitle}</h6>
                                        <p class="card-text mt-auto">
                                            <span class="d-block text-muted small">Срок: ${course.startDate} – ${course.endDate}</span>
                                        </p>
                                    </a>
                                </div>
                            </div>
                        </#list>
                    </div>
                </#if>
            </div>
        </#if>

        <#if profile.user.role.name == "ORGANIZATION">
            <div class="statistics-container">
                <h2 class="statistics-title">
                    <i class="fas fa-users" style="color: var(--primary-blue); margin-right: 0.5rem;"></i>
                    Студенты организации
                </h2>
                <div class="table-responsive">
                    <table class="stats-table" id="studentsTable">
                        <thead>
                        <tr>
                            <th>ФИО</th>
                            <th>Email</th>
                            <th>Телефон</th>
                            <th>Курсы</th>
                        </tr>
                        </thead>
                        <tbody>
                        <#assign grouped = {} />
                        <#list students as s>
                            <#assign sid = s.studentId?string>
                            <#assign grouped = grouped + { (sid): (grouped[sid]![]) + [s] } >
                        </#list>
                        <#list grouped?keys as sid>
                            <#assign courseList = grouped[sid]>
                            <#assign first = courseList[0]>
                            <tr>
                                <td>${first.fullName}</td>
                                <td>${first.email}</td>
                                <td>${first.phone}</td>
                                <td>
                                    <ul class="mb-0 ps-3 small">
                                        <#list courseList as c>
                                            <li>
                                                <strong>${c.courseTitle}</strong> — ${c.localizedStatus}, ${c.progress}%
                                                <#if c.finalGrade??>, оценка: ${c.finalGrade}</#if>
                                            </li>
                                        </#list>
                                    </ul>
                                </td>
                            </tr>
                        </#list>
                        <#if students?size == 0>
                            <tr>
                                <td colspan="4">Нет студентов в организации.</td>
                            </tr>
                        </#if>
                        </tbody>
                    </table>
                </div>
            </div>
            <script>
                $(document).ready(function () {
                    $('#studentsTable').DataTable({
                        language: {
                            url: '/js/datatables/ru.json',
                            paginate: {previous: '‹', next: '›'}
                        },
                        responsive: true,
                        pageLength: 10,
                        order: [[0, 'asc']],
                        autoWidth: false,
                        info: false
                    });
                });
            </script>
        </#if>
    </div>
</@layout.page>