<#include "../layout.ftlh">

<@page>
    <div class="hero-section">
        <h1 class="hero-title">
            <i class="fas fa-mobile-alt me-3"></i>
            Управление устройствами
        </h1>
        <p class="hero-subtitle">Управляйте устройствами, на которых вы остались авторизованы</p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <#if message??>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </#if>

            <div class="feature-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="mb-0">
                        <i class="fas fa-devices me-2"></i>Активные устройства
                    </h4>
                    <form action="/auth/logout-all-devices" method="post">
                        <#if _csrf??>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        </#if>
                        <button type="button" class="btn btn-danger btn-sm"
                                data-bs-toggle="modal"
                                data-bs-target="#confirmModal"
                                data-action="/auth/logout-all-devices"
                                data-message="Вы уверены, что хотите выйти из всех устройств?">
                            <i class="fas fa-sign-out-alt me-1"></i>Выйти из всех устройств
                        </button>
                    </form>
                </div>

                <#if activeTokens?? && activeTokens?size gt 0>
                    <div class="row">
                        <#list activeTokens as token>
                            <div class="col-md-6 mb-3">
                                <div class="card border-left-primary">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div class="flex-grow-1">

                                                <div class="small text-muted mb-2">
                                                    <div class="mb-1">
                                                        <i class="fas fa-map-marker-alt me-1"></i>
                                                        IP: ${token.ipAddress!'Неизвестно'}
                                                    </div>
                                                    <div class="mb-1">
                                                        <i class="fas fa-clock me-1"></i>
                                                        Создан: ${token.getCreatedAtFormatted()}
                                                    </div>
                                                    <#if token.lastUsedAt??>
                                                        <div class="mb-1">
                                                            <i class="fas fa-history me-1"></i>
                                                            Последнее использование: ${token.getLastUsedAtFormatted()}
                                                        </div>
                                                    </#if>
                                                    <div>
                                                        <i class="fas fa-calendar-times me-1"></i>
                                                        Истекает: ${token.getExpiresAtFormatted()}
                                                    </div>
                                                </div>

                                                <#if token.userAgent??>
                                                    <div class="small text-muted" style="font-size: 0.75rem;">
                                                        <i class="fas fa-info-circle me-1"></i>
                                                        ${token.userAgent?truncate(60, "...")}
                                                    </div>
                                                </#if>
                                            </div>

                                            <div class="flex-shrink-0 ms-3">
                                                <form action="/auth/revoke-token" method="post">
                                                    <#if _csrf??>
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    </#if>
                                                    <input type="hidden" name="tokenId" value="${token.id}"/>
                                                    <!-- Кнопка "Отключить устройство" -->
                                                    <button type="button" class="btn btn-outline-danger btn-sm"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#confirmModal"
                                                            data-action="/auth/revoke-token"
                                                            data-message="Отключить это устройство?"
                                                            data-token-id="${token.id}"
                                                            title="Отключить устройство">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </#list>
                    </div>
                <#else>
                    <div class="text-center py-5">
                        <i class="fas fa-mobile-alt fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">Нет активных устройств</h5>
                        <p class="text-muted">
                            Устройства будут отображаться здесь после того, как вы воспользуетесь функцией "Запомнить меня" при входе.
                        </p>
                    </div>
                </#if>
            </div>

            <div class="text-center mt-4">
                <a href="/" class="btn btn-outline-primary">
                    <i class="fas fa-home me-1"></i>Вернуться на главную
                </a>
            </div>
        </div>
        <div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <form method="post">
                        <#if _csrf??>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        </#if>
                        <input type="hidden" name="tokenId" id="modalTokenId"/>
                        <div class="modal-header">
                            <h5 class="modal-title">Подтверждение действия</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body" id="modalMessage"></div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                            <button type="submit" class="btn btn-danger">Подтвердить</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </div>

    <script>
        function getDeviceIcon(userAgent) {
            const ua = userAgent.toLowerCase();
            if (ua.includes('mobile') || ua.includes('android') || ua.includes('iphone')) {
                return 'mobile-alt';
            } else if (ua.includes('tablet') || ua.includes('ipad')) {
                return 'tablet-alt';
            } else {
                return 'desktop';
            }
        }

        function getDeviceName(userAgent) {
            const ua = userAgent.toLowerCase();
            if (ua.includes('chrome')) {
                return 'Google Chrome';
            } else if (ua.includes('firefox')) {
                return 'Mozilla Firefox';
            } else if (ua.includes('safari') && !ua.includes('chrome')) {
                return 'Safari';
            } else if (ua.includes('edge')) {
                return 'Microsoft Edge';
            } else if (ua.includes('opera')) {
                return 'Opera';
            } else if (ua.includes('android')) {
                return 'Android устройство';
            } else if (ua.includes('iphone')) {
                return 'iPhone';
            } else if (ua.includes('ipad')) {
                return 'iPad';
            } else {
                return 'Неизвестное устройство';
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const deviceCards = document.querySelectorAll('.card-title');
            deviceCards.forEach(card => {
                const userAgent = card.getAttribute('data-user-agent');
                if (userAgent) {
                    const icon = card.querySelector('i');
                    const deviceName = getDeviceName(userAgent);
                    const deviceIcon = getDeviceIcon(userAgent);

                    card.lastChild.textContent = deviceName;
                }
            });
        });
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const confirmModal = document.getElementById('confirmModal');
            const modalMessage = document.getElementById('modalMessage');
            const modalTokenId = document.getElementById('modalTokenId');
            const form = confirmModal.querySelector('form');

            confirmModal.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                const action = button.getAttribute('data-action');
                const message = button.getAttribute('data-message');
                const tokenId = button.getAttribute('data-token-id');

                form.setAttribute('action', action);
                modalMessage.textContent = message || 'Вы уверены?';
                modalTokenId.value = tokenId || '';
            });
        });
    </script>

</@page>