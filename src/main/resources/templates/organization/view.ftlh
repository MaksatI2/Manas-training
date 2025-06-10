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
            border-left: 4px solid var(--primary-blue);
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
        }

        .avatar-image {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--light-blue);
            box-shadow: 0 4px 15px rgba(0,102,204,0.2);
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

        .user-role {
            display: inline-block;
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 500;
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

        .edit-button {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            border: none;
            padding: 0.8rem 2rem;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            margin-top: 1rem;
        }

        .edit-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
            color: var(--white);
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
        <h1 class="page-title">
            <i class="fas fa-user-circle" style="color: var(--primary-blue); margin-right: 0.5rem;"></i>
            Личный кабинет
        </h1>

        <div class="profile-card">
            <div class="profile-header">
                <div class="avatar-container">
                    <#if organization.user.avatarUrl?has_content>
                        <img src="/data/images/${organization.user.avatarUrl}"
                             class="avatar-image"
                             alt="Фото профиля">
                    <#else>
                        <img src="/static/images/default_avatar.jpg"
                             class="avatar-image"
                             alt="Фото профиля по умолчанию">
                    </#if>
                    <a href="/image/upload" class="edit-button">
                        <i class="fas fa-edit"></i>
                        Загрузить изображение
                    </a>
                </div>

                <div class="user-info">
                    <h2 class="user-name">${organization.user.name} ${organization.user.lastName}</h2>
                    <p class="user-email">
                        <i class="fas fa-envelope" style="margin-right: 0.5rem;"></i>
                        ${organization.user.email}
                    </p>
                    <span class="user-role">
                        <i class="fas fa-building" style="margin-right: 0.5rem;"></i>
                        Менеджер организации
                    </span>
                    <a href="/organization/profile/edit" class="edit-button">
                        <i class="fas fa-edit"></i>
                        Редактировать профиль
                    </a>
                </div>
            </div>

            <div class="profile-details">
                <#if organization.user.phone?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-phone" style="margin-right: 0.5rem;"></i>
                            Телефон
                        </div>
                        <div class="detail-value">${organization.user.phone}</div>
                    </div>
                </#if>

                <#if organization.organization?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-building" style="margin-right: 0.5rem;"></i>
                            Организация
                        </div>
                        <div class="detail-value">${organization.organization.description}</div>
                    </div>
                </#if>

                <#if organization.organization?has_content>
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-building" style="margin-right: 0.5rem;"></i>
                            Код организации
                        </div>
                        <div class="detail-value">${organization.organization.code}</div>
                    </div>
                </#if>

                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-calendar-check" style="margin-right: 0.5rem;"></i>
                        Статус
                    </div>
                    <div class="detail-value">
                        <#if organization.user.isActive>
                            <span style="color: #28a745;">
                                <i class="fas fa-check-circle"></i> Активная
                            </span>
                        <#else>
                            <span style="color: #dc3545;">
                                <i class="fas fa-times-circle"></i> Неактивная
                            </span>
                        </#if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</@layout.page>