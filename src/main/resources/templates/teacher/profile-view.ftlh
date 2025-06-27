<#import "../layout.ftlh" as layout>
<@layout.page>
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
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
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

        <div class="profile-card">
            <div class="profile-header">
                <div class="avatar-container" onclick="window.location.href='/image/upload'">
                    <#if teacher.teacher.avatarUrl?has_content>
                        <img src="/data/images/${teacher.teacher.avatarUrl}"
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
                    <h2 class="user-name">${teacher.teacher.name} ${teacher.teacher.lastName}</h2>
                    <p class="user-email">
                        <i class="fas fa-envelope" style="margin-right: 0.5rem;"></i>
                        ${teacher.teacher.email}
                    </p>
                    <div class="user-role-and-edit">
                    <span class="user-role">
                        <i class="fas fa-chalkboard-teacher" style="margin-right: 0.5rem;"></i>
                        Тип аккаунта Преподаватель
                    </span>
                    <a href="/teacher/profile/edit" class="edit-button">
                        <i class="fas fa-edit"></i>
                        Редактировать профиль
                    </a>
                    </div>
                </div>
            </div>

            <div class="profile-details">
                <#if teacher.teacher.phone?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-phone" style="margin-right: 0.5rem;"></i>
                            Телефон
                        </div>
                        <div class="detail-value">${teacher.teacher.phone}</div>
                    </div>
                </#if>

                <#if teacher.department?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-building" style="margin-right: 0.5rem;"></i>
                            Отделение
                        </div>
                        <div class="detail-value">${teacher.department}</div>
                    </div>
                </#if>

                <#if teacher.qualifications?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-certificate" style="margin-right: 0.5rem;"></i>
                            Квалификация
                        </div>
                        <div class="detail-value">${teacher.qualifications}</div>
                    </div>
                </#if>

                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-calendar-check" style="margin-right: 0.5rem;"></i>
                        Статус
                    </div>
                    <div class="detail-value">
                        <#if teacher.teacher.isActive>
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

                <#if teacher.bio?has_content>
                    <div class="bio-section">
                        <div class="detail-label">
                            <i class="fas fa-info-circle" style="margin-right: 0.5rem;"></i>
                            О себе
                        </div>
                        <div class="detail-value">${teacher.bio}</div>
                    </div>
                </#if>
            </div>
        </div>
    </div>
</@layout.page>