<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
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

        .avatar-image:hover {
            transform: scale(1.03);
            box-shadow: 0 6px 20px rgba(0,102,204,0.3);
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

        .profile-card {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
            padding: 2rem;
            transition: all 0.3s ease;
        }

        .profile-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,102,204,0.15);
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
            box-shadow: 0 4px 15px rgba(0,102,204,0.2);
            transition: all 0.3s ease;
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
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
            color: var(--white);
        }

        .user-role-and-edit {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            gap: 0.5rem;
        }


        @media (max-width: 768px) {
            .page-title {
                font-size: 2rem;
            }

            .profile-card {
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
        }
    </style>

    <div class="profile-container">
        <#if successMessage??>
            <div id="successMessage" data-message="${successMessage?js_string}"></div>
        </#if>
        <#if errorMessage??>
            <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
        </#if>
        <h1 class="page-title">
            <i class="fas fa-user-circle" style="color: var(--primary-blue); margin-right: 0.5rem;"></i>
            Личный кабинет
        </h1>

        <div class="profile-card">
            <div class="profile-header">
                <div class="avatar-container" onclick="window.location.href='/image/upload'">
                    <#if student.student.avatarUrl?has_content>
                        <img src="/data/images/${student.student.avatarUrl}"
                             class="avatar-image"
                             alt="Фото профиля">
                    <#else>
                        <img src="/static/images/default_avatar.jpg"
                             class="avatar-image"
                             alt="Фото профиля по умолчанию">
                    </#if>
                    <div class="avatar-edit-overlay">
                        <div class="avatar-edit-text">
                            <i class="fa-solid fa-pencil"></i><br>
                            Изменить фото
                        </div>
                    </div>
                </div>

                <div class="user-info">
                    <h2 class="user-name">${student.student.name} ${student.student.lastName}</h2>
                    <p class="user-email">
                        <i class="fas fa-envelope" style="margin-right: 0.5rem;"></i>
                        ${student.student.email}
                    </p>
                    <div class="user-role-and-edit">
                        <a href="/student/profile/edit" class="edit-button">
                            <i class="fas fa-edit"></i>
                            Редактировать профиль
                        </a>
                        <a href="/student/statistics" class="edit-button">
                            <i class="fas fa-chart-bar"></i>
                            Моя статистика
                        </a>

                    </div>

                </div>
            </div>

            <div class="profile-details">
                <#if student.student.phone?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-phone" style="margin-right: 0.5rem;"></i>
                            Телефон
                        </div>
                        <div class="detail-value">${student.student.phone}</div>
                    </div>
                </#if>

                <#if student.specialization?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-laptop-code" style="margin-right: 0.5rem;"></i>
                            Специализация
                        </div>
                        <div class="detail-value">${student.specialization}</div>
                    </div>
                </#if>

                <#if student.organization?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-building" style="margin-right: 0.5rem;"></i>
                            Организация
                        </div>
                        <div class="detail-value">${student.organizationName}</div>
                    </div>
                </#if>

                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-calendar-check" style="margin-right: 0.5rem;"></i>
                        Статус
                    </div>
                    <div class="detail-value">
                        <#if student.student.isActive>
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
            </div>
        </div>
    </div>
</@layout.page>