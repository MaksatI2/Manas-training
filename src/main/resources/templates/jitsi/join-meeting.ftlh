<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>ManasTraining - Видеоконференция</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="/static/css/jitsi.css" rel="stylesheet">
</head>
<body>

<div id="user-data" style="display: none;">
    <span id="user-id">${userId}</span>
    <span id="user-name">${userName}</span>
    <span id="user-role">${userRole}</span>
    <span id="meeting-id">${meeting.meetingId}</span>
    <span id="room-name">${meeting.roomName}</span>
</div>

<div id="jitsi-container" style="height: 100vh; width: 100vw;"></div>

<div id="custom-controls" style="position: fixed; bottom: 20px; right: 20px; z-index: 9999; display: none;">
    <div class="btn-group" role="group">
        <button type="button" class="btn btn-danger" onclick="leaveMeeting()">
            <i class="fas fa-phone-slash"></i> Покинуть
        </button>
        <button type="button" class="btn btn-warning" onclick="completeCall()" id="complete-btn" style="display: none;">
            <i class="fas fa-check-circle"></i> Завершить урок
        </button>
    </div>
</div>

<div class="loading-overlay" id="loading-overlay">
    <div class="loading-content">
        <div class="spinner"></div>
        <div id="loading-text">Подключение к видеоконференции...</div>
    </div>
</div>

<script src='/libs/external_api.min.js'></script>

<script>
    let jitsiApi = null;
    let userData = {
        id: document.getElementById('user-id')?.textContent?.trim() || null,
        name: document.getElementById('user-name')?.textContent?.trim() || 'Гость',
        role: document.getElementById('user-role')?.textContent?.trim() || 'STUDENT'
    };

    let meetingData = {
        id: document.getElementById('meeting-id')?.textContent?.trim() || null,
        roomName: document.getElementById('room-name')?.textContent?.trim() || null
    };

    let participantId = null;
    let hasJoinedMeeting = false;
    let pingInterval = null;

    document.addEventListener('DOMContentLoaded', function() {
        console.log('Инициализация с данными:', { userData, meetingData });

        if (!meetingData.roomName) {
            console.error('Отсутствует название комнаты');
            showError('Ошибка: не удалось получить данные комнаты');
            return;
        }

        if (typeof JitsiMeetExternalAPI === 'undefined') {
            console.error('Jitsi Meet External API не загружен');
            showError('Ошибка: не удалось загрузить Jitsi Meet API');
            return;
        }

        showLoading('Подключение к видеоконференции...');
        initializeJitsiMeet();
    });

    function initializeJitsiMeet() {
        const domain = window.location.hostname;
        const roomName = meetingData.roomName;

        console.log('Создание Jitsi Meet с параметрами:', {
            domain: domain,
            roomName: roomName,
            userName: userData.name
        });

        const options = {
            roomName: roomName,
            width: '100%',
            height: '100%',
            parentNode: document.querySelector('#jitsi-container'),
            configOverwrite: {
                prejoinPageEnabled: false,
                startWithAudioMuted: true,
                startWithVideoMuted: true,
                enableWelcomePage: false,
                enableClosePage: false,
                defaultLanguage: 'ru',
                disableDeepLinking: true,
                resolution: 720,
                constraints: {
                    video: {
                        height: { ideal: 720, max: 1080, min: 180 }
                    }
                },
                channelLastN: 20,
                enableLayerSuspension: true,
                websocket: 'wss://' + domain + '/xmpp-websocket',
                bosh: 'https://' + domain + '/http-bind',
                hosts: {
                    domain: domain,
                    muc: 'conference.' + domain
                },
                p2p: {
                    enabled: true,
                    stunServers: [
                        { urls: 'stun:stun.l.google.com:19302' },
                        { urls: 'stun:stun1.l.google.com:19302' }
                    ]
                }
            },
            interfaceConfigOverwrite: {
                TOOLBAR_BUTTONS: [
                    'microphone', 'camera', 'closedcaptions', 'desktop',
                    'fullscreen', 'fodeviceselection', 'hangup', 'profile',
                    'chat', 'raisehand', 'videoquality', 'filmstrip',
                    'invite', 'settings', 'tileview', 'select-background'
                ],
                SETTINGS_SECTIONS: [
                    'devices', 'language', 'moderator', 'profile'
                ],
                SHOW_JITSI_WATERMARK: false,
                SHOW_WATERMARK_FOR_GUESTS: false,
                SHOW_BRAND_WATERMARK: false,
                BRAND_WATERMARK_LINK: '',
                SHOW_POWERED_BY: false,
                GENERATE_ROOMNAMES_ON_WELCOME_PAGE: false,
                DISPLAY_WELCOME_PAGE_CONTENT: false,
                LANG_DETECTION: false,
                DEFAULT_LANGUAGE: 'ru',
                MOBILE_APP_PROMO: false
            },
            userInfo: {
                displayName: userData.name,
                email: userData.id ? `user${userId}@manastraining.kg` : undefined
            }
        };

        console.log('Создание Jitsi API с опциями:', options);

        try {
            jitsiApi = new JitsiMeetExternalAPI(domain, options);

            setupJitsiEvents();
            joinMeetingAutomatically();

        } catch (error) {
            console.error('Ошибка создания Jitsi API:', error);
            hideLoading();
            showError('Ошибка подключения к видеоконференции: ' + error.message);
        }
    }

    function setupJitsiEvents() {
        jitsiApi.addEventListener('videoConferenceJoined', (event) => {
            console.log('Присоединились к конференции:', event);
            hideLoading();
            hasJoinedMeeting = true;

            if (userData.role === 'TEACHER') {
                document.getElementById('complete-btn').style.display = 'block';
                document.getElementById('custom-controls').style.display = 'block';
            }

            initializePing();
        });

        jitsiApi.addEventListener('videoConferenceLeft', (event) => {
            console.log('Покинули конференцию:', event);
            cleanupAndRedirect();
        });

        jitsiApi.addEventListener('participantJoined', (event) => {
            console.log('Участник присоединился:', event);
        });

        jitsiApi.addEventListener('participantLeft', (event) => {
            console.log('Участник покинул встречу:', event);
        });

        jitsiApi.addEventListener('readyToClose', () => {
            console.log('Готовность к закрытию');
            cleanupAndRedirect();
        });

        jitsiApi.addEventListener('error', (error) => {
            console.error('Ошибка Jitsi:', error);
            showError('Ошибка видеоконференции: ' + (error.message || 'Неизвестная ошибка'));
        });

        jitsiApi.addEventListener('connectionFailed', (event) => {
            console.error('Ошибка подключения:', event);
            hideLoading();
            showError('Не удалось подключиться к видеоконференции. Проверьте интернет-соединение.');
        });

        setTimeout(() => {
            if (!hasJoinedMeeting) {
                console.warn('Таймаут подключения к конференции');
                hideLoading();
                showError('Таймаут подключения. Пожалуйста, попробуйте еще раз.');
            }
        }, 45000);
    }

    async function joinMeetingAutomatically() {
        if (!userData.id || !meetingData.id) {
            console.error('Недостаточно данных для присоединения к встрече');
            return;
        }

        try {
            const token = document.querySelector('meta[name="_csrf"]').content;
            const header = document.querySelector('meta[name="_csrf_header"]').content;

            const response = await fetch('/api/jitsi/meetings/join', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    ...(token && header ? { [header]: token } : {})
                },
                body: JSON.stringify({
                    meetingId: parseInt(meetingData.id),
                    userId: parseInt(userData.id),
                    participantName: userData.name
                })
            });

            if (response.ok) {
                const participantData = await response.json();
                participantId = participantData.participantId;
                console.log('Backend: успешно присоединились к встрече, participantId:', participantId);
            } else {
                console.error('Backend: ошибка присоединения к встрече:', response.status);
            }
        } catch (error) {
            console.error('Ошибка при присоединении к встрече на backend:', error);
        }
    }

    function initializePing() {
        if (participantId && meetingData.id) {
            pingInterval = setInterval(sendPing, 600000);
            sendPing();
            console.log('Ping инициализирован для участника:', participantId);
        }
    }

    async function sendPing() {
        if (!participantId || !meetingData.id) {
            return;
        }

        try {
            const token = document.querySelector('meta[name="_csrf"]').content;
            const header = document.querySelector('meta[name="_csrf_header"]').content;

            const response = await fetch('/api/jitsi/ping/heartbeat', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    ...(token && header ? { [header]: token } : {})
                },
                body: new URLSearchParams({
                    participantId: participantId,
                    meetingId: meetingData.id
                })
            });

            if (response.ok) {
                console.log('Ping отправлен успешно');
            } else {
                console.warn('Ошибка ping:', response.status);
            }
        } catch (error) {
            console.error('Ошибка отправки ping:', error);
        }
    }

    function stopPing() {
        if (pingInterval) {
            clearInterval(pingInterval);
            pingInterval = null;
            console.log('Ping остановлен');
        }
    }

    async function completeCall() {
        if (!userData.id || !meetingData.id) {
            showError('Ошибка: недостаточно данных для завершения встречи');
            return;
        }

        if (userData.role !== 'TEACHER') {
            showError('Только преподаватель может завершить урок');
            return;
        }

        if (!confirm('Вы уверены, что хотите завершить урок для всех участников?')) {
            return;
        }

        showLoading('Завершение встречи...');
        stopPing();

        try {
            const token = document.querySelector('meta[name="_csrf"]').content;
            const header = document.querySelector('meta[name="_csrf_header"]').content;

            const response = await fetch('/api/jitsi/meetings/end', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    ...(token && header ? { [header]: token } : {})
                },
                body: JSON.stringify({
                    meetingId: parseInt(meetingData.id),
                    teacherId: parseInt(userData.id)
                })
            });

            hideLoading();

            if (response.ok) {
                if (jitsiApi) {
                    jitsiApi.dispose();
                }

                alert('Урок завершен для всех участников');
                setTimeout(() => {
                    window.location.href = '/schedules';
                }, 1000);
            } else {
                const errorText = await response.text();
                showError('Ошибка завершения встречи: ' + errorText);
            }
        } catch (error) {
            hideLoading();
            console.error('Ошибка при завершении встречи:', error);
            showError('Ошибка сети при завершении встречи');
        }
    }

    async function leaveMeeting() {
        if (!confirm('Вы уверены, что хотите покинуть встречу?')) {
            return;
        }

        showLoading('Покидание встречи...');
        stopPing();

        try {
            if (participantId && meetingData.id) {
                const token = document.querySelector('meta[name="_csrf"]').content;
                const header = document.querySelector('meta[name="_csrf_header"]').content;

                const response = await fetch(`/api/jitsi/meetings/${meeting.meetingId}/leave`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        ...(token && header ? { [header]: token } : {})
                    },
                    body: JSON.stringify({
                        userId: parseInt(userData.id)
                    })
                });

                if (response.ok) {
                    console.log('Успешно покинули встречу на backend');
                }
            }

            if (jitsiApi) {
                jitsiApi.dispose();
            }

            cleanupAndRedirect();
        } catch (error) {
            console.error('Ошибка при покидании встречи:', error);
            if (jitsiApi) {
                jitsiApi.dispose();
            }
            cleanupAndRedirect();
        }
    }

    function cleanupAndRedirect() {
        stopPing();
        hideLoading();
        setTimeout(() => {
            window.location.href = '/schedules';
        }, 1000);
    }

    function showLoading(text) {
        const overlay = document.getElementById('loading-overlay');
        const loadingText = document.getElementById('loading-text');
        loadingText.textContent = text || 'Обработка запроса...';
        overlay.style.display = 'flex';
    }

    function hideLoading() {
        const overlay = document.getElementById('loading-overlay');
        overlay.style.display = 'none';
    }

    function showError(message) {
        hideLoading();
        alert('Ошибка: ' + message);
        console.error('Error:', message);
    }

    window.addEventListener('beforeunload', function(event) {
        stopPing();

        if (hasJoinedMeeting && participantId && meetingData.id) {
            const token = document.querySelector('meta[name="_csrf"]').content;
            const header = document.querySelector('meta[name="_csrf_header"]').content;

            const headers = new Headers();
            if (header && token) {
                headers.append(header, token);
            }
            headers.append('Content-Type', 'application/x-www-form-urlencoded');

            const data = new URLSearchParams();
            data.append('participantId', participantId);

            fetch(`/api/jitsi/meetings/${meeting.meetingId}/leave-by-participant`, {
                method: 'POST',
                headers: headers,
                body: data,
                keepalive: true
            });
        }
    });

    window.addEventListener('unload', function() {
        if (jitsiApi) {
            jitsiApi.dispose();
        }
        stopPing();
    });
</script>

<style>
    .loading-overlay {
        display: flex;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.8);
        z-index: 10000;
        justify-content: center;
        align-items: center;
    }

    .loading-content {
        text-align: center;
        color: white;
    }

    .spinner {
        border: 4px solid #f3f3f3;
        border-top: 4px solid #3498db;
        border-radius: 50%;
        width: 50px;
        height: 50px;
        animation: spin 1s linear infinite;
        margin: 0 auto 20px;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    #custom-controls .btn {
        margin: 0 5px;
    }

    #jitsi-container {
        background: #000;
    }
</style>

</body>
</html>